$ErrorActionPreference = 'Stop';

$version = '7.21.0.23'

$packageArgs = @{
  packageName    = 'iCloud'
  fileType       = 'msi'
  url            = 'http://updates-http.cdn-apple.com/2020/windows/001-39935-20200911-1A70AA56-F448-11EA-8CC0-99D41950005E/iCloudSetup.exe'
  softwareName   = 'iCloud'
  checksum       = '4CFD20D13CDCE2B5C435F2DDAF4EE4C81D976461846BF3B954E8AF6CBCDEB9F7'
  checksumType   = 'sha256'
  silentArgs     = "/qn /norestart"
  validExitCodes = @(0, 2010, 1603, 1641, 3010)
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
