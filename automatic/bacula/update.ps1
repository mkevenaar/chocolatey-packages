Import-Module Chocolatey-AU

$releases = 'https://www.bacula.org/binary-download-center/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = "Windows (.+\d) 64 bit"
    $url64 = $download_page.Links | Where-Object outerhtml -match $re | Select-Object -First 1 -expand href

    $re = "Windows (.+\d) 32 bit"
    $url32 = $download_page.Links | Where-Object outerhtml -match $re | Select-Object -First 1 -expand href

    $version = ([regex]::Match(($download_page.Links | Where-Object outerhtml -match $re | Select-Object -First 1 -expand outerhtml),$re)).Groups[1].value

    return @{
        URL32 = $url32
        URL64 = $url64
        Version = $version
    }
}

update
