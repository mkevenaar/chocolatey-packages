$ErrorActionPreference = 'Stop';

$version = '7.18.0.22'

$packageArgs = @{
  packageName    = 'iCloud'
  fileType       = 'msi'
  url            = 'https://secure-appldnld.apple.com/windows/061-91601-20200323-974a39d0-41fc-4761-b571-318b7d9205ed/iCloudSetup.exe'
  softwareName   = 'iCloud'
  checksum       = '1100052F27C8EBF6EEA57B05682EB4A5A75EFD50D7ED1C943BD0108ACDC5E692'
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
