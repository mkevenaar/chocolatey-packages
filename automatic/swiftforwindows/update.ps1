Import-Module Chocolatey-AU

$releases = 'https://github.com/SwiftForWindows/SwiftForWindows/releases'

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    #SwiftForWindows-2.0.exe
    $re  = "SwiftForWindows-.+.exe"
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href

    $version = ([regex]::Match($url,'/SwiftForWindows-(.+).exe')).Captures.Groups[1].value
    $url = 'https://github.com' + $url

    return @{ 
        URL32 = $url
        Version = $version 
    }
}
if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}