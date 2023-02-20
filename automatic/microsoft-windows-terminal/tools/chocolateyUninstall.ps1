$PreRelease     = "True"

$AppxPackageName = "Microsoft.WindowsTerminal"

if ($PreRelease -match "True") {
  $AppxPackageName += "Preview"
}

Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $AppxPackageName
