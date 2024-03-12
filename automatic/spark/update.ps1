Import-Module Chocolatey-AU

$releases = 'https://www.igniterealtime.org/downloads/index.jsp'

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

    $re = 'spark(.+).exe'
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href | Foreach-Object { $_ -replace "/downloads/download-landing.jsp\?file=", "/downloadServlet?filename=" }
    $url = 'https://www.igniterealtime.org' + $url 
    
    $versionre = "<h2>Spark (.+\d)</h2>"
    $version = ([regex]::Match($download_page.content,$versionre)).Captures.Groups[1].value
    

    return @{ 
        URL32 = $url
        Version = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
