$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://download.cpuid.com/cpu-z/cpu-z_2.16-en.exe'
  checksum       = '9d2e3b817f89caadd7d373a0032cf2443844bbe22eebdcca0a758d2a91924871'
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
