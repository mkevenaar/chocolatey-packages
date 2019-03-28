Import-Module au

$version_page = 'https://www.wireshark.org/#download'
$releases64 = 'https://www.wireshark.org/download/win64/all-versions/'
$releases32 = 'https://www.wireshark.org/download/win32/all-versions/'

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $version = GetVersion
    
    $r64  = '[Ww]ire[Ss]hark-win64-[\d\.]+\.exe$'
    $url64 = GetDownloadLink -downloadlinks $releases64 -pattern $r64 -version $version
	
    $r32 = '[Ww]ire[Ss]hark-win32-[\d\.]+\.exe$'   
    $url32 = GetDownloadLink -downloadlinks $releases32 -pattern $r32 -version $version

    return @{ 
        URL32 = $url32
        URL64 = $url64
        Version = $version 
        FileType = 'exe'
    }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$version_page>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

function GetVersion {
    $version_page = Invoke-WebRequest -Uri $version_page
    $re64  = '(http[s]?|[s]?)(:\/\/)([^\s,]+)\/win64\/[Ww]ire[Ss]hark-win64-[\d\.]+\.exe$'
    $v = $version_page.links | ? href -match $re64 | select -First 1 -expand href
    $v -split '-|.exe' | select -Last 1 -Skip 1
}

function GetDownloadLink([string] $downloadlinks, [string] $pattern, [string] $version) {
    $page = Invoke-WebRequest -Uri $downloadlinks
    $link = $page.links | ? {($_.innerHTML -like '*' + $version + '*') -And ($_.innerHTML -match $pattern)} | Select -first 1 -expand href
    $page.BaseResponse.ResponseUri.ToString() + $link
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
