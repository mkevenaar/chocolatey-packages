$InstalledVersion = (Get-ItemProperty -Path $SlackPath -ErrorAction:SilentlyContinue).VersionInfo.ProductVersion
$SlackOutdated = [Version]$($Env:ChocolateyPackageVersion) -gt [Version]$InstalledVersion

# Only Attempt to kill the slack process if the existing version is the same or newer than the package version
if ($SlackOutdated)
{
    Get-Process "slack" -ErrorAction SilentlyContinue | Stop-Process -Force
}

