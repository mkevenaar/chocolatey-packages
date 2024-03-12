Import-Module Chocolatey-AU

$releases = 'https://sourceforge.net/projects/psi/files/Psi/'
$feed = 'https://sourceforge.net/projects/psi/rss?path=/Psi'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge -FileNameSkip 1 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $feed -UseBasicParsing
    $feed = ([xml]$download_page.Content).rss.channel
    
    $release = $feed.item | Where-Object link -match "win64-setup.exe/download$" | Select-Object -First 1

    $url = $release.link
    
    $version = $url -split "-" | Select-Object -last 1 -skip 2

    return @{ 
        URL32 = $url
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