Import-Module AU

$releases = 'https://github.com/grafana/agent/releases/latest'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $version = (($download_page.Links | Where-Object href -Match "releases/tag" | Select-Object -First 1 -ExpandProperty href) -Split "/" | Select-Object -Last 1) -replace "v"
  $url = "https://github.com/grafana/agent/releases/download/v$version/grafana-agent-installer.exe"

  return @{
    URL32    = $url
    Version  = $version
    FileType = 'zip'
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
