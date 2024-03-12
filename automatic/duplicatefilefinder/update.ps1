Import-Module Chocolatey-AU

$releases = 'https://www.auslogics.com/en/software/duplicate-file-finder/after-download/'
$versions = 'http://www.auslogics.com/en/software/duplicate-file-finder/'

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
    $version_page  = Invoke-WebRequest -Uri $versions -UseBasicParsing

    $re = 'Latest ver. (.+) \('
    $version = ([regex]::Match($version_page.content,$re)).Captures.Groups[1].value

    $url = $download_page.Links | Where-Object href -match "setup.exe" | Select-Object -First 1 -expand href

    return @{
        URL32 = $url
        Version = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
