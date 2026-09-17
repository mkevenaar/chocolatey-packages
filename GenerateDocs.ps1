<#
.SYNOPSIS
Generates the package and extension documentation and navigation for the docs site.
.PARAMETER OutputPath
Destination directory. Defaults to the docs directory beside this script.
#>
[CmdletBinding()]
param(
  [ValidateNotNullOrEmpty()]
  [string]$OutputPath = (Join-Path $PSScriptRoot 'docs')
)

# Based on the script from Chocolatey Software (https://github.com/chocolatey/choco/).
# Special thanks to Glenn Sarti (https://github.com/glennsarti) for his help on this.
$ErrorActionPreference = 'Stop'
$lineFeed = "`r`n"
$sourceLocation = 'https://github.com/mkevenaar/chocolatey-packages/tree/master'
$docsFolder = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
$packageFolders = 'automatic', 'extensions', 'deprecated', 'manual'
$pages = [ordered]@{}
$navigation = New-Object 'System.Collections.Generic.List[string]'
$generatedFolders = New-Object 'System.Collections.Generic.List[string]'
$functionLinks = @{}

function ConvertTo-DocumentationText {
  param([string]$Text)

  # Normalize CRLF as well as LF, without adding a second carriage return.
  return $Text -replace '\r\n|\r|\n', $lineFeed
}

function ConvertTo-MarkdownLabel {
  param([string]$Text)

  return $Text -replace '([\\`*_[\]<>])', '\$1'
}

function Format-MarkdownLine {
  param([string]$Line)

  # Wrap prose at spaces outside links and code spans. Leave tables, headings,
  # reference definitions, HTML and indented code to their own renderers.
  if ($Line.Length -le 80 -or $Line -match '^\s*(#|>|<|\[.+\]:)|^( {4}|\t)' -or $Line.Contains('|')) {
    return $Line
  }
  $prefix = [regex]::Match($Line, '^\s*(?:[-*+] |\d+[.)] )?').Value
  $continuation = ' ' * $prefix.Length
  $pattern = '(?<code>`+).*?\k<code>|\[[^\]]*\]\([^)]+\)|\[[^\]]*\]\[[^\]]*\]|<[^>]+>|(?<space>[ \t]+)'
  $spaces = @([regex]::Matches($Line, $pattern) | Where-Object {
    $_.Groups['space'].Success -and $_.Index -ge $prefix.Length -and
    $Line.Substring($_.Index + $_.Length) -notmatch '^(?:[#>*+-]|\d+[.)])\s'
  })
  $start = 0
  $indent = ''
  while ($Line.Length - $start + $indent.Length -gt 80) {
    $boundary = $spaces | Where-Object { $_.Index -gt $start -and $_.Index - $start + $indent.Length -le 80 } | Select-Object -Last 1
    if ($null -eq $boundary) {
      # A long link or inline command is indivisible; wrap after it instead.
      $boundary = $spaces | Where-Object { $_.Index -gt $start } | Select-Object -First 1
    }
    if ($null -eq $boundary -or $boundary.Index + $boundary.Length -eq $Line.Length) { break }
    $indent + $Line.Substring($start, $boundary.Index - $start)
    $start = $boundary.Index + $boundary.Length
    $indent = $continuation
  }
  $indent + $Line.Substring($start)
}

function Format-DocumentationMarkdown {
  param([string]$Text, [int]$HeadingLevel = 0, [string]$Title)

  $lines = New-Object 'System.Collections.Generic.List[string]'
  $headings = New-Object 'System.Collections.Generic.List[int]'
  $fence = ''
  $htmlBlock = $false
  foreach ($line in ((ConvertTo-DocumentationText $Text) -split $lineFeed)) {
    if ($fence) {
      $lines.Add($line)
      if ($line -match ('^\s{0,3}' + [regex]::Escape($fence[0]) + '{' + $fence.Length + ',}\s*$')) { $fence = '' }
      continue
    }
    if ($line -match '^\s{0,3}(`{3,}|~{3,})') {
      $fence = $Matches[1]
      $lines.Add($line)
      continue
    }
    # Preserve HTML (including multiline comments) and indented code verbatim.
    if ($htmlBlock -or $line -match '^\s*<') {
      $htmlBlock = $line -notmatch '>\s*$'
      $lines.Add($line)
      continue
    }
    if ($line -match '^( {4}|\t)') { $lines.Add($line); continue }

    # Two spaces express an intentional Markdown hard break; preserve them.
    $line = [regex]::Replace($line, '[ \t]+$', {
      param($match)
      if ($match.Value.Length -ge 2) { return '  ' }
      return ''
    })
    if ([string]::IsNullOrWhiteSpace($line)) {
      if ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -ne '') { $lines.Add('') }
      continue
    }
    if ($line -match '^(#{1,6})\s+(.+)$') {
      $level = $Matches[1].Length
      $label = $Matches[2]
      if ($HeadingLevel -gt 0) {
        while ($headings.Count -gt 0 -and $headings[$headings.Count - 1] -ge $level) { $headings.RemoveAt($headings.Count - 1) }
        $headings.Add($level)
        $level = [Math]::Min(6, $HeadingLevel + $headings.Count - 1)
        if ($label -eq $Title) { $label = "About $label" }
      }
      if ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -ne '') { $lines.Add('') }
      $lines.Add(('#' * $level) + ' ' + $label)
      $lines.Add('')
      continue
    }
    # Asterisks can also form a thematic break, rather than a list item.
    if ($line -notmatch '^ {0,3}(?:\*\s*){3,}$') { $line = $line -replace '^(\s*)[*+]\s+', '$1- ' }
    if ($line -match '^\|(?:\s*:?-+:?\s*\|)+$') {
      $line = $line -replace '(?<=\|)\s*(:?-+:?)\s*(?=\|)', ' $1 '
    }
    # The standard AU notice is copied from metadata; give its link a useful label.
    $line = $line.Replace('[here](https://github.com/mkevenaar/chocolatey-packages/issues)', '[package update issues](https://github.com/mkevenaar/chocolatey-packages/issues)')
    $pattern = '(?<protected>(?<code>`+).*?\k<code>|\[[^\]]*\]\([^)]+\)|<[^>]+>)|(?<url>https?://[^\s<>]+)'
    $line = [regex]::Replace($line, $pattern, {
      param($match)
      if ($match.Groups['protected'].Success) { return $match.Value }
      $url = $match.Value.TrimEnd('.', ',', ';', ':', '!')
      while ($url.EndsWith(')') -and ([regex]::Matches($url, '\)').Count -gt [regex]::Matches($url, '\(').Count)) { $url = $url.Substring(0, $url.Length - 1) }
      return '<' + $url + '>' + $match.Value.Substring($url.Length)
    })
    foreach ($wrapped in (Format-MarkdownLine $line)) { $lines.Add($wrapped) }
  }
  return ($lines -join $lineFeed).Trim([char[]]"`r`n") + $lineFeed
}

function ConvertTo-HelpText {
  param([string[]]$Text)

  $content = ConvertTo-DocumentationText ($Text -join "$lineFeed$lineFeed")
  # Preserve existing Markdown links and inline code when adding common links.
  $pattern = '(\[[^\]]*\]\([^)]+\)|`+[^`]*`+)|\b(?:(community feeds?|community repository)|(Chocolatey for Business|Chocolatey Professional|Chocolatey Pro|Pro(?:fessional)?\s?/\s?Business|licensed editions|licensed versions))\b'
  return [regex]::Replace($content, $pattern, {
    param($match)
    if ($match.Groups[1].Success) { return $match.Value }
    $target = 'https://chocolatey.org/compare'
    if ($match.Groups[2].Success) { $target = 'https://community.chocolatey.org/packages' }
    return "[$($match.Value)]($target)"
  }, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
}

function ConvertTo-YamlString {
  param([string]$Text)

  return "'" + (($Text -replace '\r\n|\r|\n', ' ').Replace("'", "''")) + "'"
}

function Add-DocumentationPage {
  param([string]$RelativePath, [string]$Content)

  if ($pages.Contains($RelativePath)) {
    throw "More than one documentation page maps to '$RelativePath'."
  }
  if ($RelativePath.EndsWith('.md')) { $Content = Format-DocumentationMarkdown $Content }
  $pages.Add($RelativePath, (ConvertTo-DocumentationText $Content).TrimEnd() + $lineFeed)
}

function ConvertTo-HelpSyntax {
  param($Syntax, [bool]$HasCmdletBinding)

  $lines = @($Syntax.Name)
  foreach ($parameter in $Syntax.parameter) {
    $value = '-' + $parameter.name
    if ($null -ne $parameter.parameterValue) { $value += " <$($parameter.parameterValue)>" }
    if ($null -ne $parameter.parameterValueGroup) {
      $value += ' {' + ($parameter.parameterValueGroup.parameterValue -join ' | ') + '}'
    }
    if ([string]$parameter.required -eq 'false') { $value = "[$value]" }
    $lines += "  $value"
  }
  $command = $lines -join (' `' + $lineFeed)
  if ($HasCmdletBinding) { $command += ' [<CommonParameters>]' }
  return '```powershell' + $lineFeed + $command + $lineFeed + '```'
}

function ConvertTo-ParameterMarkdown {
  param($Parameter, [System.Management.Automation.CommandInfo]$Command)

  $heading = "### -$($Parameter.name)"
  if ($null -ne $Parameter.parameterValue -and $Parameter.parameterValue -ne 'SwitchParameter') {
    $type = "&lt;$($Parameter.parameterValue)&gt;"
    if ([string]$Parameter.required -eq 'false') { $type = "[$type]" }
    $heading += " $type"
  }
  $description = ConvertTo-HelpText $Parameter.description.Text
  if ($null -ne $Parameter.parameterValueGroup) {
    $description += "$lineFeed$($lineFeed)Valid options: " + ($Parameter.parameterValueGroup.parameterValue -join ', ')
  }
  $properties = [ordered]@{
    'Aliases' = $Command.Parameters[$Parameter.name].Aliases -join ', '
    'Required?' = $Parameter.required
    'Position?' = $Parameter.position
    'Default Value' = $Parameter.defaultValue
    'Accept Pipeline Input?' = $Parameter.pipelineInput
  }
  $rows = foreach ($property in $properties.GetEnumerator()) {
    $value = (ConvertTo-DocumentationText ([string]$property.Value)).Replace('|', '&#124;').Replace($lineFeed, '<br>')
    if ($value) { "| $($property.Key) | $value |" } else { "| $($property.Key) | |" }
  }
  return @"
$heading

$description

| Property | Value |
| -------- | ----- |
$($rows -join $lineFeed)
"@
}

function ConvertTo-ExampleMarkdown {
  param($Example)

  $title = ([string]$Example.title -replace '^-+\s*|\s*-+$', '').Trim()
  $code = ConvertTo-DocumentationText $Example.code
  $remarks = @($Example.remarks | ForEach-Object { $_.Text } | Where-Object { $_ }) -join $lineFeed
  # Comment-based help often stores most of the example in remarks.
  $body = (@($code, $remarks) | Where-Object { $_ }) -join $lineFeed
  return "### $title$lineFeed$lineFeed" + '```powershell' + $lineFeed + $body + $lineFeed + '```'
}

function ConvertTo-HelpTypeMarkdown {
  param($HelpType)

  $types = @($HelpType | ForEach-Object {
    if ($_.type.name) {
      '* ' + $_.type.name
      if ($_.description.Text) { ConvertTo-HelpText $_.description.Text }
    }
  })
  if ($types.Count -eq 0) { return 'None' }
  return $types -join $lineFeed
}

function ConvertTo-FunctionMarkdown {
  param([System.Management.Automation.FunctionInfo]$Command, [string]$PackageName)

  $help = Get-Help -Name "$($Command.ModuleName)\$($Command.Name)" -Full
  $source = "$sourceLocation/extensions/$PackageName/extensions/$($Command.Name).ps1"
  $moduleDirectory = "extensions\$($Command.ModuleName)"
  $sections = New-Object 'System.Collections.Generic.List[string]'
  $sections.Add("# $($Command.Name)")
  $sections.Add(@"
<!--
This documentation is automatically generated from
$source
using $sourceLocation/GenerateDocs.ps1.
Contributions are welcome at the original location(s).
-->
"@)
  $sections.Add((ConvertTo-HelpText $help.Synopsis))
  $sections.Add('## Syntax')
  foreach ($syntax in $help.syntax.syntaxItem) {
    $sections.Add((ConvertTo-HelpSyntax $syntax $Command.CmdletBinding))
  }
  if ($help.description.Text) {
    $sections.Add('## Description')
    $sections.Add((ConvertTo-HelpText $help.description.Text))
  }
  if ($help.alertSet.alert.Text) {
    $sections.Add('## Notes')
    $sections.Add((ConvertTo-HelpText $help.alertSet.alert.Text))
  }
  $sections.Add('## Aliases')
  $aliases = @(Get-Alias -Definition $Command.Name -ErrorAction SilentlyContinue | Sort-Object Name | ForEach-Object { "``$($_.Name)``" })
  if ($aliases.Count) { $sections.Add(($aliases -join $lineFeed)) } else { $sections.Add('None') }
  if ($help.Examples.Example) {
    $sections.Add('## Examples')
    foreach ($example in $help.Examples.Example) { $sections.Add((ConvertTo-ExampleMarkdown $example)) }
  }
  $sections.Add('## Inputs')
  $sections.Add((ConvertTo-HelpTypeMarkdown $help.InputTypes.inputType))
  $sections.Add('## Outputs')
  $sections.Add((ConvertTo-HelpTypeMarkdown $help.ReturnValues.returnValue))
  $sections.Add('## Parameters')
  foreach ($parameter in $help.parameters.parameter) {
    $sections.Add((ConvertTo-ParameterMarkdown $parameter $Command))
  }
  if ($Command.CmdletBinding) {
    $sections.Add('### &lt;CommonParameters&gt;')
    $sections.Add('This cmdlet supports the common parameters. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/p/?LinkID=113216).')
  }
  $links = @(foreach ($link in $help.relatedLinks.navigationLink) {
    if ($link.uri) {
      $label = $link.linkText
      if (-not $label) { $label = $link.uri }
      "* [$label]($($link.uri))"
    } elseif ($link.linkText) {
      $target = $functionLinks[$link.linkText]
      if ($target) { "* [$($link.linkText)]($target)" } else { "* ``$($link.linkText)``" }
    }
  })
  if ($links.Count) {
    $sections.Add('## Links')
    $sections.Add(($links -join $lineFeed))
  }
  $sections.Add('[Extension documentation](Index.html)')
  $sections.Add('***NOTE:*** This documentation has been automatically generated using:')
  $sections.Add('```powershell' + $lineFeed +
    "`$extensionPath = Join-Path `$env:ChocolateyInstall '$moduleDirectory'$lineFeed" +
    "Import-Module (Join-Path `$extensionPath '$($Command.ModuleName).psm1') -Force$lineFeed" +
    "Get-Help $($Command.Name) -Full$lineFeed" + '```')
  $sections.Add("View the source for [$($Command.Name)]($source)")
  return $sections -join "$lineFeed$lineFeed"
}

# Build every page before changing the output, so invalid source files leave the
# previously generated documentation intact. Keep existing URLs for incoming links.
$navigation.Add('toc:')
$modules = @(foreach ($directory in (Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'extensions') -Directory | Sort-Object Name)) {
  $moduleName = $directory.Name -replace '\.extension$', ''
  $modulePath = Join-Path $directory.FullName "extensions\$moduleName.psm1"
  Write-Verbose "Importing $modulePath"
  $module = Import-Module -Name $modulePath -Scope Local -Force -PassThru
  $commands = @($module.ExportedFunctions.Values | Sort-Object Name)
  foreach ($command in $commands) {
    $functionLinks[$command.Name] = "../$($directory.Name)/Helpers$($command.Name.Replace('-', '')).html"
  }
  [pscustomobject]@{ Directory = $directory; Commands = $commands }
})

foreach ($module in $modules) {
  $packageName = $module.Directory.Name
  $generatedFolders.Add($packageName)
  $navigation.Add("  - title: $(ConvertTo-YamlString $packageName)")
  $navigation.Add('    subfolderitems:')
  foreach ($document in @(
    @{ Source = 'README.md'; Name = 'Index'; Title = 'Documentation' }
    @{ Source = 'CHANGELOG.md'; Name = 'Changelog'; Title = 'Changelog' }
  )) {
    $content = Get-Content -LiteralPath (Join-Path $module.Directory.FullName $document.Source) -Raw -Encoding UTF8
    Add-DocumentationPage "$packageName/$($document.Name).md" $content
    $navigation.Add("      - page: $(ConvertTo-YamlString $document.Title)")
    $navigation.Add("        url: /$packageName/$($document.Name).html")
  }
  foreach ($command in $module.Commands) {
    $pageName = 'Helpers' + $command.Name.Replace('-', '')
    Add-DocumentationPage "$packageName/$pageName.md" (ConvertTo-FunctionMarkdown $command $packageName)
    $navigation.Add("      - page: $(ConvertTo-YamlString $command.Name)")
    $navigation.Add("        url: /$packageName/$pageName.html")
  }
}

$navigation.Add('  - title: Packages')
$navigation.Add('    subfolderitems:')
$generatedFolders.Add('packages')
$packagePaths = @($packageFolders | ForEach-Object { Join-Path $PSScriptRoot $_ })
$packages = Get-ChildItem -LiteralPath $packagePaths -Directory | Sort-Object Name, FullName
foreach ($package in $packages) {
  $nuspecPath = Join-Path $package.FullName "$($package.Name).nuspec"
  if (-not (Test-Path -LiteralPath $nuspecPath -PathType Leaf)) { continue }
  Write-Verbose "Reading $nuspecPath"
  [xml]$nuspec = Get-Content -LiteralPath $nuspecPath -Raw -Encoding UTF8
  $metadata = $nuspec.package.metadata
  if (-not $metadata.id) { throw "Package metadata in '$nuspecPath' is missing an id." }
  $title = [string]$metadata.title
  if ([string]::IsNullOrWhiteSpace($title)) { $title = [string]$metadata.id }
  $markdownTitle = ConvertTo-MarkdownLabel $title
  $description = [string]$metadata.description
  if ($metadata.description -is [System.Xml.XmlNode]) { $description = $metadata.description.InnerText }
  $parametersPath = Join-Path $package.FullName 'PARAMETERS.md'
  $parameters = ''
  if (Test-Path -LiteralPath $parametersPath -PathType Leaf) {
    # The first six lines are the PARAMETERS.md heading and introduction.
    $parameters = (Get-Content -LiteralPath $parametersPath -Encoding UTF8 | Select-Object -Skip 6) -join $lineFeed
  }
  # Literal replacement preserves dollar signs and regex replacement tokens.
  $description = $description.Replace('<!-- PARAMETERS.md -->', $parameters)
  $description = (Format-DocumentationMarkdown $description -HeadingLevel 3 -Title $title).TrimEnd()
  $icon = ''
  if ($metadata.iconUrl) {
    $icon = @"
<img
  src="$([System.Net.WebUtility]::HtmlEncode($metadata.iconUrl))"
  alt="Package icon"
  width="32" height="32"/>

"@
  }
  $pageName = $package.Name.Replace('-', '')
  $content = @"
# $markdownTitle

$icon

[![Chocolatey version][choco-docs-version]][choco-docs-package]
[![Chocolatey downloads][choco-docs-downloads]][choco-docs-package]

[choco-docs-version]: https://img.shields.io/chocolatey/v/$($metadata.id).svg?label=$([System.Net.WebUtility]::UrlEncode($title))
[choco-docs-downloads]: https://img.shields.io/chocolatey/dt/$($metadata.id).svg
[choco-docs-package]: https://community.chocolatey.org/packages/$($metadata.id)

## Usage

To install $markdownTitle, run the following command:

``````powershell
choco install $($metadata.id)
``````

To upgrade $markdownTitle, run the following command:

``````powershell
choco upgrade $($metadata.id)
``````

To uninstall $markdownTitle, run the following command:

``````powershell
choco uninstall $($metadata.id)
``````

## Description

$description

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/$($metadata.id))

[Software Site]($($metadata.projectUrl))

[Package Source]($($metadata.packageSourceUrl))
"@
  Add-DocumentationPage "packages/$pageName.md" $content
  $navigation.Add("      - page: $(ConvertTo-YamlString $title)")
  $navigation.Add("        url: /packages/$pageName.html")
}

Add-DocumentationPage '_data/navigation.yml' ($navigation -join $lineFeed)
# Use the same encoding on Windows PowerShell and PowerShell Core, and avoid
# rewriting unchanged files. Publish navigation after all the pages it references.
$encoding = New-Object System.Text.UTF8Encoding($false)
foreach ($page in $pages.GetEnumerator()) {
  $path = Join-Path $docsFolder $page.Key
  [System.IO.Directory]::CreateDirectory((Split-Path -Parent $path)) | Out-Null
  if (-not (Test-Path -LiteralPath $path -PathType Leaf) -or [System.IO.File]::ReadAllText($path) -cne $page.Value) {
    Write-Verbose "Writing $path"
    [System.IO.File]::WriteAllText($path, $page.Value, $encoding)
  }
}
# Only these directories contain generated pages; preserve site assets and layouts.
foreach ($folder in $generatedFolders) {
  $path = Join-Path $docsFolder $folder
  if (-not (Test-Path -LiteralPath $path -PathType Container)) { continue }
  foreach ($file in (Get-ChildItem -LiteralPath $path -Filter '*.md' -File)) {
    if (-not $pages.Contains("$folder/$($file.Name)")) { Remove-Item -LiteralPath $file.FullName -Force }
  }
}
Write-Host "Generated $($pages.Count - 1) documentation pages in $docsFolder."
