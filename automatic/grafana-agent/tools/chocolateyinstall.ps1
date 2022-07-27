$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters

$toolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$url          = 'https://github.com/grafana/agent/releases/download/v0.26.1/grafana-agent-installer.exe'
$checksum     = 'F39648CBFAD35FF1F90ADF54E9E3822514DA75C58EA4F8392505B3351EC7DEB2'
$checksumType = 'sha256'

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    url            = $url
    silentArgs     = '/S'
    validExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyPackage @packageArgs
