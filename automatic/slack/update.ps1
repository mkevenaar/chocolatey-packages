Import-Module Chocolatey-AU

$releases = 'https://slack.com/api/desktop.latestRelease?arch=x64&variant=msix'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $release = Invoke-RestMethod -Uri $releases

    if (-not $release.ok) {
        throw "Slack latest release API returned an unsuccessful response."
    }

    return @{
        URL64 = $release.download_url
        Version = $release.version
    }
}

update -ChecksumFor 64
