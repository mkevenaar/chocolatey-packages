$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.wdc.com/wdapp/WDSecurity_WIN.zip'
$checksum = '71d04ec5d2061d5e0748bd5576d3eea68e3df1320ee0edf8f9c09e0819ef2b27'
$checksumType = 'sha256'
$fileLocation = Join-Path -Path $toolsDir -ChildPath 'WDSecurity_WIN' | Join-Path -ChildPath "WDSecuritySetup.exe"

$downloadArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage @downloadArgs

$installArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'WD Security*'
  file          = $fileLocation
  fileType      = 'exe'
  silentArgs    = "/s"
  validExitCodes= @(0)
  destination   = $toolsDir
}

Install-ChocolateyInstallPackage @installArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
