$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://www.tweaking.com/files/setups/tweaking.com_windows_repair_aio.zip'
$checksum     = '3cffdf09c842bf3d31195cc8ab565749c996327d790d420083d5aed1fc11c483'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

# create empty sidecar so shimgen creates shim for GUI rather than console
$installFile = Join-Path -Path $toolsDir `
                         -ChildPath "Repair_Windows.exe.gui"
Set-Content -Path $installFile `
            -Value $null
