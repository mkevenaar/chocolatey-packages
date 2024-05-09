$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/desktop-releases/windows/ia32/4.38.121/slack-standalone-4.38.121.0.msi'
$checksum32     = '7118deb09252370b37522fc6eed846601db7c2dec215f33a12de4ab1528c65f7'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/desktop-releases/windows/x64/4.38.121/slack-standalone-4.38.121.0.msi'
$checksum64     = 'eee06dc75fdc2e30b053bc50e7982a9ecaf6829dbb399d455836cfdc2893c8c5'
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
