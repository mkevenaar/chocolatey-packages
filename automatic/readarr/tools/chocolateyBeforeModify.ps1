# Stop Readarr service before upgrade/uninstall if running
$service = "Readarr"
if (Get-Service "$service" -ErrorAction SilentlyContinue) {
  $running = Get-Service $service
  if ($running.Status -eq "Running") {
    Stop-Service $service
  }
}
