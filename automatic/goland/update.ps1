import-module au

$releases = 'https://www.jetbrains.com/go/download/download-thanks.html'

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
    $ie = New-Object -comobject InternetExplorer.Application
    $ie.Navigate2($releases)
    $ie.Visible = $false
    while($ie.ReadyState -lt 3) {start-sleep -m 100} 

    $url = $ie.Document.body.getElementsByTagName("a") | Where-Object {$_.id -eq "download-link"} | select -First 1 -expand href

    $version = ([regex]::Match($url,'goland-(.+).exe')).Captures.Groups[1].value

    $Latest = @{ URL32 = $url; Version = $version }
    return $Latest
}

update