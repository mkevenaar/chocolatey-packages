Import-Module Chocolatey-AU

$releases = 'https://www.veeam.com/download-version.html'
$releaseNotesFeed = 'https://www.veeam.com/services/veeam/technical-documents?resourceType=resourcetype:techdoc/releasenotes&productId=41'
$productName = 'for Microsoft Windows'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(?i)(^[$]version\s*=\s*)'.*'"        = "`${1}'$($Latest.RemoteVersion)'"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -DisableKeepAlive
    $table = $download_page.ParsedHtml.getElementsByTagName('tbody') | Where-Object innerhtml -Match $productName | Select-Object -First 1

    $re = "Version\s+:\s+([0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)(?:\.[0-9]+)?)"

    $table.innerHTML -imatch $re
    $version = $Matches[1]

    $isoVersion = $version

    $version = Get-Version ($version)
    $majversion = $version.ToString(1)

    $filename = "VeeamAgentWindows_$($isoVersion).zip"
    $url = "https://download5.veeam.com/VAW/v$($majversion)/$($filename)"

    $releaseNotesPage = Invoke-WebRequest $releaseNotesFeed | ConvertFrom-Json

    $ReleaseNotes = $releaseNotesPage.payload.products[0].documentGroups[0].documents[0].links.pdf

    return @{
        Filename = $filename
        URL32 = $url
        Version = $version
        ReleaseNotes = $ReleaseNotes
        RemoteVersion  = $version
    }
}

function global:au_AfterUpdate ($Package)  {

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

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
