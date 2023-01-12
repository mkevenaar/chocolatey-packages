$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

Stop-CrystalDiskMark

$fileName32 = "DiskMark32.exe"
$fileName64 = "DiskMark64.exe"
$linkName = "CrystalDiskMark.lnk"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  destination    = $toolsDir
  file          = "$toolsDir\CrystalDiskMark8_0_4c.zip"
}

Get-ChocolateyUnzip  @packageArgs

Remove-Item -ea 0 -Path $toolsDir\*.zip

#install start menu shortcut
$fileName = $fileName32
$is64bit = Get-OSArchitectureWidth 64
if ($is64bit) {
  $fileName = $fileName64
}

$programs = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutFilePath = Join-Path $programs $linkName 
$targetPath = Join-Path $toolsDir $fileName
Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
