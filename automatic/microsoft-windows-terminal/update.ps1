Import-Module au

$releases = 'https://github.com/microsoft/terminal/releases'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    #Microsoft.WindowsTerminal_0.2.1831.0_8wekyb3d8bbwe.msixbundle
    $re  = "Microsoft.WindowsTerminal_(.+)_.*.msixbundle"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href

    $version = ([regex]::Match($url,$re)).Captures.Groups[1].value
    $url = 'https://github.com' + $url

    return @{
        URL32 = $url
        Version = $version
        RemoteVersion  = $version
        FileType = 'msixbundle'
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]fileName\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
      "(^[$]version\s*=\s*)`".*`""             = "`${1}`"$($Latest.RemoteVersion)`""
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
