$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://files1.majorgeeks.com/10afebdbffcd4742c81a3cb0f6ce4092156b4375/multimedia/MusicBeeSetup_3_5.zip'
$checksum     = 'be27f1149654924dddd106254493137280f3e8098ec1029435c02fdda092bdb5'
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
