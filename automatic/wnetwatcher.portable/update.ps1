Import-Module Chocolatey-AU

$releases = 'http://www.nirsoft.net/utils/wireless_network_watcher.html'

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

    $re = 'Wireless Network Watcher v(.+)'
    $version = ([regex]::Match($download_page.content,$re)).Captures.Groups[1].value
    
    $url = $download_page.Links | Where-Object href -match "wnetwatcher.zip" | Select-Object -First 1 -expand href
    $url = 'http://www.nirsoft.net/utils/' + $url

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
