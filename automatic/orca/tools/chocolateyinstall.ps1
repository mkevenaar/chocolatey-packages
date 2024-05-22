$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.microsoft.com/download/2/6/f/26f7aa55-ef6f-4882-b19b-a1be0e7328fe/KIT_BUNDLE_WINDOWSSDK_MEDIACREATION/winsdksetup.exe'
$checksum     = '5535188a9aeea1cebcbf04de3c2c37d76f10600a65867ff65f6153d507b60488'
$checksumType = 'sha256'

# This just downloads a bunch of files onto the machine, including the Orca MSI
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Windows Software Development Kit*'
  silentArgs    = "/features OptionId.MSIInstallTools /layout $toolsdir /Quiet /NoRestart /Log `"$env:temp\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyPackage @packageArgs

# Package needs to install MSI that is installed by the software
$packageArgs = @{
  packageName   = "$env:chocolateyPackageName"
  fileType      = 'msi'
  softwareName  = 'Orca*'
  silentArgs    = "/qn /norestart /l*v `"$env:temp\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  file          = "$toolsDir\Installers\Orca-x86_en-us.msi"
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item -Recurse -Force $toolsDir\Installers -ea 0

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

