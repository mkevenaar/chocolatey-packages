Import-Module Chocolatey-AU

$releases = 'https://mediaarea.net/en/MediaInfo/Download/Windows'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re  = "/mediainfo-gui/.+\.exe"
  $url32 = $downloadPage.links | Where-Object href -match $re | Select-Object -First 1 -expand href

  $version = ([regex]::Match($url32,'/mediainfo-gui/(.+)/')).Captures.Groups[1].value

  $url32 = "https:" + $url32

  return @{
      URL32 = $url32
      Version = $version
      FileType = 'exe'
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
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
