Import-Module Chocolatey-AU

$releases = 'https://www.igniterealtime.org/downloads/index.jsp'

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

    $re = 'openfire(.+).exe'
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 2 -expand href | Foreach-Object { $_ -replace "/downloads/download-landing.jsp\?file=", "/downloadServlet?filename=" }
    $url[0] = 'https://www.igniterealtime.org' + $url[0] 
    $url[1] = 'https://www.igniterealtime.org' + $url[1] 
    
    $versionre = "<h2>Openfire (.+\d)</h2>"
    $version = ([regex]::Match($download_page.content,$versionre)).Captures.Groups[1].value
    

    return @{ 
        URL32 = $url[0]
        URL64 = $url[1]
        Version = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update
}
