Import-Module Chocolatey-AU

$releases = 'https://sourceforge.net/projects/psi/files/Psi/'
$feed = 'https://sourceforge.net/projects/psi/rss?path=/Psi'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge -FileNameSkip 1 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $feed -UseBasicParsing
    $feed = ([xml]$download_page.Content).rss.channel
    
    $release = $feed.item | Where-Object link -match "win7_x86_64.7z/download$" | Select-Object -First 1

    $url64 = $release.link
    $url32 = $release.link -Replace "_64", ""
    
    $version = $url64 -replace "_", "-" -split "-" | Select-Object -last 1 -skip 3

    return @{ 
        URL32 = $url32
        URL64 = $url64
        Version = $version 
        FileType = '7z'
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
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