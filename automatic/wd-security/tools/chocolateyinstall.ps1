$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.wdc.com/wdapp/WDSecurity_WIN.zip'
$checksum = '7489c3b4e0b9a5c59eb5dcb01f3e5fdcb1b224ae3affa2f627d399f82dc0ae89'
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
