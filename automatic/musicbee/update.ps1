Import-Module Chocolatey-AU

$releases = 'https://www.majorgeeks.com/files/details/musicbee.html'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $url = ((Invoke-WebRequest 'https://www.majorgeeks.com/mg/getmirror/musicbee,1.html').Content) -Match 'https://files\d?\.majorgeeks\.com/\S+\.zip'
    $url = $Matches[0]

    $version = $download_page.Content -Match 'MusicBee ([\d.]+)'
    $versiondata = Get-Version($Matches[1])
    $version = $versiondata.toString()

    $Latest = @{ URL32 = $url; Version = $version }
    return $Latest
}

update -ChecksumFor 32
