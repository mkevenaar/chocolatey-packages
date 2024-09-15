$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters

$parameters += if (-not $pp.NoDesktopShortcut)     { " SHORTCUT_SQLITE_DESKTOP=1 SHORTCUT_SQLCIPHER_DESKTOP=1"; }
$parameters += if (-not $pp.NoStartmenuShortcut)     { " SHORTCUT_SQLITE_PROGRAMMENU=1 SHORTCUT_SQLCIPHER_PROGRAMMENU=1"; }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  file           = "$toolsdir\DB.Browser.for.SQLite-v3.13.0-win32.msi"
  file64         = "$toolsdir\DB.Browser.for.SQLite-v3.13.0-win64.msi"
  softwareName   = 'DB Browser for SQLite*'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" + $parameters
  validExitCodes = @(0,3010)
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsPath\*.msi | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
