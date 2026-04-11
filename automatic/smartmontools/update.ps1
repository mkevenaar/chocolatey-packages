Import-Module Chocolatey-AU

$releases = 'https://sourceforge.net/projects/smartmontools/rss?path=/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $feed = ([xml]$download_page.Content).rss.channel

    $release = $feed.item | Where-Object link -match "smartmontools-[0-9]+(?:\.[0-9]+)+(?:-[0-9]+)?\.win32-setup\.exe/download$" | Select-Object -First 1

    $url = $release.link

    $versionMatch = [regex]::Match($url, "smartmontools-(?<Version>[0-9]+(?:\.[0-9]+)+)(?:-[0-9]+)?\.win32-setup\.exe/download$")
    if (-not $versionMatch.Success) {
        throw "Unable to parse version from $url"
    }

    $version = Get-Version $versionMatch.Groups['Version'].Value

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
