import-module au

$releases = 'https://github.com/mysql/mysql-workbench/tags'
$mainlineVersionPrefix = '8.0.'

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

    $versiondata = $download_page.Links.Href | Where-Object { $_ -match '^/mysql/mysql-workbench/releases/tag/(\d+\.\d+\.\d+)$' -and $Matches[1].StartsWith($mainlineVersionPrefix) } | ForEach-Object { Get-Version $_ } | Sort-Object -Property Version -Descending | Select-Object -First 1
    $version = $versiondata.toString()

    $url = 'https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-' + $version + '-winx64.msi'
    $Latest = @{ URL32 = $url; Version = $version }
    return $Latest
}

update -ChecksumFor 32
