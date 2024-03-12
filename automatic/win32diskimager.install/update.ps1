Import-Module Chocolatey-AU

$releases = 'https://sourceforge.net/projects/win32diskimager/files/Archive/'

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

    $re = 'install\.exe\/download$'
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href | ForEach-Object { $_ -replace "^(ht|f)tp\:", '$1tps:' -replace "/download", ""}

    $version = $url -split "-" | Select-Object -last 1 -skip 1

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
