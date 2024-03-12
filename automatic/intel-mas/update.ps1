Import-Module Chocolatey-AU

$releases = 'https://downloadcenter.intel.com/download/30161'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $url = (($download_page.ParsedHtml.getElementsByTagName('button') | Where-Object innerHtml -Match ".zip").attributes | Where-Object name -eq "data-href").nodeValue
    $url = [uri]::EscapeUriString($url) -replace "&#174;", "%C2%AE"

    $version = $download_page.ParsedHtml.getElementsByName('DownloadVersion') | Select-Object -First 1 -ExpandProperty content

    $releaseNotes = $download_page.Links | Where-Object href -Match ".pdf" | Where-Object href -Match "Release" | Select-Object -First 1 -ExpandProperty href

    $Latest = @{ URL32 = $url; Version = $version; ReleaseNotes = $releaseNotes }
    return $Latest
}

update -ChecksumFor 32
