$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file           = "$toolsdir\grafana-agent-installer.exe"
  silentArgs     = '/S'
  validExitCodes = @(0, 1000, 1101)
}

Write-Verbose "Installing program..."
Install-ChocolateyPackage  @packageArgs

