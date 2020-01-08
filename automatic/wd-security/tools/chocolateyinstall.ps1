$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.wdc.com/wdapp/WDSecuritySetup_for_web_2.0.0.70.zip'
$checksum = '4e78e1d7063703f19a7c6b0144e7d55caed3f1fc714edb7d400f5951522ba952'
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

Get-ChildItem $toolsPath\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
