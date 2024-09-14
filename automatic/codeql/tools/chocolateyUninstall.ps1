$tools = Split-Path $MyInvocation.MyCommand.Definition
$package = Split-Path $tools
$codeql_home = Join-Path $package 'codeql-win64/codeql'
$codeql_bat = Join-Path $codeql_home 'codeql.exe'

Uninstall-BinFile -Name 'codeql' -Path $codeql_home

Uninstall-ChocolateyEnvironmentVariable -VariableName 'CODEQL_HOME'
