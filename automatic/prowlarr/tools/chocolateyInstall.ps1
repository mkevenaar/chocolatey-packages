﻿$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$servicename = 'prowlarr'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file          = "$toolsDir\Prowlarr.master.2.1.5.5216.windows-core-x86-installer.exe"
  file64        = "$toolsDir\Prowlarr.master.2.1.5.5216.windows-core-x64-installer.exe"
  softwareName  = 'Prowlarr*'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).InnoInstall.log`""
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

# Start service if it's not running
if (Get-Service "$servicename" -ErrorAction SilentlyContinue) {
  $running = Get-Service $servicename
  if ($running.Status -eq "Running") {
    Write-Host 'Service is already running'
  } elseif ($running.Status -eq "Stopped") {
    Start-Service $servicename
  }
}
