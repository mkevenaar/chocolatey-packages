Import-Module Chocolatey-AU

$releases = 'https://veusz.github.io/download/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = '/veusz-(?<Version>\d+(?:\.\d+){1,3})-(?:windows-x64|x64-windows)-setup\.exe$'
    $url = $download_page.Links | ForEach-Object { $_.href -replace '\s', '' } |
        Where-Object { $_ -match $re } | Select-Object -First 1

    if (!$url) {
        throw "Could not find a Veusz 64-bit Windows installer on $releases."
    }

    $version = [regex]::Match($url, $re).Groups['Version'].Value

    return @{
        URL64 = $url
        Version = $version
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
