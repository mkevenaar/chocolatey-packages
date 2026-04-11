$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.microsoft.com/download/c5526ca8-88aa-4325-8d72-de642afc7356/KIT_BUNDLE_WINDOWSSDK_MEDIACREATION/winsdksetup.exe'
$checksum     = '2010278fca14c22ffac2829d17d13fd837148867f5287d6fbb52e9619573477a'
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

