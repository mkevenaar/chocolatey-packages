$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://www.scarm.info/SCARMsetup_1_9_7.exe'
$checksum     = '0efb4954f2c8b18454cc774ad7df81823658d83981fc12fe44ff8d546772b304'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName  = 'SCARM*'
  silentArgs    = "/VERYSILENT /NORESTART /RESTARTEXITCODE=3010 /SP- /SUPPRESSMSGBOXES /CLOSEAPPLICATIONS /FORCECLOSEAPPLICATIONS"
  validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs
