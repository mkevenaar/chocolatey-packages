import-module au

$releases = 'https://downloads.mariadb.org/mariadb/'

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $version_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re  = "^/mariadb/"
    $version_url = $version_page.links | ? href -match $re | select -First 1 -expand href

    $version = ([regex]::Match($version_url,'/mariadb/(.+)/')).Captures.Groups[1].value
    
    $url32 = "https://downloads.mariadb.org/f/mariadb-" + $version + "/win32-packages/mariadb-" + $version + "-win32.zip"
    $url64 = "https://downloads.mariadb.org/f/mariadb-" + $version + "/winx64-packages/mariadb-" + $version + "-winx64.zip"
    
    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}
if ($MyInvocation.InvocationName -ne '.') {
    update
}
