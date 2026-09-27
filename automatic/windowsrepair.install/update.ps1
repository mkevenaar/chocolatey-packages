Import-Module Chocolatey-AU

$releases = 'https://www.tweaking.com/features/windows-repair-all-in-one/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function Get-WindowsRepairLatest {
    param([switch] $Portable)

    # The site rejects PowerShell's default user agent with HTTP 403.
    $userAgent = 'Mozilla/5.0'
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -UserAgent $userAgent -TimeoutSec 60
    $text = [System.Net.WebUtility]::HtmlDecode(($download_page.Content -replace '<[^>]+>', ' '))
    $versionMatch = [regex]::Match($text, '\b(?<Version>\d+(?:\.\d+){1,3})\s*[-\u2013\u2014]\s*For all versions of Windows\b')

    if (!$versionMatch.Success) {
        throw "Unable to find the Windows Repair version on $releases"
    }

    $fileName = if ($Portable) { 'tweaking.com_windows_repair_aio.zip' } else { 'tweaking.com_windows_repair_aio_setup.exe' }

    return @{
        URL32 = "https://www.tweaking.com/files/setups/$fileName"
        Version = $versionMatch.Groups['Version'].Value
        Options = @{ Headers = @{ 'User-Agent' = $userAgent } }
    }
}

function global:au_GetLatest {
    Get-WindowsRepairLatest
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
