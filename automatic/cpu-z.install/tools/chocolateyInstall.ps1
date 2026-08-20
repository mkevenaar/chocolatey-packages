$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://download.cpuid.com/cpu-z/cpu-z_3.01-en.exe'
  checksum       = '74ab9b1c24fb223d0a5c23e2e444b6cbba7d0c6882cc4bf389e3f88bfca37490'
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
