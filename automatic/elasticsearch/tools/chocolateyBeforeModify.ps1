﻿elasticsearch-service.bat stop
elasticsearch-service.bat remove

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unPath = Join-Path $toolsDir 'Uninstall-ChocolateyPath.psm1'
Import-Module $unPath

$version      = "8.18.3"
$binPath = Join-Path $toolsDir "elasticsearch-$($version)\bin"
Uninstall-ChocolateyPath $binPath 'Machine'
