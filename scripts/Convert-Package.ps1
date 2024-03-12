param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]$PackageName,
  [Parameter(Position = 1, Mandatory = $true)]
  [string]$ReleaseUrl,
  [string]$RootDirectory = "$PSScriptRoot\..\automatic",
  [string]$IconsDirectory = "$PSScriptRoot\..\icons",
  [switch]$Embedd,
  [string]$BranchName = $PackageName,
  [switch]$RunUpdate,
  [switch]$RegisterApp
)

function yesno {
  param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Question,
    [int]$default = 0
  )

  $message = "Let me ask you something"

  $choices = New-Object 'System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]'
  $choices.Add((New-Object System.Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
  $choices.Add((New-Object System.Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

  $decision = $Host.UI.PromptForChoice($message, $Question, $choices, $default)

  return $decision -eq 0
}

function Format-XML([xml]$xml, $indent = 2) {
  $StringWriter = New-Object System.IO.StringWriter
  $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter
  $xmlWriter.Formatting = [System.Xml.Formatting]::Indented
  $xmlWriter.Indentation = $indent
  $xml.WriteContentTo($XmlWriter)
  $StringWriter.WriteLine("")
  $XmlWriter.Flush()
  $StringWriter.Flush()
  Write-Output $StringWriter.ToString()
  $StringWriter.Dispose()
  $XmlWriter.Dispose()
}

function Add-MetadataElement {
  param(
    [Parameter(Position = 0, Mandatory = $true)]
    [xml]$newXml,
    [Parameter(Position = 1, Mandatory = $true)]
    [xml]$oldXml,
    [Parameter(Position = 2)]
    [System.Xml.XmlElement]$parent = $null,
    [Parameter(Position = 3, Mandatory = $true)]
    [string]$elementName,
    [Parameter(Position = 4)]
    [string]$backupValue = ""
  )

  if ($oldXml.package.metadata.$elementName) {
    Add-Element $newXml $elementName $parent $oldXml.package.metadata.$elementName | Out-Null
  } elseif ($backupValue) {
    Add-Element $newXml $elementName $parent $backupValue | Out-Null
  }
}

function Add-Element {
  param(
    [Parameter(Position = 0, Mandatory = $true)]
    [xml]$xml,
    [Parameter(Position = 1, Mandatory = $true)]
    [string]$elementName,
    [Parameter(Position = 2)]
    [System.Xml.XmlElement]$parent = $null,
    [Parameter(Position = 3)]
    [string]$elementValue = $null
  )
  $element = $xml.CreateElement($elementName)
  if ($elementValue) {
    $element.InnerText = $elementValue
  }

  if ($parent) {
    $parent.AppendChild($element) | Out-Null
  } else {
    $xml.AppendChild($element) | Out-Null
  }

  [System.Xml.XmlElement]$element
}

$branches = git branch

if (!($branches -match "^\*?\s*$BranchName$")) {
  # First checkout master branch
  git checkout master
  # Make sure we have the latest changes before creating a new branch
  git pull origin

  git checkout -b $BranchName
} elseif (!($branches -match "^\*\s*$BranchName$")) {
  git checkout $BranchName
}

$RootDirectory = Resolve-Path $RootDirectory
$IconsDirectory = Resolve-Path $IconsDirectory

$packagePath = Get-ChildItem -Directory -Path $RootDirectory -Filter "$PackageName"

if (!$packagePath) {
  throw "Package with the name $PackageName was not found"
}

$iconPath = Get-ChildItem -File -Path $packagePath.FullName -Recurse -Include "*.png", "*.svg" | Select-Object -First 1 -expand FullName

if (!$iconPath) {
  $iconPath = Get-ChildItem -File -Path $IconsDirectory -Filter "$PackageName.*" | ForEach-Object FullName
}

$package = @{
  DirectoryPath = $packagePath.FullName
  NuspecPath    = Get-ChildItem -File -Path $packagePath.FullName -Filter "$PackageName.nuspec" | ForEach-Object FullName
  IconPath      = $iconPath
}

# First let's copy the icon if it isn't in the icons directory
if ($package.IconPath -and !($package.IconPath.StartsWith($IconsDirectory))) {
  Write-Host "Moving icon to icon directory"
  $extension = [System.IO.Path]::GetExtension($package.IconPath).TrimStart('.')
  $fileName = "$($PackageName.ToLowerInvariant())$extension"
  Move-Item -Force $package.IconPath "$IconsDirectory\$fileName"
  $package.IconPath = Get-ChildItem -File -Path $IconsDirectory -Filter $fileName | ForEach-Object FullName

} elseif (!$package.IconPath) {
  # The icon is hosted remotely, or doesn't exist
  $content = Get-Content -Encoding UTF8 $package.NuspecPath
  $re = "^\s*\<iconUrl\>(.+)\<\/iconUrl\>"
  $content -match $re
  if ($Matches) {
    $iconUrl = $Matches[1]

    Write-Host "Downloading icon to the specified icon directory"
    $fileName = $PackageName.ToLowerInvariant() + [System.IO.Path]::GetExtension($iconUrl)
    Invoke-WebRequest -UseBasicParsing -Uri $iconUrl -OutFile "$IconsDirectory\$fileName"
    $package.IconPath = Get-ChildItem -File -Path $IconsDirectory -Filter $fileName | ForEach-Object FullName
  } else {
    Write-Warning "No icon was found, please add one when this script is done"
  }
}

$uninstallScript = (Test-Path "$($package.DirectoryPath)\tools\chocolateyUninstall.ps1")
if (!$uninstallScript) {
  $uninstallScript = yesno "No uninstall script detected, do you still want to create one?"
}

$oldNuspec = New-Object xml
$oldNuspec.PSBase.PreserveWhitespace = $true
$oldNuspec.Load($package.NuspecPath)

$newNuspec = New-Object xml
$newNuspec.PreserveWhitespace = $true

$xmlElm = $newNuspec.CreateXmlDeclaration("1.0", "utf-8", "");
$newNuspec.AppendChild($xmlElm) | Out-Null
$comment = $newNuspec.CreateComment(" Do not remove this test for UTF-8: if `“Ω`” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one. ")
$newNuspec.AppendChild($comment) | Out-Null

$packageElement = Add-Element $newNuspec "package"
$packageElement.SetAttribute("xmlns", "http://schemas.microsoft.com/packaging/2015/06/nuspec.xsd")
$metadata = Add-Element $newNuspec "metadata" $packageElement
$id = [System.IO.Path]::GetFileName($package.DirectoryPath)
Add-Element $newNuspec "id" $metadata $id | Out-Null
if ($oldNuspec.package.metadata.version -match "^[\d\.]+$") {
  Add-MetadataElement $newNuspec $oldNuspec $metadata "version"
} else {
  $version = (. choco info $id -r) -split '\|' | Select-Object -Last 1
  if (!$version) {
    $version = "0.0"
  }
  Add-Element $newNuspec "version" $metadata $version | Out-Null
}




if ($package.IconPath -and $package.IconPath.EndsWith(".png") -and (Get-Command pngquant)) {
  if (yesno "Do you wish to optimize icon using pngquant") {
    . pngquant --strip --force --output "$($package.IconPath)" "$($package.IconPath)"

    if ((. git status "$($package.IconPath)" --short) -match "^\s*M") {
      . git add "$($package.IconPath)"
      if ((. git log -1 --oneline) -match "\($id\) Optimized icon") {
        . git commit --amend -m "($id) Optimized icon" -- "$($package.IconPath)"
      } else {
        . git commit -m "($id) Optimized icon" -- "$($package.IconPath)"
      }
    }
  }
}

$remotes = . git remote
if ($remotes -match 'upstream') {
  $remoteUrl = . git remote "get-url" 'upstream'
} elseif ($remotes -match 'origin') {
  $remoteUrl = . git remote "get-url" 'origin'
} else {
  throw "Unable to find repository url"
}

$remoteUrl = $remoteUrl.TrimEnd('.git').ToLowerInvariant() + "/tree/master"

$repoRoot = Resolve-Path "$PSScriptRoot\.." | ForEach-Object Path
$packageSourceUrl = ($package.DirectoryPath -replace [regex]::Escape($repoRoot), $remoteUrl) -replace '\\', '/'

Add-Element $newNuspec "packageSourceUrl" $metadata $packageSourceUrl | Out-Null

$existingOwners = $oldNuspec.package.metadata.owners -split '[ ,]'

if (!$existingOwners) {
  $existingOwners = @('JourneyOver')
} elseif ($existingOwners[0] -ne 'JourneyOver') {
  $existingOwners = @('JourneyOver') + $existingOwners
}

Add-Element $newNuspec "owners" $metadata ($existingOwners -join ', ') | Out-Null

Add-MetadataElement $newNuspec $oldNuspec $metadata "title" $PackageName
Add-MetadataElement $newNuspec $oldNuspec $metadata "authors" "Who are the author of this software"
Add-MetadataElement $newNuspec $oldNuspec $metadata "projectUrl" $ReleaseUrl
Add-MetadataElement $newNuspec $oldNuspec $metadata "iconUrl" "What is the link to the icon url"
Add-MetadataElement $newNuspec $oldNuspec $metadata "copyright" "What is the copyright"
Add-MetadataElement $newNuspec $oldNuspec $metadata "licenseUrl" "Software License Location __REMOVE_OR_FILL_OUT__"
Add-MetadataElement $newNuspec $oldNuspec $metadata "requireLicenseAcceptance" "false"
Add-MetadataElement $newNuspec $oldNuspec $metadata "projectSourceUrl" "Software Source Location - is the software FOSS somewhere? Link to it with this"
Add-MetadataElement $newNuspec $oldNuspec $metadata "docsUrl" "At what url are the software docs located?"
Add-MetadataElement $newNuspec $oldNuspec $metadata "mailingListUrl" "What is the link to the mailing list or forum?"
$bugTrackerUrl = "What is the link to the bug tracker"
if ($newNuspec.package.projectSourceUrl -match 'github') {
  $bugTrackerUrl = $newNuspec.package.projectSourceUrl + "/issues"
} elseif ($newNuspec.package.projectUrl -match 'github') {
  $bugTrackerUrl = $newNuspec.package.projectUrl + "/issues"
}
Add-MetadataElement $newNuspec $oldNuspec $metadata "bugTrackerUrl" $bugTrackerUrl

$tags = $oldNuspec.package.metadata.tags -split ' '
if (!$tags -or !$tags.Contains($id)) {
  $tags = @($id) + $tags
}

$tags = $tags -join ' '
if ($tags) {
  $tags = $tags.ToLowerInvariant()
}

Add-Element $newNuspec "tags" $metadata $tags | Out-Null

Add-MetadataElement $newNuspec $oldNuspec $metadata "summary" "__REPLACE"
Add-MetadataElement $newNuspec $oldNuspec $metadata "description" "__REPLACE__MarkDown_Okay"
Add-MetadataElement $newNuspec $oldNuspec $metadata "releaseNotes" "__REPLACE_OR_REMOVE__Markdown_Okay__May_Be_A_URL"

#Add-MetadataElement $newNuspec $oldNuspec $metadata "dependencies"
$dependencies = Add-Element $newNuspec "dependencies" $metadata
$addCoreExtension = $true
$oldNuspec.package.metadata.dependencies.dependency | ForEach-Object {
  if (!$_.id) { return }
  if ($_.id -eq 'chocolatey-core.extension' -or $_.id -eq 'chocolatey-uninstall.extension' -or $_.id -eq 'mm-choco.extension') {
    $addCoreExtension = $true
  } else {
    $element = Add-Element $newNuspec "dependency" $dependencies
    $element.SetAttribute("id", $_.id)
    if ($_.version) {
      $element.SetAttribute("version", $_.version)
    }
  }
}

if ($uninstallScript -or $addCoreExtension) {
  $element = Add-Element $newNuspec "dependency" $dependencies
  $element.SetAttribute("id", "chocolatey-core.extension")
  $version = (. choco info 'chocolatey-core.extension' -r) -split '\|' | Select-Object -Last 1
  if ($version) {
    $element.SetAttribute("version", $version)
  }
}

$filesElement = Add-Element $newNuspec "files" $packageElement
if ($Embedd) {
  $file = Add-Element $newNuspec "file" $filesElement
  $file.SetAttribute("src", "legal\**")
  $file.SetAttribute("target", "legal")
}

$file = Add-Element $newNuspec "file" $filesElement
$file.SetAttribute("src", "tools\**")
$file.SetAttribute("target", "tools")

$oldNuspec = $null

$noBOM = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($package.NuspecPath, (Format-XML $newNuspec.InnerXml), $noBOM)

$licenseUrl = $newNuspec.package.metadata.licenseUrl

if ($Embedd) {
  $legalDir = "$($package.DirectoryPath)\legal"
  if (!$licenseUrl -or !$licenseUrl.EndsWith(".txt")) {
    $licenseUrl = Read-Host -Prompt "Please enter the url to the text version of the license"
    if (!$licenseUrl) {
      Write-Warning "No License URL was provided, please make sure you have distribution rights for this package and download the text version of the url yourself"
    }
  }

  if ($licenseUrl) {
    if (!(Test-Path $legalDir)) {
      New-Item -ItemType Directory -Path $legalDir
    }

    if ($licenseUrl -match "https?://github.com/([^/]+)/([^/]+)/(?:blob|raw)/[^/]+/(.+)") {
      # We got a git url
      $owner = $Matches[1]
      $repo = $Matches[2]
      $path = $Matches[3]

      $json = Invoke-RestMethod -UseBasicParsing "https://api.github.com/repos/$owner/$repo/contents/$path"
      $sha = $json.sha

      # We assume we got the right content
      Invoke-WebRequest -UseBasicParsing -Uri "$($json.download_url)" -OutFile "$legalDir\LICENSE.txt"

      $verificationUrl = "https://github.com/$owner/$repo/blob/$sha/$path"
    } elseif ($licenseUrl -match "^https?://sourceforge.net/p/[^/]+/code/ci/master/tree/.*") {
      Invoke-WebRequest -UseBasicParsing -Uri "${licenseUrl}?format=raw" -OutFile "$legalDir\LICENSE.txt"
      $verificationUrl = $licenseUrl
    } else {
      Invoke-WebRequest -UseBasicParsing -Uri "$licenseUrl" -OutFile "$legalDir\LICENSE.txt"
      $verificationUrl = $licenseUrl
    }
  }
}

$supportsX64 = yesno "Do this package support 64bit?" -default 1
if ($Embedd) {
  $writer = New-Object System.IO.StringWriter
  $writer.WriteLine("VERIFICATION")
  $writer.WriteLine("Verification is intended to assist the Chocolatey moderators and community")
  $writer.WriteLine("in verifying that this package's contents are trustworthy.")
  $writer.WriteLine("")
  $writer.WriteLine("The embedded software have been downloaded from the listed download")
  $writer.WriteLine("location on <$ReleaseUrl>")
  $writer.WriteLine("and can be verified by doing the following:")
  $writer.WriteLine("")
  $writer.Write("1. Download the following")
  if ($supportsX64) {
    $writer.WriteLine(":")
    $writer.WriteLine("  32-Bit software: <>")
    $writer.WriteLine("  64-Bit software: <>")
  } else {
    $writer.WriteLine(" <>")
  }

  $writer.WriteLine("2. Get the checksum using one of the following methods:")
  $writer.WriteLine("  - Using powershell function 'Get-FileHash'")
  $writer.WriteLine("  - Use chocolatey utility 'checksum.exe'")

  $writer.WriteLine("3. The checksums should match the following:")
  $writer.WriteLine("")
  $writer.WriteLine("  checksum type:")
  if ($supportsX64) {
    $writer.WriteLine("  checksum32:")
    $writer.WriteLine("  checksum64:")
  } else {
    $writer.WriteLine("  checksum:")
  }

  $writer.WriteLine("")
  $writer.WriteLine("The file 'LICENSE.txt' has been obtained from <$verificationUrl>")

  $writer.Flush()

  if (!(Test-Path "$($package.DirectoryPath)\legal")) {
    New-Item -Path "$($package.DirectoryPath)\legal" -ItemType Directory
  }
  [System.IO.File]::WriteAllText("$($package.DirectoryPath)\legal\VERIFICATION.txt", $writer.ToString(), $noBOM)
}

$BOMEncoding = New-Object System.Text.UTF8Encoding($true)

$writer = New-Object System.IO.StringWriter
$writer.WriteLine("Import-Module AU")
$writer.WriteLine("")
$writer.WriteLine("`$releases     = '$ReleaseUrl'")
$writer.WriteLine("`$softwareName = ''")
$writer.WriteLine("");

if ($Embedd) {
  $writer.WriteLine("function global:au_BeforeUpdate {")
  $writer.WriteLine("  Get-RemoteFiles -Purge -FileNameBase `$Latest.PackageName")
  $writer.WriteLine("}")
  $writer.WriteLine("")
}

$writer.WriteLine("function global:au_SearchReplace {")
$writer.WriteLine("  @{")
$replacePad = 42
$filePad = 38

if ($Embedd) {
  $writer.WriteLine('    ".\legal\VERIFICATION.txt"'.PadRight($filePad) + '= @{')
  $writer.WriteLine('      "(?i)(^\s*location on\:?\s*)\<.*\>"'.PadRight($replacePad) + '= "`${1}<$releases>"')
  if ($supportsX64) {
    $writer.WriteLine('      "(?i)(\s*32\-Bit Software.*)\<.*\>"'.PadRight($replacePad) + '= "`${1}<$($Latest.URL32)>"')
    $writer.WriteLine('      "(?i)(\s*64\-Bit Software.*)\<.*\>"'.PadRight($replacePad) + '= "`${1}<$($Latest.URL64)>"')
  } else {
    $writer.WriteLine('      "(?i)(\s*1\..+)\<.*\>"'.PadRight($replacePad) + '= "`${1}<$($Latest.URL32)>"')
  }
  $writer.WriteLine('      "(?i)(^\s*checksum\s*type\:).*"'.PadRight($replacePad) + '= "`${1} $($Latest.ChecksumType32)"')
  $writer.WriteLine('      "(?i)(^\s*checksum(32)?\:).*"'.PadRight($replacePad) + '= "`${1} $($Latest.Checksum32)"')
  if ($supportsX64) {
    $writer.WriteLine('      "(?i)(^\s*checksum64\:).*"'.PadRight($replacePad) + '= "`${1} $($Latest.Checksum64)"')
  }
  $writer.WriteLine('    }')
}

$instalScript = (Test-Path "$($package.DirectoryPath)\tools\chocolateyInstall.ps1") -or !$Embedd
if (!$instalScript) {
  $instalScript = yesno "No install script detected, do you still want to create one?"
}

if ($instalScript) {
  $writer.WriteLine("    `".\tools\chocolateyInstall.ps1`"".PadRight($filePad) + "= @{")
  $writer.WriteLine("      `"(?i)(^\s*packageName\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.PackageName)'`"")
  $writer.WriteLine("      `"(?i)^(\s*softwareName\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$softwareName'`"")
  if ($Embedd) {
    if ($supportsX64) {
      $writer.WriteLine("      `"(?i)(^[$]filePath32\s*=\s*```"[$]toolsPath\\)[^```"]*```"`"".PadRight($replacePad) + "= `"```${1}`$(`$Latest.FileName32)```"`"")
      $writer.WriteLine("      `"(?i)(^[$]filePath64\s*=\s*```"[$]toolsPath\\)[^```"]*```"`"".PadRight($replacePad) + "= `"```${1}`$(`$Latest.FileName64)```"`"")
    } else {
      $writer.WriteLine("      `"(?i)(^[$]filePath\s*=\s*```"[$]toolsPath\\)[^```"]*```"`"".PadRight($replacePad) + "= `"```${1}`$(`$Latest.FileName32)```"`"")
    }
  } else {
    $writer.WriteLine("      `"(?i)^(\s*url\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.URL32)'`"")
    if ($supportsX64) {
      $writer.WriteLine("      `"(?i)^(\s*url64(bit)?\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.URL64)'`"")
    }
    $writer.WriteLine("      `"(?i)^(\s*checksum\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.Checksum32)'`"")
    $writer.WriteLine("      `"(?i)^(\s*checksumType\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.ChecksumType32)'`"")
    if ($supportsX64) {
      $writer.WriteLine("      `"(?i)^(\s*checksum64\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.Checksum64)'`"")
      $writer.WriteLine("      `"(?i)^(\s*checksumType64\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.ChecksumType64)'`"")
    }
  }

  $writer.WriteLine("    }")
}

if ($uninstallScript) {
  $writer.WriteLine("    `".\tools\chocolateyUninstall.ps1`"".PadRight($filePad) + "= @{")
  $writer.WriteLine("      `"(?i)(^[$]packageName\s*=\s*)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$(`$Latest.PackageName)'`"")
  $writer.WriteLine("      `"(?i)(\-SoftwareName\s+)'.*'`"".PadRight($replacePad) + "= `"```${1}'`$softwareName'`"")
  $writer.WriteLine("    }")
}

$writer.WriteLine("  }")
$writer.WriteLine("}")

$writer.WriteLine("function global:au_GetLatest {")
$writer.WriteLine('  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing')
$writer.WriteLine('')
do {
  $url32Re = Read-Host -Prompt "Input the regex to use to get the 32bit url (defaults to \.exe$)"
  if (!$url32Re) {
    $url32Re = '\.exe$'
  }

  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $ReleaseUrl
  Write-Host "The regex matched the following urls (the first one will be grabbed)"
  $download_page.links | Where-Object href -Match $url32Re | ForEach-Object { Write-Host "  $($_.href)" }
} while ((yesno "Do this look correct?") -eq 0)
$writer.WriteLine("  `$re = '$url32Re'")
$writer.WriteLine('  $url32 = $download_page.Links | Where-Object href -match $re | Select-Object -first 1 -expand href')
$writer.WriteLine('')
if ($supportsX64) {
  do {
    $url64Re = Read-Host -Prompt "Input the regex to use to get the 64bit url"
    if (!$url64Re) { break; }
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $ReleaseUrl
    Write-Host "The regex matched the following urls (the first one will be grabbed)"
    $download_page.links | Where-Object href -Match $url64Re | ForEach-Object { Write-Host "  $($_.href)" } | Out-Null
  } while ((yesno "Do this look correct?") -eq 0)
  $writer.WriteLine("  `$re = '$url64Re'")
  $writer.WriteLine('  $url64 = $download_page.links | Where-Object href -match $re | Select-Object -first 1 -expand href')
  $writer.WriteLine("")
}
$verRe = "[-\.]|\.exe|\.msi|\.zip"
$writer.WriteLine("  `$verRe = '[-]|\.exe|\.msi|\.zip'")
$writer.WriteLine("  `$version32 = `$url32 -split `"`$verRe`" | Select-Object -last 1 -skip 1")
if ($supportsX64) {
  $writer.WriteLine("  `$version64 = `$url64 -split `"`$verRe`" | Select-Object -last 1 -skip 1")
  $writer.WriteLine('  if ($version32 -ne $version64) {')
  $writer.WriteLine('    throw "32bit version do not match the 64bit version"')
  $writer.WriteLine('  }')
}

$writer.WriteLine('  @{')
$writer.WriteLine('    URL32 = $url32')
if ($supportsX64) {
  $writer.WriteLine('    URL64 = $url64')
}
$writer.WriteLine('    Version = $version32')
$writer.WriteLine('  }')
$writer.WriteLine('}')
$writer.WriteLine('')

if ($Embedd) {
  $writer.WriteLine('update -ChecksumFor none')
} elseif ($supportsX64) {
  $writer.WriteLine('update')
} else {
  $writer.WriteLine('update -ChecksumFor 32')
}

$writer.Flush()
[System.IO.File]::WriteAllText("$($package.DirectoryPath)\update.ps1", $writer.ToString(), $BOMEncoding)

$writer.Dispose()

if ($instalScript) {
  $installData = @{
    fileType       = ''
    silentArgs     = ''
    validExitCodes = '@(0)'
  }
  $regexFormat = "^[$\s]+{0}\s*=\s*['`"]([^'`"]+)['`"]"

  $path = "$($package.DirectoryPath)\tools\chocolateyInstall.ps1"
  if ((Test-Path "$path")) {
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    $opts = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Multiline
    #$m = $content | Where-Object { $_ -match "^[$\s]+fileType\s*=\s*['`"](.+)['`"]" } | Select-Object -first 1
    $m = [regex]::Match($content, ($regexFormat -f '(?:file|installer)Type'), $opts)
    if ($m.Success) {
      $installData.fileType = $m.Groups[1].Value.ToLowerInvariant()
    }

    $supportedFileTypes = @('zip'; 'exe'; 'msi'; 'vsix')
    if (!($supportedFileTypes.Contains($installData.fileType))) {
      $message = "We was unable to detect the file type.`nPlease select one of the following"

      $choices = New-Object 'System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]'

      foreach ($type in $supportedFileTypes) {
        $choices.Add((New-Object System.Management.Automation.Host.ChoiceDescription -ArgumentList "&$type"))
      }

      $decision = $Host.UI.PromptForChoice($message, $Question, $choices, 0)

      $installData.fileType = $supportedFileTypes[$decision]
    }

    if ($installData.fileType -eq 'msi') {
      $installData.silentArgs = '/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"'
      $installData.validExitCodes = '@(0, 2010, 1641)'
    }

    if (!$Embedd) {
      $m = [regex]::Match($content, ($regexFormat -f 'url(?:32)?'), $opts)
      if ($m.Success) { $installData.url = $m.Groups[1].Value }

      $m = [regex]::Match($content, ($regexFormat -f 'checksum(?:32)?'), $opts)
      if ($m.Success) { $installData.checksum = $m.Groups[1].Value }

      if ($supportsX64) {
        $m = [regex]::Match($content, ($regexFormat -f 'url64(?:bit)?'), $opts)
        if ($m.Success) { $installData.url64 = $m.Groups[1].Value }

        $m = [regex]::Match($content, ($regexFormat -f 'checksum64'), $opts)
        if ($m.Success) { $installData.checksum64 = $m.Groups[1].Value }
      }
    }

    $m = [regex]::Match($content, ($regexFormat -f 'silentArgs'), $opts)
    if ($m.Success) {
      $installData.silentArgs = $m.Groups[1].Value
    }

    $m = [regex]::Match($content, "^[$\s]+validExitCodes\s*=\s*(\([^\)]+\))", $opts)

    if ($m.Success) {
      $installData.validExitCodes = $m.Groups[1].Value
    }
  }

  $writer = New-Object System.IO.StringWriter
  $writer.WriteLine("`$ErrorActionPreference = 'Stop';")
  $writer.WriteLine('')
  if ($Embedd -or $package.fileType -eq 'zip') {
    $writer.WriteLine('$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"')
    $writer.WriteLine('')

    if ($supportsX64) {
      $writer.WriteLine('$filePath32 = "$toolsPath\"')
      $writer.WriteLine('$filePath64 = "$toolsPath\"')
      $writer.WriteLine("")
      $writer.WriteLine("")
      $writer.WriteLine('$filePath = if ((Get-ProcessorBits 64) -and $env:chocolateyForceX86 -ne $true) {')
      $writer.WriteLine('  Write-Host "Installing 64 bit version" ; $filePath64')
      $writer.WriteLine('} else { Write-Host "Installing 32 bit version" ; $filePath32 }')
      $writer.WriteLine("")
    } else {
      $writer.WriteLine('$filePath = "$toolsPath\"')
    }
  }
  if ($RegisterApp) {
    $writer.WriteLine("`$packageName = '$packageName'")
    $writer.WriteLine('')
  }
  $writer.WriteLine('$packageArgs = @{')
  if ($RegisterApp) {
    $writer.WriteLine('  packageName    = $packageName')
  } else {
    $writer.WriteLine("  packageName    = '$packageName'")
  }

  if ($package.FileType -ne 'zip') {
    $writer.WriteLine("  fileType       = '$($installData.fileType)'")
  }

  if ($Embedd) {
    $writer.WriteLine('  file           = $filePath')
  } else {
    $writer.WriteLine("  url            = '$($installData.url)'")
    if ($supportsX64) {
      $writer.WriteLine("  url64bit       = '$($installData.url64)'")
    }
  }

  $writer.WriteLine("  softwareName   = '$($installData.softwareName)'")
  if (!$Embedd) {
    $writer.WriteLine("  checksum       = '$($installData.checksum)'")
    $writer.WriteLine("  checksumType   = '$($installData.checksumType)'")
    if ($supportsX64) {
      $writer.WriteLine("  checksum64     = '$($installData.checksum64)'")
      $writer.WriteLine("  checksumType64 = '$($installData.checksumType64)'")
    }
  }

  if ($installData.fileType -eq 'msi') {
    $writer.WriteLine("  silentArgs     = `"$($installData.silentArgs)`"")
  } elseif ($installData.fileType -eq 'exe') {
    $writer.WriteLine("  silentArgs     = '$($installData.silentArgs)'")
  }

  if ($installData.fileType -ne 'zip') {
    $writer.WriteLine("  validExitCodes = $($installData.validExitCodes)")
  }

  $writer.WriteLine('}')
  $writer.WriteLine('')

  if ($installData.fileType -eq 'zip') {
    if ($Embedd) {
      $writer.WriteLine('Get-ChocolateyUnzip @packageArgs')
    } else {
      $writer.WriteLine('Install-ChocolateyZipPackage @packageArgs')
    }
  } elseif ($Embedd) {
    $writer.WriteLine('Install-ChocolateyInstallPackage @packageArgs')
    $writer.WriteLine('');
    if ($supportsX64) {
      $writer.WriteLine('Remove-Item -Force -ea 0 $filePath32,$filePath64,"$filePath32.ignore","$filePath64.ignore"')
    } else {
      $writer.WriteLine('Remove-Item -Force -ea 0 $filePath,"$filePath.ignore"')
    }
  } else {
    $writer.WriteLine('Install-ChocolateyPackage @packageArgs')
  }

  if ($RegisterApp) {
    $writer.WriteLine("")
    $writer.WriteLine('$installLocation = Get-AppInstallLocation $packageArgs.softwareName')
    $writer.WriteLine('if ($installLocation) {')
    $writer.WriteLine('  Write-Host "$packageName installed to ''$installLocation''"')
    $writer.WriteLine('  Register-Application "$installLocation\$packageName.exe"')
    $writer.WriteLine('  Write-Host "$packageName registered as $packageName"')
    $writer.WriteLine('} else {')
    $writer.WriteLine('  Write-Warning "Can''t find $PackageName install location"')
    $writer.WriteLine('}')
  }

  [System.IO.File]::WriteAllText($path, $writer.ToString(), $BOMEncoding)
}

if ($uninstallScript) {
  $path = "$($package.DirectoryPath)\tools\chocolateyUninstall.ps1"

  if ($installData) {
    $uninstallData = @{
      fileType       = $installData.fileType
      silentArgs     = $installData.silentArgs
      validExitCodes = $installData.validExitCodes
    }
  } else {
    $uninstallData = @{
      fileType       = 'exe'
      silentArgs     = ''
      validExitCodes = '@(0)'
    }
  }

  if (Test-Path $path) {
    $content = Get-Content -Encoding UTF8 $path
    $opts = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    #$m = $content | Where-Object { $_ -match "^[$\s]+fileType\s*=\s*['`"](.+)['`"]" } | Select-Object -first 1
    $m = [regex]::Match($content, "^[$\s]+fileType\s*=\s*['`"]([^'`"]+)['`"]", $opts)
    if ($m.Success) {
      $installData.fileType = $m.Groups[1].Value
    }

    if ($installData.fileType -eq 'msi') {
      $installData.silentArgs = '/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"'
      $installData.validExitCodes = '@(0, 2010, 1641)'
    }

    $m = [regex]::Match($content, "^[$\s]+silentArgs\s*=\s*['`"]([^'`"]+)['`"]", $opts)
    if ($m.Success) {
      $installData.silentArgs = $m.Groups[1].Value
    }

    $m = [regex]::Match($content, "^[$\s]+validExitCodes\s*=\s*(\([^\)]+\))", $opts)

    if ($m.Success) {
      $installData.validExitCodes = $m.Groups[1].Value
    }
  }

  $writer = New-Object System.IO.StringWriter
  $writer.WriteLine("`$ErrorActionPreference = 'Stop';")
  $writer.WriteLine('')
  $writer.WriteLine('$packageArgs = @{')
  $writer.WriteLine('  packageName   = $env:ChocolateyPackageName')
  $writer.WriteLine("  softwareName  = ''")
  $writer.WriteLine("  fileType      = '$($uninstallData.fileType)'")
  if ($uninstallData.fileType -eq 'msi') {
    $writer.WriteLine("  silentArgs    = `"`$(`$_.PSChildName) $($uninstallData.silentArgs)`"")
  } else {
    $writer.WriteLine("  silentArgs    = '$($uninstallData.silentArgs)'")
  }
  $writer.WriteLine("  validExitCodes= @($($uninstallData.validExitCodes -join ','))")
  $writer.WriteLine('}')
  $writer.WriteLine("")
  $writer.WriteLine('$uninstalled = $false')
  $writer.WriteLine('')

  $writer.WriteLine("[array]`$key = Get-UninstallRegistryKey @packageArgs")
  $writer.WriteLine('')
  $writer.WriteLine('if ($key.Count -eq 1) {')
  $writer.WriteLine('  $key | ForEach-Object {')

  if ($uninstallData.fileType -eq 'msi') {
    $writer.WriteLine("    `$packageArgs['silentArgs'] = `"`$(`$_.PSChildName) `$(`$packageArgs['silentArgs'])`"")
    $writer.WriteLine("    `$packageArgs['file'] = ''")
  } else {
    $writer.WriteLine("    `$packageArgs['file'] = `"`$(`$_.UninstallString)`"")
  }

  $writer.WriteLine('')
  $writer.WriteLine('    Uninstall-ChocolateyPackage @packageArgs')

  if ($RegisterApp -and $uninstallData.fileType -eq 'exe') {
    $writer.WriteLine('')
    $writer.WriteLine('    $regKey ="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$($packageArgs[''packageName'']).exe"')
    $writer.WriteLine('    if (Test-Path $regKey) {')
    $writer.WriteLine('      Remove-Item $regKey -Force -ea 0')
    $writer.WriteLine('    }')
  }
  $writer.WriteLine('  }')
  $writer.WriteLine('} elseif ($key.Count -eq 0) {')
  $writer.WriteLine('  Write-Warning "$packageName has already been uninstalled by other means."')
  $writer.WriteLine('} elseif ($key.Count -gt 1) {')
  $writer.WriteLine('  Write-Warning "$($key.Count) matches found!"')
  $writer.WriteLine('  Write-Warning "To prevent accidental data loss, no programs will be uninstall."')
  $writer.WriteLine('  Write-Warning "Please alert the package maintainer the following keys were matched:"')
  $writer.WriteLine('  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }')
  $writer.WriteLine('}')

  [System.IO.File]::WriteAllText($path, $writer.ToString(), $BOMEncoding)
}

$newNuspec = $null

. $PSScriptRoot\Update-IconUrl $id
