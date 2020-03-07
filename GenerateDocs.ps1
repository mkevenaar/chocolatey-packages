# Based on the script from Chocolatey Software (https://github.com/chocolatey/choco/)

# Special thanks to Glenn Sarti (https://github.com/glennsarti) for his help on this.
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Web

$thisDirectory = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$psModuleDirectory = [System.IO.Path]::GetFullPath("$thisDirectory\extensions\")
$lineFeed = "`r`n"
$sourceLocation = 'https://github.com/mkevenaar/chocolatey-packages/tree/master/'
$navigationFile = Join-Path $thisDirectory "docs\_data\navigation.yml"
$docsFolder = [System.IO.Path]::GetFullPath("$thisDirectory\docs")
$navigation = "toc:$lineFeed"
# $packagesFolder = "automatic,deprecated,manual"
$packagesFolder = @("automatic", "extensions", "deprecated" ,"manual")

function Get-Aliases($commandName){

  $aliasOutput = ''
  Get-Alias -Definition $commandName -ErrorAction SilentlyContinue | %{ $aliasOutput += "``$($_.Name)``$lineFeed"}

  if ($aliasOutput -eq $null -or $aliasOutput -eq '') {
    $aliasOutput = 'None'
  }

  Write-Output $aliasOutput
}

function Convert-Example($objItem) {
  @"
**$($objItem.title.Replace('-','').Trim())**

~~~powershell
$($objItem.Code.Replace("`n",$lineFeed))
$($objItem.remarks | ? { $_.Text -ne ''} | % { Write-Output $_.Text.Replace("`n", $lineFeed) })
~~~
"@
}

function Replace-CommonItems($text) {
  if ($text -eq $null) {return $text}

  $text = $text.Replace("`n",$lineFeed)
  $text = $text -replace '(community feed[s]?|community repository)', '[$1](https://chocolatey.org/packages)'
  $text = $text -replace '(Chocolatey for Business|Chocolatey Professional|Chocolatey Pro)(?=[^\w])', '[$1](https://chocolatey.org/compare)'
  $text = $text -replace '(Pro[fessional]\s?/\s?Business)', '[$1](https://chocolatey.org/compare)'
  $text = $text -replace '([Ll]icensed editions)', '[$1](https://chocolatey.org/compare)'
  $text = $text -replace '([Ll]icensed versions)', '[$1](https://chocolatey.org/compare)'

  Write-Output $text
}

function Convert-Syntax($objItem, $hasCmdletBinding) {
  $cmd = $objItem.Name

  if ($objItem.parameter -ne $null) {
    $objItem.parameter | % {
      $cmd += ' `' + $lineFeed
      $cmd += "  "
      if ($_.required -eq $false) { $cmd += '['}
      $cmd += "-$($_.name.substring(0,1).toupper() + $_.name.substring(1))"


      if ($_.parameterValue -ne $null) { $cmd += " <$($_.parameterValue)>" }
      if ($_.parameterValueGroup -ne $null) { $cmd += " {" + ($_.parameterValueGroup.parameterValue -join ' | ') + "}"}
      if ($_.required -eq $false) { $cmd += ']'}
    }
  }
  if ($hasCmdletBinding) { $cmd += " [<CommonParameters>]"}
  Write-Output "$lineFeed~~~powershell$lineFeed$($cmd)$lineFeed~~~"
}

function Convert-Parameter($objItem, $commandName) {
  $parmText = $lineFeed + "###  -$($objItem.name.substring(0,1).ToUpper() + $objItem.name.substring(1))"
  if ( ($objItem.parameterValue -ne $null) -and ($objItem.parameterValue -ne 'SwitchParameter') ) {
    $parmText += ' '
    if ([string]($objItem.required) -eq 'false') { $parmText += "["}
    $parmText += "&lt;$($objItem.parameterValue)&gt;"
    if ([string]($objItem.required) -eq 'false') { $parmText += "]"}
  }
  $parmText += $lineFeed
  if ($objItem.description -ne $null) {
    $parmText += (($objItem.description | % { Replace-CommonItems $_.Text }) -join "$lineFeed") + $lineFeed + $lineFeed
  }
  if ($objItem.parameterValueGroup -ne $null) {
    $parmText += "$($lineFeed)Valid options: " + ($objItem.parameterValueGroup.parameterValue -join ", ") + $lineFeed + $lineFeed
  }

  $aliases = [string]((Get-Command -Name $commandName).parameters."$($objItem.Name)".Aliases -join ', ')
  $required = [string]($objItem.required)
  $position = [string]($objItem.position)
  $defValue = [string]($objItem.defaultValue)
  $acceptPipeline = [string]($objItem.pipelineInput)

  $padding = ($aliases.Length, $required.Length, $position.Length, $defValue.Length, $acceptPipeline.Length | Measure-Object -Maximum).Maximum

    $parmText += @"
Property               | Value
---------------------- | $([string]('-' * $padding))
Aliases                | $($aliases)
Required?              | $($required)
Position?              | $($position)
Default Value          | $($defValue)
Accept Pipeline Input? | $($acceptPipeline)

"@

  Write-Output $parmText
}

try
{
  $dir = Get-ChildItem $psModuleDirectory | Where-Object {$_.PSISContainer}
  foreach ($psModuleName in $dir) {
    $navigation += "  - title: $psModuleName$($lineFeed)"
    $navigation += "    subfolderitems:$($lineFeed)"
    $psModuleLocation = [System.IO.Path]::GetFullPath("$thisDirectory\extensions\$($psModuleName)\extensions\$($psModuleName -replace ".extension").psm1")
    $moduleDocsFolder = [System.IO.Path]::GetFullPath("$thisDirectory\docs\$($psModuleName)")
    $sourceFunctions = "$($sourceLocation)/extensions/$($psModuleName)/extensions"

    Write-Host "Importing the Module $psModuleName ..."
    Import-Module "$psModuleLocation" -Force -Verbose
    $relativeName = $psModuleLocation -replace ".extension" -replace [regex]::Escape($thisDirectory), "`$env:ChocolateyInstall"
    Write-Host "Working on $docsFolder"
    if (Test-Path($moduleDocsFolder)) { Remove-Item $moduleDocsFolder -Force -Recurse -EA SilentlyContinue }
    if(-not(Test-Path $moduleDocsFolder)){ mkdir $moduleDocsFolder -EA Continue | Out-Null }

    Write-Host 'Copying Index file...'
    Copy-Item -Path "$thisDirectory\extensions\$($psModuleName)\README.md" -Destination $moduleDocsFolder\Index.md
    $navigation += "      - page: Documentation$($lineFeed)"
    $navigation += "        url: /$psModuleName/Index.html$($lineFeed)"

    Write-Host 'Copying Changelog file...'
    Copy-Item -Path "$thisDirectory\extensions\$($psModuleName)\CHANGELOG.md" -Destination $moduleDocsFolder\Changelog.md
    $navigation += "      - page: Changelog$($lineFeed)"
    $navigation += "        url: /$psModuleName/Changelog.html$($lineFeed)"

    Write-Host 'Creating per PowerShell function markdown files...'
    Get-Command -Module ($psModuleName -replace ".extension") -CommandType Function | ForEach-Object -Process { Get-Help $_ -Full } | ForEach-Object -Process { `
      $commandName = $_.Name
      $fileName = Join-Path $moduleDocsFolder "Helpers$($_.Name.Replace('-','')).md"
      $url = "Helpers$($_.Name.Replace('-',''))"
      $hasCmdletBinding = (Get-Command -Name $commandName).CmdLetBinding
      $navigation += "      - page: $commandName$($lineFeed)"
      $navigation += "        url: /$psModuleName/$url.html$($lineFeed)"

    Write-Host "Generating $fileName ..."
    @"
# $($_.Name)

<!-- This documentation is automatically generated from $sourceFunctions/$($_.Name)`.ps1 using $($sourceLocation)GenerateDocs.ps1. Contributions are welcome at the original location(s). -->

$(Replace-CommonItems $_.Synopsis)

## Syntax

$( ($_.syntax.syntaxItem | % { Convert-Syntax $_ $hasCmdletBinding }) -join "$lineFeed$lineFeed")
$( if ($_.description -ne $null) { $lineFeed + "## Description" + $lineFeed + $lineFeed + $(Replace-CommonItems $_.description.Text) })
$( if ($_.alertSet -ne $null) { $lineFeed + "## Notes" + $lineFeed + $lineFeed +  $(Replace-CommonItems $_.alertSet.alert.Text) })

## Aliases

$(Get-Aliases $_.Name)
$( if ($_.Examples -ne $null) { Write-Output "$lineFeed## Examples$lineFeed$lineFeed"; ($_.Examples.Example | % { Convert-Example $_ }) -join "$lineFeed$lineFeed"; Write-Output "$lineFeed" })

## Inputs

$( if ($_.InputTypes -ne $null -and $_.InputTypes.Length -gt 0 -and -not $_.InputTypes.Contains('inputType')) { $lineFeed + " * $($_.InputTypes)" + $lineFeed} else { 'None'})

## Outputs

$( if ($_.ReturnValues -ne $null -and $_.ReturnValues.Length -gt 0 -and -not $_.ReturnValues.StartsWith('returnValue')) { "$lineFeed * $($_.ReturnValues)$lineFeed"} else { 'None'})

## Parameters

$( if ($_.parameters.parameter.count -gt 0) { $_.parameters.parameter | % { Convert-Parameter $_ $commandName }}) $( if ($hasCmdletBinding) { "$lineFeed### &lt;CommonParameters&gt;$lineFeed$($lineFeed)This cmdlet supports the common parameters: -Verbose, -Debug, -ErrorAction, -ErrorVariable, -OutBuffer, and -OutVariable. For more information, see ``about_CommonParameters`` http://go.microsoft.com/fwlink/p/?LinkID=113216 ." } )

$( if ($_.relatedLinks -ne $null) {Write-Output "$lineFeed## Links$lineFeed$lineFeed"; $_.relatedLinks.navigationLink | ? { $_.linkText -ne $null} | % { Write-Output "* [[$($_.LinkText)|Helpers$($_.LinkText.Replace('-',''))]]$lineFeed" }})

[[Function Reference|HelpersReference]]

***NOTE:*** This documentation has been automatically generated from ``Import-Module `"$($relativeName)`" -Force; Get-Help $($_.Name) -Full``.

View the source for [$($_.Name)]($sourceFunctions/$($_.Name)`.ps1)
"@  | Out-File $fileName -Encoding UTF8 -Force
  }
}
  # Do the packages
  $navigation += "  - title: Packages$($lineFeed)"
  $navigation += "    subfolderitems:$($lineFeed)"

  $packages = Get-ChildItem -Path $packagesFolder -Directory | Where-Object {$_.PSISContainer} | Sort-Object -Property Name
  $packagesDocsFolder = Join-Path $docsFolder "packages"
  if (Test-Path($packagesDocsFolder)) { Remove-Item $packagesDocsFolder -Force -Recurse -EA SilentlyContinue }
  if(-not(Test-Path $packagesDocsFolder)){ mkdir $packagesDocsFolder -EA Continue | Out-Null }

  foreach ($package in $packages) {
    #Write-Host "Working on package $package ..."
    $NuspecPath = "$($package.FullName)\$($package.Name).nuspec"
    if (-not (Test-Path $NuspecPath)) {
      #skip, nuspec file does not exists.
      continue
    }
    #Write-Host "Nuspec File $NuspecPath ..."
    $filename = Join-Path $packagesDocsFolder "$($package.Name.Replace('-','')).md"
    $url = "$($package.Name.Replace('-',''))"

    $parameters = ''
    if(Test-Path "$($package.FullName)\PARAMETERS.md") {
      $parameters = (Get-Content -Path "$($package.FullName)\PARAMETERS.md" | Select-Object -Skip 6 | Out-String)
    }

    [xml]$nuspec = Get-Content "$NuspecPath" -Encoding UTF8
    $meta = $nuspec.package.metadata
    $readme += @"
# $( if ( $meta.iconUrl ) { Write-Output "<img src=`"$($meta.iconUrl)`" width=`"32`" height=`"32`"/>" }) [![$($meta.title)](https://img.shields.io/chocolatey/v/$($meta.id).svg?label=$([System.Net.WebUtility]::UrlEncode($meta.title)))](https://chocolatey.org/packages/$($meta.id)) [![$($meta.title)](https://img.shields.io/chocolatey/dt/$($meta.id).svg)](https://chocolatey.org/packages/$($meta.id))

## Usage

To install $($meta.title), run the following command from the command line or from PowerShell:

```````powershell
choco install $($meta.id)
```````

To upgrade $($meta.title), run the following command from the command line or from PowerShell:

```````powershell
choco upgrade $($meta.id)
```````

To uninstall $($meta.title), run the following command from the command line or from PowerShell:

```````powershell
choco uninstall $($meta.id)
```````

## Description

$( if($meta.description.InnerText) {$meta.description.InnerText} else {$meta.description} )

## Links

[Chocolatey Package Page](https://chocolatey.org/packages/$($meta.id))

[Software Site]($($meta.projectUrl))

[Package Source]($($meta.packageSourceUrl))

"@ -replace "<!-- PARAMETERS.md -->", $parameters | Out-File -Encoding UTF8 $filename

    $navigation += "      - page: `"$($nuspec.package.metadata.title)`"$($lineFeed)"
    $navigation += "        url: /packages/$url.html$($lineFeed)"
  }

  Write-Host "Writing navigation file $navigationFile"
  $navigation| Out-File $navigationFile -Encoding UTF8 -Force
  # if ((git status "$path" -s)) {
  #   git add $path | Out-Null;
  #   $message = "($PackageName) Updated icon"
  #   if ((git log --oneline -1) -match "$([regex]::Escape($message))$") {
  #     git commit --amend -m "$message" "$path" | Out-Null
  #   } else {
  #     git commit -m "$message" "$path" | Out-Null;
  #   }
  # }
  Exit 0
}
catch
{
  Throw "Failed to generate documentation.  $_"
  Exit 255
}
