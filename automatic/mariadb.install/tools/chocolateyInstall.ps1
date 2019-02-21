$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url32          = 'https://downloads.mariadb.org/f/mariadb-10.3.13/win32-packages/mariadb-10.3.13-win32.msi'
$checksum32     = 'af23820183a379b45f6d9b9a2ba2b3dd8822fddf97b2ea8ee88936fc2ef466df'
$checksumType32 = 'sha256'
$url64          = 'https://downloads.mariadb.org/f/mariadb-10.3.13/winx64-packages/mariadb-10.3.13-winx64.msi'
$checksum64     = '6b750c22f385057c91687fa33d139c7df95270164e1ff588980422c128fc122d'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url           = $url32
  checksum      = $checksum32
  checksumType  = $checksumType32
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= $checksumType64
  softwareName   = 'MariaDB *'
  silentArgs     = "SERVICENAME=MySQL /qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0,3010)
}

Write-Verbose "Downloading and installing program..."
Install-ChocolateyPackage @packageArgs

Write-Verbose "Querying registry for install location..."
$packageSearch = "MariaDB *"
$regKey = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                   'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                   'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
                           -ErrorAction:SilentlyContinue `
          | Where-Object {$_.DisplayName -like $packageSearch}

Write-Verbose "Adding MariaDB bin directory to path environment variable..."
$binPath = Join-Path $regKey.InstallLocation[0] "bin"
if ($binPath) {
  Install-ChocolateyPath $binPath 'Machine'

  Write-Verbose "Starting service..."
  Start-Process -FilePath "NET" `
                -ArgumentList 'START MySQL' `
                -Wait `
                -NoNewWindow
}
