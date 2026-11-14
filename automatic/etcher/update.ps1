Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/balena-io/etcher/releases/latest'

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"          = "`${1}'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`${1}'$($Latest.Checksum32)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`${1}'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
  $header = @{}
  if ($env:github_api_key) {
    $header.Authorization = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header

  $version = $download_page.tag_name.Replace('v', '')
  $version = Get-Version($version)
  $asset = $download_page.assets | Where-Object -Property name -Like "*Setup*.exe"

  if ($asset) {
    $url = $asset.browser_download_url
    return @{
      URL32   = $url
      Version = $version
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor 32
}
