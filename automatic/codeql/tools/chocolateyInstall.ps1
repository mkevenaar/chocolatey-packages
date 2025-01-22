$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$package = Split-Path $toolsDir
$codeql_home = Join-Path $package 'codeql-win64/codeql'
$codeql_bat = Join-Path $codeql_home 'codeql.exe'

$url = 'https://github.com/github/codeql-cli-binaries/releases/download/v2.20.2/codeql-win64.zip'
$checksum = 'eaa098d6c30cbf9c2b74815019765fd0bdadc04c5e47406153dc54834181f6fe'
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
