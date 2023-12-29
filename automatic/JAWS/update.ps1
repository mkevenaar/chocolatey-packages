import-module au

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
    $header = @{
      "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
    }

    $ED=[Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))

    $majorversionsurl = 'https://support.freedomscientific.com/Downloads/OfflineInstallers/GetVersionsWithOfflineInstallers?product=JAWS&_=' + $ED
    $majorversionsjson = Invoke-WebRequest $majorversionsurl -Headers $header | ConvertFrom-Json
    $majorversion = ($majorversionsjson | Select-Object -First 1).MajorVersion
    $verisonsurl = 'https://support.freedomscientific.com/Downloads/OfflineInstallers/GetInstallers?product=JAWS&version='+$majorversion+'&language=mul&releaseType=Offline&_=' + $ED
    $verisonsjson = Invoke-WebRequest $verisonsurl -Headers $header | ConvertFrom-Json

    $url64 = ($verisonsjson | Where-Object InstallerPlatform -Match "64" | Sort-Object -Property FileName -Descending | Select-Object -First 1 ).InstallerLocationHTTP

    $version = ($verisonsjson | Where-Object InstallerPlatform -Match "64" | Sort-Object -Property FileName -Descending | Select-Object -First 1 ).FileName
    $version = (Get-Version $version).Version

    $Latest = @{ URL64 = $url64; Version = $version }

    return $Latest
}

update -ChecksumFor 64
