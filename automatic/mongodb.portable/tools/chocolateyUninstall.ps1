$packageName = 'mongodb'
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unPath = Join-Path $toolsPath 'Uninstall-ChocolateyPath.psm1'

$binRoot = Get-ToolsLocation
$installDir = Join-Path $binRoot "$packageName"
$installDirBin = "$($installDir)\current\bin"
if (Test-Path $installDirBin) {
  Remove-Item $installDirBin -Recurse -Force
}

Write-Verbose "Removing from path..."
Import-Module $unPath
Uninstall-ChocolateyPath $installDirBin
