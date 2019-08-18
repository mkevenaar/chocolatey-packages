import-module au

$releases = 'https://www.mongodb.com/download-center/community'

function global:au_SearchReplace {
   @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
     }
}

function global:au_GetLatest {
    Add-Type -AssemblyName System.Web

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $re = "(?smi)`"server-data`">(.+?)`<"
    $Results = ([regex]::Match($download_page.content,$re)).Captures.Groups[1].value.Trim()

    $json = [System.Web.HttpUtility]::HtmlDecode($Results) | ConvertFrom-Json

    $latest = $json.community.versions | Where-Object { $_.production_release -eq "True" } | Select-Object -first 1
    $url = ($latest.downloads | Where-Object { $_.target -eq "windows_x86_64-2012plus" }).archive.url

    $version = $latest.version
    $url64   = $url
    return @{ URL64=$url64; Version = $version }
}

update -ChecksumFor 64
