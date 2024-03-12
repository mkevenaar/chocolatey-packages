$ErrorActionPreference = 'Stop'

$packageName = 'jackett'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$fileLocation = Get-Item "$toolsDir\*.exe"

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  file           = $fileLocation
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).InnoInstall.log`""
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

# Remove the installers as there is no more need for it
Remove-Item $toolsDir\*.exe -ea 0 -Force

# Start service if it's not running
if (Get-Service "$packageName" -ErrorAction SilentlyContinue) {
  $running = Get-Service $packageName
  if ($running.Status -eq "Running") {
    Write-Host 'Service is already running'
  } elseif ($running.Status -eq "Stopped") {
    Start-Service $packageName
  }
}
