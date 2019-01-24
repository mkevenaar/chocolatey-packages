Import-Module AU

$releases = 'http://www.uvnc.com/downloads/ultravnc.html'

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $version_page = Invoke-WebRequest -Uri $releases

    $re = 'ultravnc\s+([\d.]+)'
    $version_url = $version_page.links | ? innerHTML -match $re | select -First 1 -expand href
    $version = ([regex]::Match(($version_page.Links | Where-Object innerhtml -match $re | Select-Object -First 1 -expand innerhtml),$re)).Groups[1].value
    $version_short = $version -replace '\.',''

    $url32 = "https://www.uvnc.eu/download/" + $version_short + "/UltraVNC_" + ($version -replace '(\d).(\d).(\d).(\d)','$1_$2_$3$4') + "_X86_Setup.exe"
    $url64 = $url32 -Replace "X86","X64"
    
    $version = ($version -replace '(\d).(\d).(\d).(\d)','$1.$2$3$4') + '0'
    
    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

if ($MyInvocation.InvocationName -ne '.') {
    update
}

