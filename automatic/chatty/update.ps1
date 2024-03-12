Import-Module Chocolatey-AU

$releases = 'https://api.github.com/repos/chatty/chatty/releases'

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

function CreateStream {
  param($url32bit, $version)

  $Result = @{
    Version  = $version
    URL32    = $url32bit
    FileType = 'zip'
  }

  return $Result
}

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }
  $json = Invoke-RestMethod -Uri $releases -Headers $header

  $streams = @{ }

  foreach ($release in $json) {
    $version = $release.tag_name.Replace('v', '')
    $version = Get-Version($version)

    $asset = $release.assets | Where-Object -Property name -Like "*_win_standalone.zip"

    $streamVersion = $version.toString(2)
    if ($release.prerelease) {
      $streamVersion += '-rc'
    }
    if ($asset) {
      $url = $asset.browser_download_url
      if (!$streams.ContainsKey("$streamVersion")) {
        $streams.Add($streamVersion, (CreateStream $url $version))
      }
    }
  }
  return  @{ Streams = $streams }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
