$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$servicename    = 'sonarr'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file          = "$toolsDir\Sonarr.develop.4.0.16.2942.win-x86-installer.exe"
  file64        = "$toolsDir\Sonarr.develop.4.0.16.2942.win-x64-installer.exe"
  softwareName  = 'Sonarr*'
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).InnoInstall.log`""
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

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
if (Get-Service "$servicename" -ErrorAction SilentlyContinue) {
  $running = Get-Service $servicename
  if ($running.Status -eq "Running") {
    Write-Host 'Service is already running'
  } elseif ($running.Status -eq "Stopped") {
    Start-Service $servicename
  }
}
