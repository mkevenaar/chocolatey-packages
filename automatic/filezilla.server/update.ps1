Import-Module Chocolatey-AU

$releases = 'https://filezilla-project.org/download.php?show_all=1&type=server'

$headers = @{
  "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"
  "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
}

$options =
@{
  Headers = $headers
}

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }


function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UserAgent "Chocolatey" -UseBasicParsing -Headers $headers
    $re = "FileZilla_Server_(.+)_.+\.exe"

    $url = $download_page.Links | Where-Object href -match $re | Select-Object -first 1 -expand href

    $version = (([regex]::Match($url, $re)).Captures.Groups[1].value).replace('_','.')

    return @{
        URL32 = $url
        Version = $version
        FileType = 'exe'
        Options = $options
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


update -ChecksumFor None
