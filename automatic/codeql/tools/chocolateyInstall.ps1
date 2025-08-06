$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$package = Split-Path $toolsDir
$codeql_home = Join-Path $package 'codeql-win64/codeql'
$codeql_bat = Join-Path $codeql_home 'codeql.exe'

$url = 'https://github.com/github/codeql-cli-binaries/releases/download/v2.22.3/codeql-win64.zip'
$checksum = '5f6e5d2735188110ae38e8a873d7fdf2b65783912abd72453a31e6def74f65dc'
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
