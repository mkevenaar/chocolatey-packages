Import-Module Chocolatey-AU

$releases = 'http://www.nirsoft.net/utils/alternate_data_streams.html'

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

    $re = 'AlternateStreamView v(.+) -'
    $version = ([regex]::Match($download_page.content,$re)).Captures.Groups[1].value
    
    $url = $download_page.Links | Where-Object href -match "alternatestreamview(.+)?.zip" | Select-Object -First 2 -expand href
    $url32 = 'http://www.nirsoft.net/utils/' + $url[0]
    $url64 = 'http://www.nirsoft.net/utils/' + $url[1]

    return @{ 
        URL32 = $url32
        URL64 = $url64
        Version = $version 
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update
}
