$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'https://download.cdn.viber.com/desktop/windows/ViberSetup.exe'
$checksum     = 'FC50DD6015706911FB8E7D611987942BBE7D34DB1BCAD82E617E5B24D74C4938'
$checksumType = 'sha256'
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = "Viber*"
  silentArgs     = '/install /quiet /norestart'
  validExitCodes = @(0)
  destination   = $toolsDir
}

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkEXE = Get-ChildItem "$env:ChocolateyInstall\lib\autohotkey.portable" -Recurse -filter autohotkey.exe
$ahkProc = Start-Process -FilePath $ahkEXE.FullName -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Install-ChocolateyPackage @packageArgs

if (Get-Process -id $ahkProc.Id -ErrorAction SilentlyContinue) {Stop-Process -id $ahkProc.Id}
