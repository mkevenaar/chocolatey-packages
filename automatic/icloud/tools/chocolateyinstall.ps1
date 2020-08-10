$ErrorActionPreference = 'Stop';

$version = '7.20.0.17'

$packageArgs = @{
  packageName    = 'iCloud'
  fileType       = 'msi'
  url            = 'http://updates-http.cdn-apple.com/2020/windows/061-97489-20200728-49EF1218-D0FD-11EA-808A-86ABB27EFCA1/iCloudSetup.exe'
  softwareName   = 'iCloud'
  checksum       = 'E9C6DA9E5DBC6EF418FA3085E3B8824A863DB3877585A79F1159956F70D4136D'
  checksumType   = 'sha256'
  silentArgs     = "/qn /norestart"
  validExitCodes = @(0, 2010, 1603, 1641)
  unzipLocation  = Get-PackageCacheLocation
}

$app = Get-UninstallRegistryKey -SoftwareName $packageArgs.softwareName | Select-Object -first 1

if ($app -and ([version]$app.DisplayVersion -ge [version]$version) -and ($env:ChocolateyForce -ne $true)) {
  Write-Host "iCloud $version or higher is already installed."
  Write-Host "No need to download and install again"
  return;
}

Install-ChocolateyZipPackage @packageArgs

$msiFileList = (Get-ChildItem -Path $packageArgs.unzipLocation -Filter '*64.msi' | Where-Object {
  $_.Name -notmatch 'AppleSoftwareUpdate*.msi'
})

foreach ($msiFile in $msiFileList) {
  $packageArgs.packageName = $msiFile.Name
  $packageArgs.file = $msiFile.FullName -replace "64.msi", ".msi"
  $packageArgs.file64 = $msiFile.FullName
  Install-ChocolateyInstallPackage @packageArgs
}

Remove-Item $packageArgs.unzipLocation -Recurse -Force -ea 0
