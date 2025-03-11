$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://release.gitkraken.com/windows/GitKrakenSetup.exe'
$checksum64     = '149ed43e4c95fb3f169e6c09d292f69f5b4c17d13f6e26728e55d710c4ea1743'
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
