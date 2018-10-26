import-module au

$releases = 'https://www.zerotier.com/download.shtml'

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
    $download_page = Invoke-WebRequest -Uri $releases

    $version = $download_page.ParsedHtml.getElementsByTagName('b') | % innerhtml | select -First 1
    
    $url32 = 'https://download.zerotier.com/RELEASES/' + $version + '/dist/ZeroTier%20One.msi'

    $Latest = @{ URL32 = $url32; Version = $version }
    return $Latest
}

update