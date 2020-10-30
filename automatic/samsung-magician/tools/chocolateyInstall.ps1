$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://s3.ap-northeast-2.amazonaws.com/global.semi.static/SAMSUNG_SSD_MAGICIAN_201016/SW/5F99E3AA2FB6AC1BAC402B41D766B74675B9E5CD0C0055C39A2A1EB27C8E09EC/Samsung_Magician_Installer.zip'
$checksum     = 'fe5671d1092d32662a0f4defc416a689e376621140c3c527cff6188b701b2f18'
$checksumType = 'sha256'

$packageArgs = @{
  PackageName    = $env:ChocolateyPackageName
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  Destination    = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file           = Get-Item $toolsDir\*.exe
  softwareName   = 'Samsung Magician*'
  silentArgs     = ""
  validExitCodes = @(0,3010)
}

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkEXE = Get-ChildItem "$env:ChocolateyInstall\lib\autohotkey.portable" -Recurse -filter autohotkey.exe
$ahkProc = Start-Process -FilePath $ahkEXE.FullName -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Install-ChocolateyInstallPackage @packageArgs

if (Get-Process -id $ahkProc.Id -ErrorAction SilentlyContinue) {Stop-Process -id $ahkProc.Id}
