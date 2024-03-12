Import-Module Chocolatey-AU

$releases = 'https://www.scarm.info/index.php?page=download'

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

    #SCARMsetup_1_4_0.exe
    $re  = "SCARMsetup_.+.exe"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $version = (([regex]::Match($url,'SCARMsetup_(.+).exe')).Captures.Groups[1].value).replace('_','.')

    if($version -match "1.9.1a") {
      $version = "1.9.1.20220509"
    }

    $url = 'https:' + $url

    return @{
        URL32 = $url
        Version = $version
    }
}

update
