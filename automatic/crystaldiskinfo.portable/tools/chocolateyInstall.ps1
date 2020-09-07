$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$fileName32 = "DiskInfo32.exe"
$fileName64 = "DiskInfo64.exe"
$linkName = "CrystalDiskInfo.lnk"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file          = "$toolsDir\CrystalDiskInfo8_8_5.zip"
}

Install-ChocolateyZipPackage  @packageArgs

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
