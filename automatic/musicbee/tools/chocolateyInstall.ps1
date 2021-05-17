$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.mediafire.com/file/a2bnughg9i2sv4u/MusicBeeSetup_3_4_Update1.zip'
$checksum     = '405010d8a387e20aa5754b14732f37008a7733e646aa9c4290cf8dcb53e4003f'
$checksumType = 'sha256'


$downloadArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage @downloadArgs

$fileLocation = (Get-ChildItem $toolsDir -Filter *.exe | Select-Object -First 1).FullName

$installArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'MusicBee*'
  file          = $fileLocation
  fileType      = 'exe'
  silentArgs    = "/S"
  validExitCodes= @(0)
  destination   = $toolsDir
}

Install-ChocolateyInstallPackage @installArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
