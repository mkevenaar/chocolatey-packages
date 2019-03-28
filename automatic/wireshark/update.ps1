import-module au

$version_page = 'https://www.wireshark.org/#download'
$releases64 = 'https://www.wireshark.org/download/win64/all-versions/'
$releases32 = 'https://www.wireshark.org/download/win32/all-versions/'

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType32\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
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

function global:au_GetLatest {
    $version = GetVersion
    
    $r64  = '[Ww]ire[Ss]hark-win64-[\d\.]+\.exe$'
    $url64 = GetDownloadLink -downloadlinks $releases64 -pattern $r64 -version $version
	
    $r32 = '[Ww]ire[Ss]hark-win32-[\d\.]+\.exe$'   
    $url32 = GetDownloadLink -downloadlinks $releases32 -pattern $r32 -version $version

    return @{ URL32 = $url32; URL64 = $url64; Version = $version }
}

update
