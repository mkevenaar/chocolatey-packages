$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $Env:ChocolateyPackageName
  fileType       = 'exe'
  url            = 'https://download.cpuid.com/cpu-z/cpu-z_2.21-en.exe'
  checksum       = '784fe4f06ba1c53cf396f6751ec8b8ba59145c702e06a2650b80c632c479123f'
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
