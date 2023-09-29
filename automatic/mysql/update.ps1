import-module au

$releases = 'https://github.com/mysql/mysql-server/tags'
$mainlineVersionPrefix = '8.0.'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases

    $versiondata = $download_page.Links.Href | Where-Object { $_ -match '^/mysql/mysql-server/releases/tag/mysql-(\d+\.\d+\.\d+)$' -and $Matches[1].StartsWith($mainlineVersionPrefix) } | ForEach-Object { Get-Version $_ } | Sort-Object -Property Version -Descending | Select-Object -First 1
    $version = $versiondata.toString()

    $url = 'https://cdn.mysql.com/Downloads/MySQL-' + $versiondata.toString(2) + '/mysql-' + $version + '-winx64.zip'
    $Latest = @{ URL64 = $url; Version = $version }
    return $Latest
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 64
}

function global:au_AfterUpdate ($Package) {

    if ($Package.RemoteVersion -ne $Package.NuspecVersion) {
  
        Get-RemoteFiles -NoSuffix
  
        $file = [IO.Path]::Combine("tools", $Latest.FileName32)
  
        Write-Output "Submitting file $file to VirusTotal"
  
        # Assumes vt-cli Chocolatey package is installed!
        vt.exe scan file $file --apikey $env:VT_APIKEY
  
        Remove-Item $file -ErrorAction Ignore
  
        $Latest.Remove("FileName32")
    }
  }