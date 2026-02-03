$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://api.gitkraken.dev/releases/production/windows/x64/active/GitKrakenSetup.exe'
$checksum64     = 'dd494dded246efbb059f08af806203d378ea4f6f1b24085fa5c97d8f59f30622'
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
