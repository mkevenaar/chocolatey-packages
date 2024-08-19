Import-Module Chocolatey-AU

$releases = 'https://github.com/zerotier/ZeroTierOne/releases/latest'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }
function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $version = ($download_page.Links | Where-Object href -Match "releases/tag" | Select-Object -First 1 -ExpandProperty href) -Split "/" | Select-Object -Last 1

  if ($version -eq '1.6.6-fixed-windows-inf') {
    $version = '1.6.6'
  }

  if ($version -eq '1.14.0.20240819') {
    $version = '1.14.0'
  }

  $version = Get-Version($version)

  $url32 = 'https://download.zerotier.com/RELEASES/' + $version + '/dist/ZeroTierOne.msi'

  return @{
        URL32 = $url32
        Version = $version
        FileType = 'msi'
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
