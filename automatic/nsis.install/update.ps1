import-module au

$releases = 'https://nsis.sourceforge.io/Download'

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
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

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = 'setup\.exe\?download$'
    $url = $download_page.Links | Where-Object href -match $re | Select-Object -First 1 -expand href | ForEach-Object { $_ -replace "^(ht|f)tp\:", '$1tps:' -replace "\?download", ""}
    $url = Get-RedirectedUrl $url

    $version = $url -split "-" | Select-Object -last 1 -skip 1

    return @{ 
        URL32 = $url
        Version = $version 
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}
