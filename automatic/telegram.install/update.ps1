Import-Module Chocolatey-AU

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*file\s*=\s*`"[$]toolsPath\\).*"   = "`${1}$($Latest.FileName32)`""
            "(?i)(^\s*file64\s*=\s*`"[$]toolsPath\\).*" = "`${1}$($Latest.FileName64)`""
        }
        ".\legal\VERIFICATION.txt" = @{
            "(?i)(\s+x32:).*"             = "`$1 $($Latest.URL32)"
            "(?i)(checksum32:).*"         = "`$1 $($Latest.Checksum32)"
            "(?i)(\s+x64:).*"             = "`$1 $($Latest.URL64)"
            "(?i)(checksum64:).*"         = "`$1 $($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function Get-TelegramRelease {
    param([switch]$Portable)

    $headers = @{}
    if ($env:github_api_key) {
        $headers.Authorization = "token $env:github_api_key"
    }

    $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/telegramdesktop/tdesktop/releases/latest' -Headers $headers
    if ($release.draft -or $release.prerelease -or $release.tag_name -notmatch '^v?(\d+\.\d+\.\d+)$') {
        throw "Invalid stable Telegram release: '$($release.tag_name)'"
    }
    $version = $Matches[1]

    $prefix = if ($Portable) { 'td-portable-win' } else { 'td-setup-win' }
    $fileType = if ($Portable) { 'zip' } else { 'exe' }
    $asset32 = @($release.assets | Where-Object name -EQ "$prefix-x86-$version.$fileType")
    $asset64 = @($release.assets | Where-Object name -EQ "$prefix-x64-$version.$fileType")
    if ($asset32.Count -ne 1 -or $asset64.Count -ne 1 -or
        !$asset32[0].browser_download_url -or !$asset64[0].browser_download_url) {
        throw "Expected one x86 and one x64 Telegram $fileType asset for $version."
    }

    @{
        Version  = $version
        URL32    = $asset32[0].browser_download_url
        URL64    = $asset64[0].browser_download_url
        FileType = $fileType
    }
}

function global:au_GetLatest { Get-TelegramRelease }

if ($MyInvocation.InvocationName -ne '.') {
    Update-Package -ChecksumFor none
}
