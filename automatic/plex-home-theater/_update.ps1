Import-Module AU

$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()

$feed_url = 'https://plex.tv/pms/downloads/2.json?_=' + $timestamp

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $json = Invoke-RestMethod -Uri $feed_url

  $version = $json.computer.windows.version
  $version = Get-Version($version)
  $version.prerelease = $null

  $url32 = ($json.computer.windows.releases | Where-Object -Property build -eq windows-x86).url

    return @{
        URL32 = $url32
        Version = $version
    }
}

function global:au_SearchReplace {
  return @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt"    = @{
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
