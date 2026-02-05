$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$package = Split-Path $toolsDir
$codeql_home = Join-Path $package 'codeql-win64/codeql'
$codeql_bat = Join-Path $codeql_home 'codeql.exe'

$url = 'https://github.com/github/codeql-cli-binaries/releases/download/v2.24.1/codeql-win64.zip'
$checksum = '7608f6c07b077ab142f9768f2b089700129d5871398eef64b7965c99d5d725bd'
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
