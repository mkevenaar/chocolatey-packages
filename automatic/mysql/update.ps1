Import-Module Chocolatey-AU

$releases = 'https://dev.mysql.com/downloads/mysql/8.0.html'

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

    $version = ($download_page.ParsedHtml.getElementsByTagName('h1') | Where-Object innerhtml -match "^MySQL Community Server ").innerhtml -replace "^MySQL Community Server "
    $versiondata = Get-Version($version)
    $version = $versiondata.toString()

    $url = 'https://dev.mysql.com/get/Downloads/MySQL-' + $versiondata.toString(2) + '/mysql-' + $version + '-winx64.zip'
    $url = 'https://cdn.mysql.com/archives/mysql-' + $versiondata.toString(2) + '/mysql-' + $version + '-winx64.zip'
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
