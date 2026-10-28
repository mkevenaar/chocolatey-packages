Import-Module Chocolatey-AU

$releases = 'https://www.veeam.com/products/downloads/latest-version.html'
$releaseNotesFeed = 'https://www.veeam.com/services/veeam/technical-documents?resourceType=resourcetype:techdoc/releasenotes&productId=36'
$productName = 'for Microsoft 365'

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
    $download_page = Invoke-WebRequest -Uri $releases -DisableKeepAlive -UseBasicParsing -ErrorAction Stop
    $tables = [regex]::Matches($download_page.Content, '(?is)<tbody\b[^>]*>.*?</tbody>')
    $table = $tables | Where-Object {
        $text = [System.Net.WebUtility]::HtmlDecode(($_.Value -replace '<[^>]+>', ' '))
        ($text -replace '\s+', ' ') -match [regex]::Escape($productName)
    } | Select-Object -First 1

    if (-not $table) {
        throw "Unable to find $productName in $releases."
    }

    $tableText = [System.Net.WebUtility]::HtmlDecode(($table.Value -replace '<[^>]+>', ' '))
    $versionMatch = [regex]::Match($tableText, '(?i)Version\s*:?\s*(?<version>[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)?)')

    if (-not $versionMatch.Success) {
        throw "Unable to find the $productName version in $releases."
    }

    $version = $versionMatch.Groups['version'].Value

    $isoVersion = $version

    $version = Get-Version ($version)
    $majversion = $version.ToString(1)

    $filename = "VeeamBackupMicrosoft365_$($isoVersion).iso"
    $url = "https://download2.veeam.com/VBO/v$($majversion)/$($filename)"

    $releaseNotesPage = (Invoke-WebRequest -Uri $releaseNotesFeed -UseBasicParsing -ErrorAction Stop).Content | ConvertFrom-Json

    $links = $releaseNotesPage.payload.products[0].documentGroups[0].documents[0].links
    $ReleaseNotes = $links.pdf

    if (-not $ReleaseNotes) {
        $ReleaseNotes = $links.html
    }

    if (-not $ReleaseNotes) {
        throw "Unable to find release notes for $productName in $releaseNotesFeed."
    }

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
