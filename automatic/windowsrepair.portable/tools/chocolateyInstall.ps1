$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://www.tweaking.com/files/setups/tweaking.com_windows_repair_aio.zip'
$checksum     = 'dcd45be99f0f31c8e8a6918efcc5f8421ff0fd5fac791ab972558f159c05ab9e'
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
