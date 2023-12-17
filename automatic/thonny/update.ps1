Import-Module au

$releases = 'https://api.github.com/repos/thonny/thonny/releases'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header
  $release = $download_page[0]

  $version = $release.tag_name.Replace('v', '')

  $re = "thonny-$($version).exe"
  $asset = $release.assets | Where-Object -Property name -match $re
  if ($asset) {
    $url = $asset.browser_download_url
  }

  $version = $version -replace "b", "-beta"

  return @{
    URL32    = $url
    Version  = $version
    FileType = 'exe'
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
    }
    ".\legal\VERIFICATION.txt"      = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
