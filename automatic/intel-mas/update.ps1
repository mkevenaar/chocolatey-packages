import-module au

$releases = 'https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=30058'

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
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $url = $download_page.Links | Where-Object href -Match ".zip" | Select-Object -First 1 -ExpandProperty data-direct-path
    $url = [uri]::EscapeUriString($url) -replace "&#174;", "%C2%AE"

    $versionregex = "<meta name=`"DownloadVersion`" content=`"(.+)`" />"
    $version = ([regex]::Match($download_page.Content, $versionregex)).Captures.Groups[1].value

    $releaseNotes = $download_page.Links | Where-Object href -Match ".pdf" | Where-Object href -Match "Release" | Select-Object -First 1 -ExpandProperty href

    $Latest = @{ URL32 = $url; Version = $version; ReleaseNotes = $releaseNotes }
    return $Latest
}

update -ChecksumFor 32
