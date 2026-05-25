$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://download.cpuid.com/cpu-z/cpu-z_2.20.1-en.exe'
  checksum       = '8e818486808979f0653689dea0c44533343f8c4c9460a0e0f37982afb11b81e0'
  checksumType   = 'sha256'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
  validExitCodes = @(0)
  softwareName   = 'cpu-z'
}

Install-ChocolateyPackage @packageArgs

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageArgs.softwareName
if ($installLocation) {
  Write-Host "$packageName installed to '$installLocation'"
  Register-Application "$installLocation\cpuz.exe"
  Write-Host "$packageName registered as cpuz"
}
else { Write-Warning "Can't find $packageName install location" }
