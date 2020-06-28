Import-Module au

$releases = 'https://api.github.com/repos/microsoft/terminal/releases'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header
  forEach ($release in $download_page) {
    if ($release.prerelease) {
      $version = $release.tag_name.Replace('v', '')
      $version += '-beta'
      forEach ($asset in $release.assets) {
        if ($asset.name -like "Microsoft.WindowsTerminal_*") {
          $url = $asset.browser_download_url
        }
      }
      break
    }
    else {
      $version = $release.tag_name.Replace('v', '')
      forEach ($asset in $release.assets) {
        if ($asset.name -like "Microsoft.WindowsTerminal_*") {
          $url = $asset.browser_download_url
        }
      }
      break
    }
  }
  return @{
    URL32 = $url
    Version = $version
    RemoteVersion  = $version
    FileType = 'msixbundle'
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]fileName\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
      "(^[$]version\s*=\s*)`".*`""             = "`${1}`"$($Latest.RemoteVersion)`""
    }
    ".\legal\VERIFICATION.txt" = @{
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
