Import-Module Chocolatey-AU

$releases = 'https://www.veeam.com/download-version.html'
$releaseNotesFeed = 'https://www.veeam.com/services/veeam/technical-documents?resourceType=resourcetype:techdoc/releasenotes&productId=49'
$productName = 'Veeam Service Provider Console'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]filename\s*=\s*)('.*')"     = "`$1'$($Latest.Filename)'"
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

function global:au_GetLatest {
    $CurrentProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $download_page = Invoke-WebRequest -Uri $releases -DisableKeepAlive
    $table = $download_page.ParsedHtml.getElementsByTagName('tbody') | Where-Object innerhtml -Match $productName | Select-Object -First 1

    $re = "Version\s+:\s+([0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)(?:\.[0-9]+)?)"

    $table.innerHTML -imatch $re
    $version = $Matches[1]

    $isoVersion = $version

    if($version -eq "8.0.0.19236") {
      $isoVersion = "8.0.0.19236_20240426"
      $version = "8.0.0.20240426"
    }

    $version = Get-Version ($version)
    $majversion = $version.ToString(1)

    $filename = "VeeamServiceProviderConsole_$($isoVersion).iso"
    $url = "https://download2.veeam.com/VSPC/v$($majversion)/$($filename)"

    $releaseNotesPage = Invoke-WebRequest $releaseNotesFeed | ConvertFrom-Json

    $ReleaseNotes = $releaseNotesPage.payload.products[0].documentGroups[0].documents[0].links.pdf

    $ProgressPreference = $CurrentProgressPreference

    return @{
        Filename = $filename
        URL32 = $url
        Version = $version
        ReleaseNotes = $ReleaseNotes
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
