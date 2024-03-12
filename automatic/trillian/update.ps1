Import-Module Chocolatey-AU

$releases = 'https://www.trillian.im/get/windows/msi/'

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

    $url = Get-RedirectedUrl $releases

    $version = ([regex]::Match($url,'-v([\d+\.]+).msi')).Captures.Groups[1].value

    return @{
        URL32 = $url
        Version = $version
    }
}

update -ChecksumFor 32
