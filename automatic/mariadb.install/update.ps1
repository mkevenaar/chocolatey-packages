Import-Module au

$releases = 'https://downloads.mariadb.org/mariadb/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $version_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re  = "^/mariadb/"
    $version_url = $version_page.links | ? href -match $re | select -First 1 -expand href

    $version = ([regex]::Match($version_url,'/mariadb/(.+)/')).Captures.Groups[1].value

    $url32 = "https://downloads.mariadb.org/f/mariadb-" + $version + "/win32-packages/mariadb-" + $version + "-win32.msi"
    $url64 = "https://downloads.mariadb.org/f/mariadb-" + $version + "/winx64-packages/mariadb-" + $version + "-winx64.msi"

    return @{
        URL32 = $url32
        URL64 = $url64
        Version = $version
        FileType = 'msi'
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
