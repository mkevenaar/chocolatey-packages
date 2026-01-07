$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://download.cpuid.com/cpu-z/cpu-z_2.18-en.exe'
  checksum       = '9fec610e6ea575101ffd12291bca3f6364906ca4773096fd0c6802e2a5fedac0'
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
