Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/Zettlr/Zettlr/releases/latest'

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
    }
    ".\legal\VERIFICATION.txt"    = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $download_page = Invoke-RestMethod -Uri $releases -Headers $header

  #Zettlr-win32-x64-1.2.3.exe
  $asset = $download_page.assets | Where-Object -Property name -Like "*-x64.exe"

  $version = $download_page.tag_name.Replace('v', '')
  $version = Get-Version($version)
  if ($asset) {
    $url = $asset.browser_download_url
    return @{
      URL32    = $url
      Version  = $version
      FileType = 'exe'
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
