import-module au

$releases = 'https://github.com/mongodb/mongo/releases'

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
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $version = (($download_page.Links | Where-Object href -Match "releases/tag" | Where-Object href -NotMatch "rc" | Select-Object -First 1 -ExpandProperty href) -Split "/" | Select-Object -Last 1) -replace "^r"

  $url = 'https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-' + $version + '.zip'

  $url64   = $url
  return @{ URL64=$url64; Version = $version }
}

update -ChecksumFor 64
