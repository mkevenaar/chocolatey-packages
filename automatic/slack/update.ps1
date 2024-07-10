Import-Module Chocolatey-AU

$releases = 'https://slack.com/intl/en-nl/downloads/windows'

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
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $url64 = Get-RedirectedUrl 'https://slack.com/ssb/download-win64-msi'

    $re = "Version (.+\d)</span>"

    $version = ([regex]::Match($download_page.RawContent, $re)).Captures.Groups[1].value

    return @{
        URL64 = $url64
        Version = $version
    }
}

update -ChecksumFor 64
