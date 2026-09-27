$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters
$silentArgs = '/silent'
if ($pp.ContainsKey('folder')) {
  if ($pp.folder -is [bool] -or [string]::IsNullOrWhiteSpace($pp.folder) -or $pp.folder -match '["\r\n]') {
    throw 'Package parameter /folder requires a folder path without embedded double quotes or newlines.'
  }
  $silentArgs += ' /folder="{0}"' -f $pp.folder
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file          = "$toolsDir\iview476_plugins_setup.exe"
  file64        = "$toolsDir\iview476_plugins_x64_setup.exe"
  silentArgs     = $silentArgs
  validExitCodes = @(0)
  softwareName   = ''
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

