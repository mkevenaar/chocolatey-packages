# HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\
$msiId = '{2774595F-BC2A-4B12-A25B-0C37A37049B0}'
$msiId64 = '{1F9EB3B6-AED7-4AA7-B8F1-8E314B74B2A5}'

$package = 'SQL2014.SMO'

Uninstall-ChocolateyPackage $package 'MSI' -SilentArgs "$msiId /qb" -validExitCodes @(0)
if ([IntPtr]::Size -eq 8) { Uninstall-ChocolateyPackage $package 'MSI' -SilentArgs "$msiId64 /qb" -validExitCodes @(0) }
