Import-Module au

$version_page = 'https://www.wireshark.org/download.html'
# $releases64 = 'https://www.wireshark.org/download/win64/all-versions/'
# $releases32 = 'https://www.wireshark.org/download/win32/all-versions/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {

    $version_page = Invoke-WebRequest -Uri $version_page

    # e.g. https://1.eu.dl.wireshark.org/win64/Wireshark-4.2.0-x64.exe
    $re64  = 'https:\/\/[^\s,]+\/win64\/wireshark-(?<version>[\d\.]+)-x64\.exe$'
    $url64 = $version_page.links | Where-Object href -match $re64 | Select-Object -First 1 -expand href
    if ($url64 -notmatch $re64) {
      throw "failed to extract the version from the url $url64"
    }
    $version = $Matches['version']

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
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$($version_page)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
