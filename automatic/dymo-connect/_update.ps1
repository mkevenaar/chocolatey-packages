Import-Module Chocolatey-AU

$releases = 'http://www.dymo.com/en-US/online-support'

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

    $re = "DCDSetup(.+).exe"
    $url = ($download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href)

    $version = ([regex]::Match($url,$re)).Captures.Groups[1].value

    return @{
      URL32 = $url
      Version = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
