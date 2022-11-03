$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.wdc.com/wdapp/WDSecurity_WIN.zip'
$checksum = '6fd47b3f659ccf09659ac213b47801cc8fee9658cc7a9c2efc5d75bfb65cdcbd'
$checksumType = 'sha256'
$fileLocation = Join-Path $toolsDir "WDSecuritySetup.exe"

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
