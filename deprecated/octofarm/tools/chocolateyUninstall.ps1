$ErrorActionPreference  = 'Stop';

$binRoot                = Get-ToolsLocation
$installDir             = Join-Path $binRoot $env:ChocolateyPackageName

Write-Warning -Message "This package depends on NodeJS and MongoDB, you should manually uninstall these packages if not used for anyting else"

if ([System.IO.Directory]::Exists("$installDir")) {
  Write-Host "Clearing out the contents of `'$installDir`'."
  Start-Sleep 3
  [System.IO.Directory]::Delete($installDir,$true)
}
