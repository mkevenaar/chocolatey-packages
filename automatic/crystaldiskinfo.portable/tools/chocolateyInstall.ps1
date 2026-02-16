$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

Stop-CrystalDiskInfo

$fileName32 = "DiskInfo32.exe"
$fileName64 = "DiskInfo64.exe"
$linkName = "CrystalDiskInfo.lnk"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  destination    = $toolsDir
  file          = "$toolsDir\CrystalDiskInfo9_8_0.zip"
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

Get-ChildItem $toolsDir\CdiResource\AlertMail*.exe | ForEach-Object {
  #Ensure any shims that may have accidentally been generated with previous versions are removed
  Uninstall-BinFile -Name $_.BaseName
  Set-Content -Path "$_.ignore" -Value $null
}
