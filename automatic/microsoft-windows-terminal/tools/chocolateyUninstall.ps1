$PreRelease     = "False"

$AppxPackageName = "Microsoft.WindowsTerminal"

if ($PreRelease -match "True") {
  $AppxPackageName += "Preview"
}

Remove-AppxProvisionedPackage -Online -AllUsers -PackageName $AppxPackageName
