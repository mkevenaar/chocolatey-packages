import-module au

$releases = 'http://owl.phy.queensu.ca/~phil/exiftool/'

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

    $re = "exiftool-(.+).zip"
    $url = $releases + ($download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href)

    $version = $url -split "-" | Select-Object -last 1 | ForEach-Object { $_ -replace ".zip", "" }

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
