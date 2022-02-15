$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$folder         = 'kse-551'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file          = "$toolsDir\kse-551.zip"
}

Install-ChocolateyZipPackage  @packageArgs

if (Test-ProcessAdminRights) {
    $specialFolder = [Environment+SpecialFolder]::CommonPrograms
} else {
    $specialFolder = [Environment+SpecialFolder]::Programs
}

$exePath = Join-Path -Path $toolsDir -ChildPath $folder |  Join-Path -ChildPath 'kse.exe'
$linkPath = [Environment]::GetFolderPath($specialFolder) | Join-Path -ChildPath 'KeyStore Explorer.lnk'
Install-ChocolateyShortcut -ShortcutFilePath $linkPath -TargetPath $exePath
