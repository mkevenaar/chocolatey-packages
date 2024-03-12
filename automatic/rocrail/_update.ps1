Import-Module Chocolatey-AU

$releases = 'https://wiki.rocrail.net/rocrail-snapshot/'

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

    #rocrail-14507-win32.exe
    $re32  = "rocrail-.+-win32.exe"
    $re64  = "rocrail-.+-win64.exe"
    $uri32 = $download_page.links | Where-Object href -match $re32 | Select-Object -First 1 -expand href
    $uri64 = $download_page.links | Where-Object href -match $re64 | Select-Object -First 1 -expand href

    $filename32 = $uri32.Substring($uri32.LastIndexOf("/") + 1)
    $filename64 = $uri64.Substring($uri64.LastIndexOf("/") + 1)
    $version = $filename64 -split '-' | Select-Object -Last 1 -Skip 1
    $version = '1.' + $version
    $url32 = 'https://wiki.rocrail.net/rocrail-snapshot/history/' + $filename32
    $url64 = 'https://wiki.rocrail.net/rocrail-snapshot/history/' + $filename64

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
