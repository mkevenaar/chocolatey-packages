$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.wdc.com/wdapp/WDSecurity_WIN.zip'
$checksum = '612c9714e7d204abeabfc3d46c154ff5b801a4c65a682a8eb92268261799ba5d'
$checksumType = 'sha256'
$fileLocation = Join-Path $toolsDir "WDSecuritySetup.exe"

$downloadArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Install-ChocolateyZipPackage @downloadArgs

$installArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'WD Security*'
  file          = $fileLocation
  fileType      = 'exe'
  silentArgs    = "/s"
  validExitCodes= @(0)
  destination   = $toolsDir
}

Install-ChocolateyInstallPackage @installArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
