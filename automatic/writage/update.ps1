Import-Module Chocolatey-AU

$releases = 'http://www.writage.com/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = ".msi"
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href
#    $url = $releases + $url

    $version = ([regex]::Match($url,'[Ww]ritage-(.+).msi')).Captures.Groups[1].value

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

update