Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/greyhair-atx/superputty/releases/latest'

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1'                = @{
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt"                   = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUrl)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(SHA256SUMS.+)\<.*\>" = "`${1}<$($Latest.ChecksumsUrl)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType64)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
    "$($Latest.PackageName).nuspec"              = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
    }
  }
}

function global:au_BeforeUpdate {
  Get-RemoteFiles -NoSuffix -Purge

  # Cross-check the downloaded file against the checksums published with the release.
  $sums = Invoke-RestMethod -Uri $Latest.ChecksumsUrl
  if ($sums -is [byte[]]) { $sums = [System.Text.Encoding]::UTF8.GetString($sums) }
  $line = $sums -split "`r?`n" | Where-Object -FilterScript { $_ -match "\s\*?$([regex]::Escape($Latest.FileName64))\s*$" } | Select-Object -First 1
  if (-not $line) { throw "No upstream checksum found for $($Latest.FileName64)" }
  $upstream = ($line -split '\s+')[0]
  if ($upstream -ne $Latest.Checksum64) { throw "Checksum mismatch for $($Latest.FileName64): upstream $upstream, downloaded $($Latest.Checksum64)" }
}

function global:au_GetLatest {
  $header = @{}
  if ($env:github_api_key) { $header['Authorization'] = "token $env:github_api_key" }
  $release = Invoke-RestMethod -Uri $releases -Headers $header

  $asset     = $release.assets | Where-Object -Property name -Like 'SuperPuTTY-CE-*-setup-win-x64.exe' | Select-Object -First 1
  $sumsAsset = $release.assets | Where-Object -Property name -Like 'SuperPuTTY-CE-*-SHA256SUMS.txt' | Select-Object -First 1
  if (-not $asset -or -not $sumsAsset) { return 'ignore' }

  $version = Get-Version ($release.tag_name -replace '^sp-', '')

  return @{
    URL64        = $asset.browser_download_url
    ChecksumsUrl = $sumsAsset.browser_download_url
    ReleaseUrl   = $release.html_url
    ReleaseNotes = $release.html_url
    Version      = $version.ToString()
    FileType     = 'exe'
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
