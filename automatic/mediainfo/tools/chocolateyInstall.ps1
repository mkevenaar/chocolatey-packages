$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  file           = "$toolsdir\MediaInfo_GUI_19.09_Windows.exe"
  softwareName   = 'MariaDB *'
  silentArgs     = "/S"
  validExitCodes = @(0)
}

Write-Verbose "Downloading and installing program..."
Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsPath\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
