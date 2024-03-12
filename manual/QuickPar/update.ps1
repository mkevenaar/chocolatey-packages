Import-Module Chocolatey-AU

$releases = 'http://dev.mysql.com/downloads/tools/workbench/'

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
    
    $version = ($download_page.ParsedHtml.getElementsByTagName('h1') | Where-Object innerhtml -match "^MySQL Workbench").innerhtml -replace "^MySQL Workbench "
    $version = $version.Trim()

    $url = 'https://cdn.mysql.com/Downloads/MySQLGUITools/mysql-workbench-community-' + $version + '-winx64.msi'
    $Latest = @{ URL32 = $url; Version = $version }
    return $Latest
}

update