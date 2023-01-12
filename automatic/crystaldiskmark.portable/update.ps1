Import-Module au

$releases = 'https://crystalmark.info/redirect.php?product=CrystalDiskMarkInstaller'
$feed = 'https://osdn.net/projects/crystaldiskmark/releases/rss'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $feed -UseBasicParsing
  $feed = ([xml]$download_page.Content).rss.channel

  $regex = "CrystalDiskMark([_0-9]+[a-z])\.zip"

  $url = ($feed.item[0].files.file | where-object "#text" -Match $regex | Sort-Object url -Descending | Select-Object -First 1).url
  $url = $url -Replace "https://osdn.net/projects/crystaldiskmark/downloads/", "https://osdn.net/frs/redir.php?m=dotsrc&f=crystaldiskmark/" -Replace "/$"

  $url = Get-RedirectedUrl $url

  $version = (([regex]::Match($url,$regex)).Captures.Groups[1].value) -Replace "_", "."
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
