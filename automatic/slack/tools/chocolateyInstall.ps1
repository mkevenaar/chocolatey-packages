$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.34.115/prod/ia32/slack-standalone-4.34.115.0.msi'
$checksum32     = '31fb7e3a47e9519829086c9063f93ab7a297fe9f5afe965ac3b3ba5630ee88ab'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.34.115/prod/x64/slack-standalone-4.34.115.0.msi'
$checksum64     = '4478ab9081c78d8e81927cfd1fc0c554209fbce18e15f1f02cd32d45447b9557'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Slack*'
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0)
}

$SlackPath = Join-Path -Path $Env:ProgramFiles -ChildPath 'Slack\slack.exe'
$SlackPresent = Test-Path -Path $SlackPath

if ($SlackPresent) {
  $InstalledVersion = (Get-ItemProperty -Path $SlackPath -ErrorAction:SilentlyContinue).VersionInfo.ProductVersion
  $SlackOutdated = [Version]$($Env:ChocolateyPackageVersion) -gt [Version]$InstalledVersion
}

# Only Attempt an install if the existing version is the same or newer than the package version, or if forced
if (-not $SlackPresent -or ($SlackPresent -and $SlackOutdated) -or $Env:ChocolateyForce)
{
  Get-Process 'slack' -ErrorAction SilentlyContinue | Stop-Process -Force
  Install-ChocolateyPackage @packageArgs
}
