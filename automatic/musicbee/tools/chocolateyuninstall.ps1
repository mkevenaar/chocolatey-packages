$ErrorActionPreference = "Stop";
$packageName = "musicbee"
$installerType = "exe"
$silentArgs = "/S"
$validExitCodes = @(0)

$is64bit = Get-ProcessorBits 64

if ($is64bit) {
  $setupExePath = (Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\MusicBee).UninstallString
}
else {
  $setupExePath = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MusicBee).UninstallString
}

$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$ahkFile = Join-Path $scriptPath "musicbeeUninstall.ahk"
$ahkRun = "$Env:Temp\$(Get-Random).ahk"

Copy-Item $ahkFile "$ahkRun" -Force
$ahkProc = Start-Process -FilePath "AutoHotKey" `
      -ArgumentList $ahkRun `
      -PassThru
Write-Debug "$ahkRun start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "$ahkRun process ID:`t$($ahkProc.Id)"

  Uninstall-ChocolateyPackage -PackageName "$packageName" `
                              -FileType "$installerType" `
                              -SilentArgs "$silentArgs" `
                              -ValidExitCodes $validExitCodes `
                              -File "$setupExePath"

Remove-Item "$ahkRun" -Force
