Import-Module Chocolatey-AU
[string]$ReleasesUrl = ([xml](Get-Content $PSScriptRoot\intel-dsa.nuspec)).package.metadata.releasenotes
[string]$DownloadURL = 'https://dsadata.intel.com/installer/'

function global:au_SearchReplace {
    @{
        "tools\chocolateyinstall.ps1" = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

function global:au_BeforeUpdate {}

function global:au_GetLatest {
    $ReturnHt = @{
        URL32 = $DownloadURL
    }

    $result = Invoke-WebRequest -Uri $ReleasesUrl -UseBasicParsing -Headers @{
        "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8"
        "Accept-Language" = "en-GB,en;q=0.5"
        "Accept-Encoding" = "gzip, deflate, br, zstd"
    }

    if ($result.Content -match '(?im)(?<TableData><table class="icstable".+?</table>)') {
        $LatestVersion = $Matches.TableData -split "</tr>" | Select-Object -Skip 1 | ForEach-Object {
            if ($_ -match '>(?<Version>[\d\.]+)</td>') {
                $Matches.Version
            } else {
                Write-Verbose "Couldn't find a version in '$_'"
            }
        } | Sort-Object {[version]$_} -Descending | Select-Object -First 1
    } else {
        Write-Verbose "Couldn't find the ICSTable on '$($ReleasesUrl)', falling back to testing the file..."
    }

    if (-not $LatestVersion) {
        $TempFile = Join-Path $env:TEMP "$(New-Guid).exe"
        try {
            Invoke-WebRequest -Uri $DownloadURL -OutFile $TempFile
            $LatestVersion = (Get-ItemProperty $TempFile).VersionInfo.ProductVersion
            $ReturnHt.Checksum32 = Get-FileHash $TempFile SHA256
        } finally {
            Remove-Item $TempFile
        }
    }

    $ReturnHt.Version = $LatestVersion

    return $ReturnHt
}

Update-Package -ChecksumFor 32 -NoCheckUrl