$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.plex.tv/plex-media-server-new/1.42.2.10156-f737b826c/windows/PlexMediaServer-1.42.2.10156-f737b826c-x86.exe'
$checksum32     = '7f472ccf09c652b03c1a16e2beb11590ed7c61dc613dd7d98cc8d4d08d6b974b'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.plex.tv/plex-media-server-new/1.43.2.10687-563d026ea/windows/PlexMediaServer-1.43.2.10687-563d026ea-x86_64.exe'
$checksum64     = 'eba16fadc08fb7011969a85ac546e7adb4d00343def157c39dfda9c7e7723bd9'
$checksumType64 = 'sha256'

Start-CheckandStop "Plex Media Server"

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
  softwareName  = 'plexmediaserver*'
  silentArgs    = '/quiet /VERYSILENT'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

if ($ProcessWasRunning -eq "True") {&$ProcessFullPath}
