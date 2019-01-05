import-module au

$releases = 'https://blog.bacula.org/binary-download-center/'

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
    $download_page = Invoke-WebRequest -Uri $releases

    $re = "Windows (.+\d) (64|32) bit"
    $url = $download_page.Links | Where-Object innerhtml -match $re | Select-Object -First 2 -expand href

    $version = ([regex]::Match(($download_page.Links | Where-Object innerhtml -match $re | Select-Object -First 1 -expand innerhtml),$re)).Groups[1].value

    return @{ 
        URL32 = $url[1]
        URL64 = $url[0]
        Version = $version 
    }
}

update