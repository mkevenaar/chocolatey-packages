# Stop Lidarr service before upgrade/uninstall if running
$service = "Lidarr"
if (Get-Service "$service" -ErrorAction SilentlyContinue) {
  $running = Get-Service $service
  if ($running.Status -eq "Running") {
    Stop-Service $service
  }
}
