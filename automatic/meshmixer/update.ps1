Import-Module Chocolatey-AU

$releases = 'https://meshmixer.com/download.html'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = 'Autodesk_MeshMixer_(.+)_Win64.exe'
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $versionre = "Windows (.+)"
    $version = Get-Version(([regex]::Match($download_page.Content,$versionre)).Captures.Groups[1].value)


    return @{
        URL64 = $url
        Version = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 64
}
