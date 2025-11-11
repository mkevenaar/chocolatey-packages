$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://api.gitkraken.dev/releases/production/windows/x64/active/GitKrakenSetup.exe'
$checksum64     = '11eab08999b722c69aa318aeae13f0cd7d2838b6ddc59d389891081b49215739'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe' #only one of these: exe, msi, msu
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  silentArgs   = '-s'
  validExitCodes= @(0) #please insert other valid exit codes here
  softwareName  = 'GitKraken*'
}

$GitKrakenPath = Join-Path -Path $Env:LOCALAPPDATA -ChildPath 'gitkraken\gitkraken.exe'

$Outdated = if (Test-Path -Path $GitKrakenPath) {
  $InstalledVersion = (Get-ItemProperty -Path $GitKrakenPath -ErrorAction:SilentlyContinue).VersionInfo.ProductVersion
  [Version]$($Env:ChocolateyPackageVersion) -gt [Version]$InstalledVersion
}
else {
  # GitKraken is not installed, therefore it is outdated.
  $true
}

if ($Env:ChocolateyForce -or $Outdated) {
  Install-ChocolateyPackage @packageArgs
}
