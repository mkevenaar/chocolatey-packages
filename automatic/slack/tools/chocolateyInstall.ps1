$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.slack-edge.com/releases/windows/4.35.131/prod/ia32/slack-standalone-4.35.131.0.msi'
$checksum32     = 'd37499f3ef28faf8357c57e26974e3f140cfe20359acd372df5889781e228206'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.slack-edge.com/releases/windows/4.35.131/prod/x64/slack-standalone-4.35.131.0.msi'
$checksum64     = '9b1561ff02965194edfbdc2ea9467dcf8908e31317aafa663c1895fdd9ce22af'
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
