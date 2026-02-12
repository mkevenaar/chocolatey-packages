$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file          = "$toolsDir\FileZilla_Server_1.12.3_win64-setup.exe"
  softwareName   = 'Psi*'
  silentArgs    = "/S"
  validExitCodes = @(0)
}

$programfiles = (${env:ProgramFiles(x86)}, ${env:ProgramFiles} -ne $null)[0]

$ftpRoot = "C:\temp\ftproot"
$packageParameters = Get-PackageParameters

if ( $packageParameters.ftproot ) {
  Write-Host "ftproot Argument Found"
  $ftpRoot = $packageParameters.ftproot
}

$fileZillaInstallDir = Join-Path $programfiles "FileZilla Server"

write-host "Chocolatey is installing FileZilla Server to $fileZillaInstallDir. The port is 14147, the user name/pass is filezilla/filezilla. The local ftp root folder is $ftpRoot."
write-host "Please wait..."
Start-sleep 8

if (![System.IO.Directory]::Exists($ftpRoot)) {[System.IO.Directory]::CreateDirectory($ftpRoot)}
if (![System.IO.Directory]::Exists($fileZillaInstallDir)) {[System.IO.Directory]::CreateDirectory($fileZillaInstallDir)}

if (![System.IO.File]::Exists("$($fileZillaInstallDir)\FileZilla Server Interface.xml")) {
  Write-Host "Copying FileZilla Server Interface.xml to install directory"
  Copy-Item "$($toolsDir)\FileZilla Server Interface.xml" "$fileZillaInstallDir" -Force
}

if (![System.IO.File]::Exists("$($fileZillaInstallDir)\FileZilla Server.xml")) {
  Write-Host "Copying FileZilla Server.xml to install directory"
  Copy-Item "$($toolsDir)\FileZilla Server.xml" "$fileZillaInstallDir" -Force
}

if ( $packageParameters.ftproot ) {
  $filezillaConf = Get-Content "$($fileZillaInstallDir)\FileZilla Server.xml"
  $filezillaConf = $filezillaConf -replace "<Permission Dir=`".+`">", "<Permission Dir=`"$ftpRoot`">"
  Set-Content -Path "$($fileZillaInstallDir)\FileZilla Server.xml" -Value $filezillaConf -Encoding UTF8
}

Install-ChocolateyInstallPackage @packageArgs
Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
