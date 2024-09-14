Import-Module Chocolatey-AU

$releases = 'https://download.sqlitebrowser.org/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    #DB.Browser.for.SQLite-3.11.2-win32.zip
    $re  = "DB.Browser.for.SQLite-(.+)-win32.zip"
    $url32 = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $version = ([regex]::Match($url32,$re)).Captures.Groups[1].value.trim('v')
    $url32 = 'https://download.sqlitebrowser.org' + $url32

    $url64 = $url32 -Replace "win32", "win64"
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