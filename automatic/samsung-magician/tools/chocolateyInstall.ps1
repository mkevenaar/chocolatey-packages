$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

$url                       = 'https://org.downloadcenter.samsung.com/downloadfile/ContentsFile.aspx?CDSite=UNI_UK&OriginYN=N&ModelType=N&ModelName=MZ-V9P4T0&CttFileID=9456399&CDCttType=SW&VPath=SW%2F202609%2F20260915101727932%2FSamsung_Magician_Installer_Official_9.0.2.500.exe'
$checksum                  = '645CC9F19E411645CC3D8C862359B8A41C8CC53C7B1C1D262C25CAED67F46624'
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

# The installer asks whether the user lives in a GDPR country or Brazil; answer No unless /GDPR:Yes is passed.
$pp = Get-PackageParameters
$gdprAnswer = if ($pp.GDPR -match '^(y|yes|true|1)$') { 'Yes' } else { 'No' }

# Start AutoHotKey script for the silent install
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath $ahkEXE.FullName -ArgumentList "`"$ahkFile`" $gdprAnswer" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Write-Output (("-") * 80)
Write-Warning "Please wait a few minutes for Samsung Magician to install."
Write-Warning "If you run into errors, please run the install again and refrain from using the computer during the install."
Write-Output (("-") * 80)

# Install the package
Install-ChocolateyPackage @packageArgs

if (Get-Process -id $ahkProc.Id -ErrorAction SilentlyContinue) {Stop-Process -id $ahkProc.Id}
