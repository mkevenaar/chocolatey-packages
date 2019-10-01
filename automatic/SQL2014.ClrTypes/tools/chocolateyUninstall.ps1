# HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\
$msiId = '{71BBE068-233F-403C-88B8-C2FDE753F6B0}'
$msiId64 = '{E3F613C1-105F-4717-BFE7-007729A95D67}'

$package = 'SQL2014.ClrTypes'

if ([IntPtr]::Size -eq 8) { Uninstall-ChocolateyPackage $package 'MSI' -SilentArgs "$msiId64 /qb" -validExitCodes @(0) }
else { Uninstall-ChocolateyPackage $package 'MSI' -SilentArgs "$msiId /qb" -validExitCodes @(0) }
