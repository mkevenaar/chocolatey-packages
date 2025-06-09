$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://downloads.slack-edge.com/desktop-releases/windows/x64/4.44.65/slack-standalone-4.44.65.0.msi'
$checksum64     = '7906c6ded34a105e9d011b3e7405965d56a20dca48de314d592a0c68c4ae21de'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'msi'
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
