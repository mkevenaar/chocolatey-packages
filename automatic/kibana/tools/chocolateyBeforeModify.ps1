$ServiceName="kibana-service"

try {
    write-host "Shutting down Kibana if it is running"
    Start-ChocolateyProcessAsAdmin "cmd /c NET STOP $($ServiceName)"
    Start-ChocolateyProcessAsAdmin "cmd /c sc delete $($ServiceName)"
} catch {
    # no service installed
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unPath = Join-Path $toolsDir 'Uninstall-ChocolateyPath.psm1'
Import-Module $unPath

$version      = "9.1.5"
$binPath = Join-Path $toolsDir "kibana-$($version)-windows-x86_64\bin"
Uninstall-ChocolateyPath $binPath 'Machine'
