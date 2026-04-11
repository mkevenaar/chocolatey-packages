Import-Module Chocolatey-AU
[string]$ReleasesUrl = 'https://www.intel.com/content/www/us/en/download/19520/intel-memory-and-storage-tool-cli-command-line-interface.html'

$headers = @{
  "Accept"          = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8"
  "Accept-Language" = "en-GB,en;q=0.5"
  "Accept-Encoding" = "gzip, deflate, br, zstd"
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1'   = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }

    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
    }
  }
}

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $ReleasesUrl -UseBasicParsing -Headers $headers

  $downloadMatch = [regex]::Match($downloadPage.Content, 'data-href="(?<Url>https://downloadmirror\.intel\.com/[^"]+/Intel_MAS_CLI_Tool_Win_(?<Version>\d+(?:\.\d+)+)\.zip)"')

  if (-not $downloadMatch.Success) {
    throw "Failed to locate the Intel MAS Windows download details on '$ReleasesUrl'."
  }

  $releaseNotesHref = $downloadPage.Links |
    Where-Object href -Match 'CLI_IMAS_Release_Notes_.+\.pdf$' |
    Select-Object -First 1 -ExpandProperty href

  if (-not $releaseNotesHref) {
    throw "Failed to locate the Intel MAS release notes link on '$ReleasesUrl'."
  }

  $releaseNotes = [uri]::new($downloadPage.BaseResponse.ResponseUri, $releaseNotesHref).AbsoluteUri

  return @{
    URL32        = $downloadMatch.Groups['Url'].Value
    Version      = $downloadMatch.Groups['Version'].Value
    ReleaseNotes = $releaseNotes
  }
}

Update-Package -ChecksumFor 32 -NoCheckUrl
