Import-Module Chocolatey-AU

$releases = 'https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=18455'

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
    $url = $download_page.Links | Where-Object href -Match ".exe" | Select-Object -First 1 -ExpandProperty data-direct-path
    $url = [uri]::EscapeUriString($url)

    $versionregex = "v([0-9]+.[0-9]+.[0-9]+)"
    $version = ([regex]::Match($url, $versionregex)).Captures.Groups[1].value

    $releaseNotes = $download_page.Links | Where-Object href -Match ".pdf" | Select-Object -First 1 -ExpandProperty href

    $Latest = @{ URL32 = $url; Version = $version; ReleaseNotes = $releaseNotes }
    return $Latest
}

update -ChecksumFor 32
