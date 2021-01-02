Import-Module au

$releases = 'https://github.com/OmniDB/OmniDB/releases/latest'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    #omnidb-server_2.13.0-windows-amd64.exe
    $re = "omnidb-server_(.+)-windows-amd64.exe"
    $url64 = $download_page.Links | Where-Object href -Match $re | Select-Object -First 1 -ExpandProperty href
    $url64 = 'https://github.com' + $url64
    
    $version = ([regex]::Match($url64,$re)).Captures.Groups[1].value

    return @{ 
        URL64 = $url64
        Version = $version 
        FileType = 'exe'
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType64)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}