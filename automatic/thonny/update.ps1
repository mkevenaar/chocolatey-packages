Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/thonny/thonny/releases'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $header = @{}
  if ($env:github_api_key) {
    $header.Authorization = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header
  $release = $download_page | Select-Object -First 1

  $version = $release.tag_name -replace '^v', ''
  if ($version -notmatch '^(?<base>\d+(?:\.\d+){1,3})(?:-?(?<stage>a|b|rc)(?<number>\d+))?$') {
    throw "Unable to determine the Thonny version from release tag '$($release.tag_name)'."
  }

  $assetVersion = [regex]::Escape($Matches.base)
  if ($Matches.stage) {
    # Prerelease assets may add a hyphen absent from the release tag.
    $assetVersion += '-?' + $Matches.stage + $Matches.number
    $stage = @{ a = 'alpha'; b = 'beta'; rc = 'rc' }[$Matches.stage]
    $version = "$($Matches.base)-$stage$($Matches.number)"
  }

  $assets = @($release.assets | Where-Object name -match "^thonny-$assetVersion-x64\.exe$")
  if ($assets.Count -ne 1) {
    throw "Expected one Thonny x64 Windows installer for '$($release.tag_name)', found $($assets.Count)."
  }

  $url = [string]$assets[0].browser_download_url
  $uri = $null
  if (![Uri]::TryCreate($url, [UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -ne 'https') {
    throw "Invalid download URL for Thonny asset '$($assets[0].name)'."
  }

  return @{
    URL64    = $url
    Version  = $version
    FileType = 'exe'
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*)file(?:64)?(\s*=\s*`"[$]toolsDir\\).*" = "`${1}file64`${2}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt"      = @{
      "(?i)(listed on\s*)\<.*\>"   = "`${1}<$releases>"
      "(?i)(?:32|64)-Bit:.+\<.*\>" = "64-Bit: <$($Latest.URL64)>"
      "(?i)(checksum type:).*"     = "`${1} $($Latest.ChecksumType64)"
      "(?i)checksum(?:32|64):.*"   = "checksum64: $($Latest.Checksum64)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
