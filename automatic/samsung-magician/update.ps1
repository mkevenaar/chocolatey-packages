Import-Module Chocolatey-AU

$releases = 'https://semiconductor.samsung.com/consumer-storage/support/tools/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"                         = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')"                    = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')"                = "`$1'$($Latest.ChecksumType32)'"
            "(^\[version\] [$]softwareVersion\s*=\s*)('.*')" = "`$1'$($Latest.RemoteVersion)'"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    # Updated regex to match the URL
    $re = "Samsung_Magician_Installer_Official_(\d+\.\d+\.\d+\.\d+)\.exe"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -ExpandProperty href

    if (-not $url) {
        throw "Failed to find a download URL matching the expected pattern: $re"
    }

    # Extract version from the URL
    $version = ([regex]::Match($url, $re)).Groups[1].Value

    # Return the necessary details
    return @{
        RemoteVersion = $version
        URL32         = $url
        Version       = $version
    }
}

update -ChecksumFor 32