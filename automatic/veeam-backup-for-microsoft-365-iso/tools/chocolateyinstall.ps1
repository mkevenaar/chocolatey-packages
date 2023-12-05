$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VBO/v7/VeeamBackupMicrosoft365_7.1.0.1301.iso'
$checksum = '033fbf500d41917b0f155a06a69205ab47c5284ead5a0081699c14f7a2993d18'
$checksumType = 'sha256'

$filename = 'VeeamBackupMicrosoft365_7.1.0.1301.iso'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

#cleanup any old ISO files from previous versions
Get-ChildItem $packagePath\*.iso | Where-Object Name -NotMatch $filename | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $installPath
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

Get-ChocolateyWebFile @packageArgs
