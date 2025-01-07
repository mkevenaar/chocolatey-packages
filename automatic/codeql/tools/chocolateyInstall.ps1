$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$package = Split-Path $toolsDir
$codeql_home = Join-Path $package 'codeql-win64/codeql'
$codeql_bat = Join-Path $codeql_home 'codeql.exe'

$url = 'https://github.com/github/codeql-cli-binaries/releases/download/v2.20.1/codeql-win64.zip'
$checksum = '0466e572c513149af84b7eb27e31349f1eb049b9a01e8105f3aba1fed616d792'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  Url64          = $url
  Checksum64     = $checksum
  ChecksumType64 = $checksumType
}

Install-ChocolateyZipPackage  @packageArgs

Install-ChocolateyEnvironmentVariable `
  -VariableName 'CODEQL_HOME' `
  -VariableValue $codeql_home `
  -VariableType 'Machine'


Install-BinFile -Name 'codeql' -Path $codeql_bat

Update-SessionEnvironment
