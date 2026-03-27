$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$package = Split-Path $toolsDir
$codeql_home = Join-Path $package 'codeql-win64/codeql'
$codeql_bat = Join-Path $codeql_home 'codeql.exe'

$url = 'https://github.com/github/codeql-cli-binaries/releases/download/v2.25.1/codeql-win64.zip'
$checksum = 'ec3a183ac0ec54d451905a4407235f122a1365e49b7a470a1ae6da66714bc1cf'
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
