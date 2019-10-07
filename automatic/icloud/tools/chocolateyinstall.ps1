$ErrorActionPreference = 'Stop';

$version = '7.14.0.29'

$packageArgs = @{
  packageName    = 'iCloud'
  fileType       = 'msi'
  url            = 'http://updates-http.cdn-apple.com/2019/windows/041-75336-20191002-45F92212-E56B-11E9-9B8B-CBB84BDB2D0F/iCloudSetup.exe'
  softwareName   = 'iCloud'
  checksum       = '56220C91F8E3DFE6692ED69393C532BC2BC976DC66D845AE9AC6790F61F31CC1'
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
