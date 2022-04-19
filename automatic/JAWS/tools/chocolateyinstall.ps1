$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://jaws2022.vfo.digital/2022.2204.20.400/A0A93990-0D4A-42FA-91CC-85FEF705F33E/J2022.2204.20.400-Offline-x86.exe'
$checksum32     = 'c80d833cc32f850dd3adaaf8fbf5864ba6996602dd4994d5b09a8717fdfbaa94'
$checksumType32 = 'sha256'
$url64          = 'https://jaws2022.vfo.digital/2022.2204.20.400/A0A93990-0D4A-42FA-91CC-85FEF705F33E/J2022.2204.20.400-Offline-x64.exe'
$checksum64     = '0e07368a30393ac7e57e6fba899c6111ee3c5115b23e52603dccdb00b16d2afd'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName  = 'Freedom Scientific JAWS 2020*'
  silentArgs    = "/Type Silent"
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

