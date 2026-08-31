$ErrorActionPreference = 'Stop';

$url64          = 'https://downloads.slack-edge.com/desktop-releases/windows/x64/4.52.155/Slack.msix'
$checksum64     = '3697483496a0239438671840630b292cd0eb864a5615b74cdd7b338eea101734'
$checksumType64 = 'sha256'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. (Join-Path $toolsDir 'helper.ps1')

$packageName = $env:ChocolateyPackageName
$appxPackageName = 'com.tinyspeck.slackdesktop'
$targetVersion = [version]"$($env:ChocolateyPackageVersion).0"
$fileName = 'Slack.msix'
$downloadCachePath = Get-SlackDownloadCachePath -PackageName $packageName -Version $env:ChocolateyPackageVersion
$fileFullPath = Join-Path -Path $downloadCachePath -ChildPath $fileName

if (-not [Environment]::Is64BitOperatingSystem) {
  throw 'Slack MSIX requires 64-bit Windows.'
}

$WindowsVersion = [Environment]::OSVersion.Version
if ($WindowsVersion.Major -lt 10) {
  throw 'Slack MSIX requires Windows 10 or newer.'
}

$packageArgs = @{
  packageName   = $packageName
  fileFullPath  = $fileFullPath
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
}

if ($MyInvocation.InvocationName -eq '.') {
  return
}

if ($env:ChocolateyAllowEmptyChecksums -eq 'true' -and $env:ChocolateyPackageName -like 'chocolatey\*') {
  Get-ChocolateyWebFile @packageArgs
  return
}

$installedVersion = Get-SlackAppxVersion -AppxPackageName $appxPackageName

Uninstall-LegacySlackMsi -PackageName $packageName

if ($installedVersion -gt $targetVersion) {
  Write-Warning "Slack $installedVersion is already installed, which is newer than this package version."
  return
}

if ($installedVersion -eq $targetVersion -and -not $env:ChocolateyForce) {
  Write-Host "Slack $targetVersion is already installed. Use --force to reinstall."
  return
}

if ($installedVersion -eq $targetVersion -and $env:ChocolateyForce) {
  Uninstall-SlackMsix -AppxPackageName $appxPackageName
}

Get-ChocolateyWebFile @packageArgs
Add-AppxProvisionedPackage -Online -PackagePath $fileFullPath -SkipLicense -Regions 'all'
