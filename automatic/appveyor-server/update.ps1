Import-Module Chocolatey-AU

$releases = 'https://www.appveyor.com/releases/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases
  $re = "/releases/(.+\d)/"

  $version = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand innerhtml
  $versiondata = Get-Version($version)
  $version = $versiondata.toString()

  #$url32 = "https://www.appveyor.com/downloads/appveyor-server/" + $versiondata.toString(2) + "/windows/appveyor-server-" + $version + "-x64.msi"
  $url32 = "https://www.appveyor.com/downloads/appveyor/appveyor-server.msi"
  
  return @{
        URL32 = $url32
        Version = $version 
        FileType = 'msi'
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
