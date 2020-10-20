import-module au

$releases = 'https://dev.mysql.com/downloads/mysql/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $version = ($download_page.ParsedHtml.getElementsByTagName('h1') | Where-Object innerhtml -match "^MySQL Community Server ").innerhtml -replace "^MySQL Community Server "
    $versiondata = Get-Version($version)
    $version = $versiondata.toString()

    $url = 'https://dev.mysql.com/get/Downloads/MySQL-' + $versiondata.toString(2) + '/mysql-' + $version + '-winx64.zip'
    $Latest = @{ URL32 = $url; Version = $version }
    return $Latest
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 64
}
