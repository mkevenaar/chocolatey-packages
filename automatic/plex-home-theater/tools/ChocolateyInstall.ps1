$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file          = "$toolsDir\PlexHomeTheater-1.4.1.469-47a90f01-windows-x86"
  softwareName  = 'Plex Home Theater*'
  silentArgs    = '/S'
  validExitCodes= @(0,1)
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
