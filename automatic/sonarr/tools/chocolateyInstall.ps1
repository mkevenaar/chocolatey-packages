$ErrorActionPreference = 'Stop'

$packageName = 'sonarr'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$fileLocation32bit = Get-Item "$toolsDir\*x86-installer.exe"
$fileLocation64bit = Get-Item "$toolsDir\*x64-installer.exe"

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'exe'
  file           = $fileLocation32bit
  file64         = $fileLocation64bit
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).InnoInstall.log`""
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

# Remove the installers as there is no more need for it
Remove-Item $toolsDir\*.exe -ea 0 -Force

# Use sonarrs service installer since
# it no longer seems to have a switch for V3
# and service install is no longer default
Start-Process "$Env:ProgramData\Sonarr\bin\ServiceInstall.exe"
$fexist = Test-Path "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Sonarr.lnk"
if ($fexist) {
  Remove-Item "$Env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\Sonarr.lnk" -Force
} else {
  Write-Host "shortcut has already been removed"
}

# Start service if it's not running
if (Get-Service "$packageName" -ErrorAction SilentlyContinue) {
  $running = Get-Service $service
  if ($running.Status -eq "Running") {
    Write-Host 'Service is already running'
  } elseif ($running.Status -eq "Stopped") {
    Start-Service $service
  }
}
