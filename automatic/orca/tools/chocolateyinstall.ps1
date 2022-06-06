$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.microsoft.com/download/f/6/7/f673df4b-4df9-4e1c-b6ce-2e6b4236c802/windowssdk/winsdksetup.exe'
$checksum     = '6c489de4a7ff206bdb15e97fedc397aa01da570bf83c3049aaf755d9376237c2'
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

