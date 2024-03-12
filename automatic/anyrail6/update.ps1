Import-Module Chocolatey-AU

$releases = 'https://anyrail.com/en/download'

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

    #AnyRail6.17.4.msi
    $re  = "AnyRail.+.msi"
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href

    $version = ([regex]::Match($url,'AnyRail/.+/AnyRail(.+).msi')).Captures.Groups[1].value
    $url = 'https://www.anyrail.com' + $url

    return @{
        URL32 = $url
        Version = $version
    }
}

update
