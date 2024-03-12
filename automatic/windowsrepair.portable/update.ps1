Import-Module Chocolatey-AU

$releases = 'https://www.tweaking.com/content/page/windows_repair_all_in_one.html'

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

    $re = '<br /><[strong|b]>(.+\d) - For all versions'
    $version = ([regex]::Match($download_page.content,$re)).Captures.Groups[1].value
    $url = "http://www.tweaking.com/files/setups/tweaking.com_windows_repair_aio.zip"


    return @{ 
        URL32 = $url
        Version = $version 
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
