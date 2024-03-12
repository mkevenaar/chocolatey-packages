Import-Module Chocolatey-AU

$releases = 'https://exiftool.org/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge -FileNameSkip 1 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = "exiftool-(.+).zip"
    $url = $releases + ($download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href)

    $version = $url -split "-" | Select-Object -last 1 | ForEach-Object { $_ -replace ".zip", "" }

    return @{
        URL32 = $url
        Version = $version
	FileType = 'zip'
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
