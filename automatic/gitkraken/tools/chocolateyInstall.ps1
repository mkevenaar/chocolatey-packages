$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://release.gitkraken.dev/gkd/production/normal/windows/x64/12.1.2/3Dw9sjrjlinnbuD3dWGWCo06q28/GitKrakenSetup.exe'
$checksum64     = '9d11b27ce7490b099b05b2c1a1790f9ffbe23f3d7f260f2c4e6cda8616554ddd'
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
