Import-Module Chocolatey-AU

$releases = 'https://www.majorgeeks.com/files/details/musicbee.html'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $url = ((Invoke-WebRequest 'https://www.majorgeeks.com/mg/getmirror/musicbee,1.html').Content) -Match 'https://files\d?\.majorgeeks\.com/\S+\.zip'
    $url = $Matches[0]

    $version = $download_page.Content -Match 'MusicBee ([\d.]+)'
    $versionData = Get-Version($Matches[1])
    $version = $versionData.toString()
  return @{
        URL32 = $url
        Version = $version
        FileType = 'zip'
    }
}
function global:au_SearchReplace {
  @{
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
