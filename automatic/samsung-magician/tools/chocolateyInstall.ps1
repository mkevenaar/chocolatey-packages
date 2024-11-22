$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

$url = 'https://download.semiconductor.samsung.com/resources/software-resources/Samsung_Magician_Installer_Official_8.2.0.880.exe'
$checksum = 'c327ec05524d1447973050513e34942c7f4073141313d393f0a73025c4ebba26'
$checksumType = 'sha256'

# Download the installer using Chocolatey's internal handling
$packageArgs = @{
  PackageName  = $env:ChocolateyPackageName
  url          = $url
  checksum     = $checksum
  checksumType = $checksumType
  Destination  = $toolsDir
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
