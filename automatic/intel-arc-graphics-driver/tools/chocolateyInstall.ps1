$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://downloadmirror.intel.com/921459/gfx_win_101.8826.exe'
$checksum64     = '5A4E2AA6A08AEEBE72AEF7FA92AFBFCD631A16ECC270E3A45E7D6ACF4CCD82E1'
$checksumType64 = 'sha256'

$minimumBuild = 19042
$osBuild = [Environment]::OSVersion.Version.Build
if ($osBuild -lt $minimumBuild) {
    Write-Warning "  ** Windows build $minimumBuild or higher is required."
    throw
   }

$videoCard = (Get-CimInstance -ClassName Win32_VideoController).Description
if (-not ($videoCard -match 'Intel')){
    Write-Warning "  ** No Intel display adapter found."
    throw
   }

Write-Host "  ** These drivers are for Intel 11th Gen processors and higher." -Foreground Yellow
Write-Host "  ** Use intel-graphics-driver for Intel 6th thru 10th Gen processors." -Foreground Yellow

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  silentArgs     = "--overwrite --silent --report $toolsDir\install.log"
  softwareName   = 'Intel Arc*'
  validExitCodes = @(0, 3010, 1641, 14)
}

Install-ChocolateyPackage @packageArgs
