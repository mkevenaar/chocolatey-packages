Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/kaikramer/keystore-explorer/releases/latest'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header

  $version = $download_page.tag_name.Replace('v', '')
  $version = Get-Version($version)

  $release = $download_page.assets | Where-Object { $_.name.EndsWith('.zip') }
  $url = $release.browser_download_url
  $folder = $release.name.Substring(0, $release.name.Length - 4)

  return @{
    URL32    = $url
    Version  = $version
    Folder   = $folder
    FileType = 'zip'
  }
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^[$]folder\s*=\s).*" 		= "`$1'$($Latest.Folder)'"
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
