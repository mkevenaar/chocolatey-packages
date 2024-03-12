Import-Module Chocolatey-AU

$releases = 'http://www.almico.com/sfdownload.php'

$headers = @{
  Referer = 'https://www.almico.com/sfdownload.php';
}

$options =
@{
  Headers = $headers
}


function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_BeforeUpdate {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32 -Headers $headers
    $Latest.ChecksumType32 = 'sha256'
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $re = 'speedfan(.+).exe'
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href
    $url = 'https://www.almico.com/inst' + $url

    $version = ($download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand innerHTML) -replace "SpeedFan ", ""


    return @{
        URL32 = $url
        Version = $version
        Options = $options
    }
}

update -ChecksumFor none
