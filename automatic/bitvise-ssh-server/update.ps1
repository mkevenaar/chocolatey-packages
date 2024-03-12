Import-Module Chocolatey-AU

$releases = 'https://www.bitvise.com/ssh-server-download'

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

    #https://dl.bitvise.com/BvSshServer-Inst.exe
    $re  = ".+Inst.exe"
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href

    $version = ([regex]::Match($download_page.RawContent,'Current version: ([\d+\.]+)')).Captures.Groups[1].value
    
    return @{ 
        URL32 = $url
        Version = $version 
    }
}

update -ChecksumFor 32
