import-module au

$releases = 'https://getmusicbee.com/downloads/'

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
    $download_page = Invoke-WebRequest -Uri $releases
    $url = ($download_page.Links | Where-Object href -Match ".zip" | Select-Object -First 1 -ExpandProperty href) -Replace "/file$"

    $version = ($download_page.ParsedHtml.getElementsByTagName('h2') | Where-Object innerhtml -match "^MusicBee ").innerhtml -replace "^MusicBee "
    $versiondata = Get-Version($version)
    $version = $versiondata.toString()

    $Latest = @{ URL32 = $url; Version = $version }
    return $Latest
}

update -ChecksumFor 32
