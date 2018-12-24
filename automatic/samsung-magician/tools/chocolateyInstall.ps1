$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url          = 'http://downloadcenter.samsung.com/content/SW/201812/20181205162757370/Samsung_Magician_Installer.exe'
$checksum     = '00a64011d594f7d0fc0ea0748dff7f7c3057c021cdf2a26bb5148066c273a5e8'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Samsung Magician*'
  silentArgs     = ""
  validExitCodes = @(0,3010)
}

$ahkExe = Get-ChildItem "$env:ChocolateyInstall\lib\autohotkey.portable" -Recurse -filter AutoHotKey.exe
$ahkFile = Join-Path $toolsDir "chocolateyInstall.ahk"
$ahkProc = Start-Process -FilePath $ahkExe `
                         -ArgumentList $ahkFile `
                         -PassThru
 
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

Install-ChocolateyPackage @packageArgs
