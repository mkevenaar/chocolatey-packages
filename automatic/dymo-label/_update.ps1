Import-Module Chocolatey-AU

$releases = 'https://www.dymo.com/on/demandware.store/Sites-dymo-Site/en_US/Support-Compatibility-Chart'

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
    Invoke-WebRequest -uri http://www.dymo.com -SessionVariable dl -method post

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -WebSession $dl

    $re = "DL.+Setup.+.exe"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $version = ([regex]::Match($url,'DL.+Setup(.+).exe')).Captures.Groups[1].value

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

Update-Package -ChecksumFor 32
