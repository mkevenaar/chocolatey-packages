Import-Module Chocolatey-AU

$releases = 'https://nginx.org/en/download.html'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix }

function global:au_GetLatest {
    $versionRegEx = 'nginx\-([\d\.]+)\.zip'

    $downloadPage = Invoke-WebRequest $releases -UseBasicParsing
    $matches = [regex]::match($downloadPage.Content, $versionRegEx)
    $version32 = [version]$matches.Groups[1].Value
    $url32 = "https://nginx.org/download/$($matches.Groups[0].Value)"


    return @{
        Url32      = $url32
        Version    = $version32
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
