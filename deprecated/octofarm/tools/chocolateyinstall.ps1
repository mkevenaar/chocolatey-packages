$ErrorActionPreference  = 'Stop';
$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$binRoot                = Get-ToolsLocation
$installDir             = Join-Path $binRoot $env:ChocolateyPackageName
$installDirBin          = "$($installDir)\current"

# pm2 is a required NodeJS package for OctoFarm
Start-Process npm -ArgumentList "install pm2 -g" -NoNewWindow -Wait -ErrorAction SilentlyContinue

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $installDir
  fileType       = 'exe'
  file           = "$toolsdir\v1.7.3.zip"
  validExitCodes = @(0)
}

Get-ChocolateyUnzip  @packageArgs

Get-ChildItem $toolsPath\*.zip | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

# find the unpack directory
$installedContentsDir = Get-ChildItem $installDir -include 'OctoFarm*' | Sort-Object -Property LastWriteTime -Desc | Select-Object -First 1

# delete current directory contents
if ([System.IO.Directory]::Exists("$installDirBin")) {
  Write-Host "Clearing out the contents of `'$installDirBin`'."
  Start-Sleep 3
  [System.IO.Directory]::Delete($installDirBin,$true)
}

# copy the installed directory into the current dir
Write-host "Copying contents of `'$installedContentsDir`' to `'$($installDir)\current`'."
[System.IO.Directory]::CreateDirectory("$installDirBin") | Out-Null
Copy-Item "$($installedContentsDir)\*" "$($installDir)\current" -Force -Recurse

Start-Process npm -ArgumentList "start" -WorkingDirectory $installDirBin
