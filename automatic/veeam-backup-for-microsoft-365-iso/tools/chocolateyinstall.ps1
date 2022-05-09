$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VBO/v6/Veeam.Backup365_6.0.0.379_P20220413.iso'
$checksum = 'd017a35ec9322ad078eb3494063ffe6eaf339b189ea7faf60ee1926885e8dc91'
$checksumType = 'sha256'

$filename = 'Veeam.Backup365_6.0.0.379_P20220413.iso'
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
