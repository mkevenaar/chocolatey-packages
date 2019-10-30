$ErrorActionPreference = 'Stop';

$version = '7.15.0.10'

$packageArgs = @{
  packageName    = 'iCloud'
  fileType       = 'msi'
  url            = 'http://updates-http.cdn-apple.com/2019/windows/061-24943-20191028-18EC3E3C-F9D2-11E9-9D7B-F55FB62FDC30/iCloudSetup.exe'
  softwareName   = 'iCloud'
  checksum       = 'C619EE5E724026B0CB3BC62A01FFB9130DFA45100970AC235C0B9133EAA8C195'
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
