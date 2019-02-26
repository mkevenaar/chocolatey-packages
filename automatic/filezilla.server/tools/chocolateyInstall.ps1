$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file          = "$toolsDir\FileZilla_Server-0_9_60_2.exe"
  softwareName   = 'Psi*'
  silentArgs    = "/S"
  validExitCodes = @(0)
}
$programfiles = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]

$fileZillaInstallDir = Join-Path $programfiles "FileZilla Server"
$tempDir = "C:\temp\ftproot"

write-host "Chocolatey is installing FileZilla Server to $fileZillaInstallDir. The port is 14147, the user name/pass is filezilla/filezilla. The local ftp root folder is $tempDir."
write-host "Please wait..."
Start-sleep 8

if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
if (![System.IO.Directory]::Exists($fileZillaInstallDir)) {[System.IO.Directory]::CreateDirectory($fileZillaInstallDir)}

if (![System.IO.File]::Exists("$($fileZillaInstallDir)\FileZilla Server Interface.xml")) {
  Write-Host "Copying FileZilla Server Interface.xml to install directory"
  Copy-Item "$($toolsDir)\FileZilla Server Interface.xml" "$fileZillaInstallDir" -Force
}

if (![System.IO.File]::Exists("$($fileZillaInstallDir)\FileZilla Server.xml")) {
  Write-Host "Copying FileZilla Server.xml to install directory"
  Copy-Item "$($toolsDir)\FileZilla Server.xml" "$fileZillaInstallDir" -Force
}

Install-ChocolateyInstallPackage @packageArgs
Get-ChildItem $toolsPath\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
