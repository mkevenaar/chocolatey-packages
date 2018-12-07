import-module au

$releases = 'https://www.trillian.im/download/'

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

    $url = $download_page.Links.FindById("download_link") | select -First 1 -expand href
    $url = "https://www.trillian.im" + $url
    $url = [System.Net.HttpWebRequest]::Create($url).GetResponse().ResponseUri.AbsoluteUri

    $version = ([regex]::Match($url,'-v([\d+\.]+).exe')).Captures.Groups[1].value
    
    return @{ 
        URL32 = $url
        Version = $version 
    }
}

update -ChecksumFor 32