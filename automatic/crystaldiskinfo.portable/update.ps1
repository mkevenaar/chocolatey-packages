Import-Module Chocolatey-AU

$releases = 'https://crystalmark.info/redirect.php?product=CrystalDiskInfoInstaller'
$downloads = 'https://sourceforge.net/projects/crystaldiskinfo/rss?path=/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge -FileNameSkip 1 }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $downloads -UseBasicParsing
    
  $re = "CrystalDiskInfo([_0-9]+(RC\d+)?)\.zip"
  $url = ([xml]$download_page.Content).rss.channel.item | Where-Object link -match $re | Select-Object -First 1 -ExpandProperty link

  $version = (([regex]::Match($url,$re)).Captures.Groups[1].value) -Replace "_", "."
  $version = Get-Version($version)

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
