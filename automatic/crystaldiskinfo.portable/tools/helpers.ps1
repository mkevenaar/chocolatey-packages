function Stop-CrystalDiskInfo() {
    $processNameFilters = @("opusdec", "AlertMail*", "DiskInfo*")

    foreach ($processName in $processNameFilters)
    {
        Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force
    }
}
