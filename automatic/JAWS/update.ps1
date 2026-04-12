Import-Module Chocolatey-AU
Import-Module BitsTransfer

function Get-BitsJson {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    $tempFile = New-TemporaryFile

    try {
        Start-BitsTransfer -Source $Url -Destination $tempFile.FullName -ErrorAction Stop
        return Get-Content -Path $tempFile.FullName -Raw | ConvertFrom-Json
    }
    finally {
        Remove-Item -Path $tempFile.FullName -Force -ErrorAction SilentlyContinue
    }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    $epochSeconds = [Math]::Floor([decimal](Get-Date (Get-Date).ToUniversalTime() -uformat "%s"))

    $majorVersionsUrl = "https://support.freedomscientific.com/Downloads/OfflineInstallers/GetVersionsWithOfflineInstallers?product=JAWS&_=$epochSeconds"
    $majorVersionsJson = Get-BitsJson -Url $majorVersionsUrl
    $majorVersion = ($majorVersionsJson | Select-Object -First 1).MajorVersion

    $versionsUrl = "https://support.freedomscientific.com/Downloads/OfflineInstallers/GetInstallers?product=JAWS&version=$majorVersion&language=mul&releaseType=Offline&_=$epochSeconds"
    $versionsJson = Get-BitsJson -Url $versionsUrl

    $installer = $versionsJson |
        Where-Object InstallerPlatform -Match '64' |
        Sort-Object -Property FileName -Descending |
        Select-Object -First 1

    $version = (Get-Version $installer.FileName).Version

    return @{
        URL64   = $installer.InstallerLocationHTTP
        Version = $version
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 64
}
