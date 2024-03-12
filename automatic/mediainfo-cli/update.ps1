Import-Module Chocolatey-AU

$releases = 'https://mediaarea.net/en/MediaInfo/Download/Windows'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re  = "/mediainfo/.+\.zip"
  $urls = $downloadPage.links | Where-Object href -match $re | Select-Object -First 2 -expand href

  $url32 = $urls | Where-Object { $_ -Match "i386" }
  $url64 = $urls | Where-Object { $_ -Match "x64" }

  $version = ([regex]::Match($url32,'/mediainfo/(.+)/')).Captures.Groups[1].value

  $url32 = "https:" + $url32
  $url64 = "https:" + $url64

  return @{
      URL32 = $url32
      URL64 = $url64
      Version = $version
      FileType = 'zip'
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
