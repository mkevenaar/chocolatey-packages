Import-Module Chocolatey-AU

$releases = 'https://www.bacula.org/binary-download-center/'

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

    $re = "Windows (.+\d) 64 bit"
    $url64 = $download_page.Links | Where-Object outerhtml -match $re | Select-Object -First 1 -expand href

    $version = ([regex]::Match(($download_page.Links | Where-Object outerhtml -match $re | Select-Object -First 1 -expand outerhtml),$re)).Groups[1].value

    return @{
        URL64 = $url64
        Version = $version
    }
}

update -ChecksumFor 64
