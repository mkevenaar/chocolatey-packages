$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  file           = "$toolsdir\DB.Browser.for.SQLite-3.12.2-win32.zip"
  file64         = "$toolsdir\DB.Browser.for.SQLite-3.12.2-win64.zip"
}

Get-ChocolateyUnzip  @packageArgs

