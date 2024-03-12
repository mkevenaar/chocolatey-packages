Import-Module Chocolatey-AU

$releases = 'http://x3270.bgp.nu/download.html'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    #http://x3270.bgp.nu/download/03.06/wc3270-3.6ga8-setup.exe
    $re  = "wc3270-(.+)-noinstall-64.zip$"
    $url64 = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href
    $url32 = $url64 -Replace "-64", "-32"

    $version = ([regex]::Match($url64,$re)).Captures.Groups[1].value
    $version = $version -Replace "ga", "."

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
