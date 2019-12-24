import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $ED=[Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))

    $majorversionsurl = 'https://support.freedomscientific.com/Downloads/OfflineInstallers/GetVersionsWithOfflineInstallers?product=JAWS&_=' + $ED
    $majorversionsjson = Invoke-WebRequest $majorversionsurl | ConvertFrom-Json
    $majorversion = ($majorversionsjson | Select-Object -First 1).MajorVersion
    $verisonsurl = 'https://support.freedomscientific.com/Downloads/OfflineInstallers/GetInstallers?product=JAWS&version='+$majorversion+'&language=mul&releaseType=Offline&_=' + $ED
    $verisonsjson = Invoke-WebRequest $verisonsurl | ConvertFrom-Json

    $url32 = ($verisonsjson | Where-Object InstallerPlatform -Match "32" | Sort-Object -Property FileName -Descending | Select-Object -First 1 ).InstallerLocationHTTP
    $url64 = ($verisonsjson | Where-Object InstallerPlatform -Match "64" | Sort-Object -Property FileName -Descending | Select-Object -First 1 ).InstallerLocationHTTP

    $version = ($verisonsjson | Where-Object InstallerPlatform -Match "64" | Sort-Object -Property FileName -Descending | Select-Object -First 1 ).FileName
    $version = (Get-Version $version).Version

    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }

    return $Latest
}

update
