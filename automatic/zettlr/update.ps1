Import-Module au

$releases = 'https://github.com/Zettlr/Zettlr/releases/latest'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    #Zettlr-win32-x64-1.2.3.exe
    $re  = "Zettlr-(.+\d)-x64.exe"
    $url = $download_page.links | Where-Object href -match $re | Where-Object href -NotMatch "arm" | Select-Object -First 1 -expand href

    $version = ([regex]::Match($url,$re)).Captures.Groups[1].value
    $url = 'https://github.com' + $url

    return @{
        URL32 = $url
        Version = $version
        FileType = 'exe'
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
