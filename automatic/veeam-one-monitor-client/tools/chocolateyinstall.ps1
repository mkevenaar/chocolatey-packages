$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$isoPackageName = 'veeam-one-iso'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'VeeamONE.10.0.0.750.iso'
$installPath = Join-Path  (Join-Path $commonPath $isoPackageName) $filename

$fileLocation = 'Monitor\VeeamONE.Monitor.Client.x86.msi'
$fileLocation64 = 'Monitor\VeeamONE.Monitor.Client.x64.msi'

$pp = Get-PackageParameters

$silentArgs = ""

if ($pp.monitorServer) {
  $silentArgs += " VM_CLN_SERVER_NAME=$($pp.monitorServer)"
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  isoFile        = $installPath
  softwareName   = 'Veeam ONE Monitor Client*'
  file           = $fileLocation
  file64         = $fileLocation64
  fileType       = 'msi'
  silentArgs     = "$($silentArgs) ACCEPTEULA=YES ACCEPT_THIRDPARTY_LICENSES=1 /qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes = @(0,1638,1641,3010) #1638 was added to allow updating when an newer version is already installed.
  destination    = $toolsDir
}

Install-ChocolateyIsoInstallPackage @packageArgs
