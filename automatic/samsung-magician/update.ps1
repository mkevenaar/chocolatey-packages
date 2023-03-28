Import-Module AU

$releases = 'https://www.samsung.com/semiconductor/minisite/ssd/download/tools/'

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

    $re  = "Samsung_Magician_Installer_Official_(.+).zip"

    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $version = (([regex]::Match($url,$re)).Captures.Groups[1].value)
    $version = (Get-Version $version).ToString()

    return @{
        URL32 = $url
        Version = $version
    }
}

update -ChecksumFor 32
