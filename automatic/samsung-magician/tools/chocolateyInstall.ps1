$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

$url                       = 'https://download.semiconductor.samsung.com/resources/software-resources/Samsung_Magician_Installer_Official_8.1.0.800.exe'
$checksum                  = '5F3F8D53B3DD8FA7655366A7C2B4427B8799FA52BC242176C1F67ACFCDB7B2C5'
$checksumType              = 'sha256'

# Download the installer using Chocolatey's internal handling
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  softwareName   = 'Samsung Magician*'
}

# Use AutoHotkey portable from the Choco directory
$ahkEXE = Get-ChildItem -Path "$env:ChocolateyInstall\lib\autohotkey.portable\tools" -Filter 'AutoHotKey.exe' -Recurse -ErrorAction SilentlyContinue
if (-not $ahkEXE) {
  Write-Error "AutoHotKey executable not found in $env:ChocolateyInstall\lib\autohotkey.portable\tools"
  return
}

# Start AutoHotKey script for the silent install
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath $ahkEXE.FullName -ArgumentList $ahkFile -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Write-Output (("-") * 80)
Write-Warning "Please wait a few minutes for Samsung Magician to install."
Write-Warning "If you run into errors, please run the install again and refrain from using the computer during the install."
Write-Output (("-") * 80)

# Install the package
Install-ChocolateyPackage @packageArgs

if (Get-Process -id $ahkProc.Id -ErrorAction SilentlyContinue) {Stop-Process -id $ahkProc.Id}
