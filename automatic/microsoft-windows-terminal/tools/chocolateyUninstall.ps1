$PreRelease     = "True"

$AppxPackageName = "Microsoft.WindowsTerminal"

if ($PreRelease -match "True") {
  $AppxPackageName += "Preview"
}

Remove-AppxPackage -AllUsers -Package (Get-AppxPackage -Name $AppxPackageName -AllUsers -PackageTypeFilter Bundle)
