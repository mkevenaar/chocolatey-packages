
$pp = Get-PackageParameters

$packageName = 'mysql'
$binRoot = if ($pp.installLocation) { $pp.installLocation } else { Get-ToolsLocation }
$installDir = Join-Path $binRoot "$packageName"
$installDirBin = "$($installDir)\current\bin"
Write-Host "Adding `'$installDirBin`' to the path and the current shell path"
Install-ChocolateyPath "$installDirBin"

$serviceName = if ($pp.serviceName) { $pp.serviceName } else { "MySQL" }

# turn off the service
Start-ChocolateyProcessAsAdmin "cmd /c NET STOP $serviceName"

# remove the service itself
write-host "Removing the mysql service"
Start-ChocolateyProcessAsAdmin "cmd /c '$($installDirBin)\mysqld' --remove $serviceName"

# notify user
write-host "You are safe to remove the package from $installDir"