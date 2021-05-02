$ErrorActionPreference = 'SilentlyContinue'

$binRoot                = Get-ToolsLocation
$installDir             = Join-Path $binRoot $env:ChocolateyPackageName
$installDirBin          = "$($installDir)\current"

Start-Process npm -ArgumentList "run stop:delete" -WorkingDirectory $installDirBin -NoNewWindow -Wait

# Kill all leftover node processes.
Get-Process -Name Node -ErrorAction SilentlyContinue | Stop-Process
