function Stop-CrystalDiskMark() {
    $processNameFilters = @("DiskMark*")

    foreach ($processName in $processNameFilters)
    {
        Get-Process -Name $processName -ErrorAction SilentlyContinue | Stop-Process -Force
    }
}
