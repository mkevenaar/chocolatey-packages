$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64          = 'https://downloadmirror.intel.com/930514/gfx_win_101.9150.exe'
$checksum64     = 'A4AC7A4A3C272D9FC821330B57C949B2B5602F7D8758257CF61B8EB743079171'
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
