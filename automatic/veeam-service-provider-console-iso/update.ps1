Import-Module Chocolatey-AU

$releases = 'https://www.veeam.com/download-version.html'
$releaseNotesFeed = 'https://www.veeam.com/services/veeam/technical-documents?resourceType=resourcetype:techdoc/releasenotes&productId=49'
$buildHistory = 'https://www.veeam.com/kb4464'
$productName = 'Veeam Service Provider Console'
$userAgent = 'Chocolatey-AU/1.0 (+https://chocolatey.org)'

$headers = @{
  "User-Agent" = $userAgent
}

$options =
@{
  Headers = $headers
}
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

function Invoke-VeeamWebRequest {
  param(
    [string] $Uri
  )

  $invokeWebRequest = Get-Command Invoke-WebRequest
  $params = @{
    Uri              = $Uri
    DisableKeepAlive = $true
    UserAgent        = $userAgent
  }

  if ($invokeWebRequest.Parameters.ContainsKey('UseBasicParsing')) {
    $params.UseBasicParsing = $true
  }

  if ($invokeWebRequest.Parameters.ContainsKey('AllowInsecureRedirect')) {
    $params.AllowInsecureRedirect = $true
  }

  return Invoke-WebRequest @params
}

function Get-HtmlText {
  param(
    [string] $Html
  )

  $text = $Html -replace '<[^>]+>', ' '
  $text = [System.Net.WebUtility]::HtmlDecode($text)
  return ($text -replace '\s+', ' ').Trim()
}

function Get-AbsoluteVeeamUrl {
  param(
    [string] $Url
  )

  if ($Url -match '^https?://') {
    return $Url
  }

  if ($Url -notmatch '^/') {
    $Url = "/$Url"
  }

  return "https://www.veeam.com$Url"
}

function Get-VeeamKbUrl {
  param(
    [string] $Html
  )

  $pattern = "<a\s+[^>]*href\s*=\s*['`"](?<href>[^'`"]*/kb\d+[^'`"]*)['`"]"
  $match = [regex]::Match($Html, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

  if ($match.Success) {
    return Get-AbsoluteVeeamUrl $match.Groups['href'].Value
  }
}

function Get-VeeamDownloadVersion {
  $downloadPage = Invoke-VeeamWebRequest $releases
  $sections = [regex]::Matches($downloadPage.Content, '<tbody[\s\S]*?</tbody>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
  $productSection = $null

  foreach ($section in $sections) {
    if ((Get-HtmlText $section.Value) -match [regex]::Escape($productName)) {
      $productSection = $section.Value
      break
    }
  }

  if (-not $productSection) {
    throw "Unable to find $productName in $releases."
  }

  $versionMatch = [regex]::Match((Get-HtmlText $productSection), 'Version\s*:?\s+(?<version>[0-9]+\.[0-9]+\.[0-9]+(?:\.[0-9]+)(?:\.[0-9]+)?)')

  if (-not $versionMatch.Success) {
    throw "Unable to find the $productName version in $releases."
  }

  return $versionMatch.Groups['version'].Value
}

function Get-VeeamReleaseHistoryUrl {
  param(
    [string] $Version,
    [string] $MajorVersion
  )

  $buildHistoryPage = Invoke-VeeamWebRequest $buildHistory
  $rows = [regex]::Matches($buildHistoryPage.Content, '<tr[\s\S]*?</tr>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
  $majorRows = @()
  $versionRow = $null
  $isMajorSection = $false

  foreach ($row in $rows) {
    $rowHtml = $row.Value
    $rowText = Get-HtmlText $rowHtml

    if ($rowText -match 'Veeam Service Provider Console\s+([0-9]+)\s+Releases') {
      $isMajorSection = $Matches[1] -eq $MajorVersion
      continue
    }

    if ($isMajorSection) {
      $majorRows += $rowHtml

      if ($rowText -match [regex]::Escape($Version)) {
        $versionRow = $rowHtml
      }
    }
  }

  if (-not $majorRows) {
    throw "Unable to find Veeam Service Provider Console $MajorVersion release rows in $buildHistory."
  }

  $releaseHistoryUrl = if ($versionRow) { Get-VeeamKbUrl $versionRow }

  if (-not $releaseHistoryUrl) {
    foreach ($row in $majorRows) {
      $releaseHistoryUrl = Get-VeeamKbUrl $row

      if ($releaseHistoryUrl) {
        break
      }
    }
  }

  if (-not $releaseHistoryUrl) {
    throw "Unable to find a release-history KB article for Veeam Service Provider Console $MajorVersion in $buildHistory."
  }

  return $releaseHistoryUrl
}

function Get-VeeamIsoFilename {
  param(
    [string] $Version,
    [string] $MajorVersion
  )

  $releaseHistoryUrl = Get-VeeamReleaseHistoryUrl -Version $Version -MajorVersion $MajorVersion
  $releaseHistoryPage = Invoke-VeeamWebRequest $releaseHistoryUrl
  $isoPattern = "VeeamServiceProviderConsole_$([regex]::Escape($Version))(?:_[0-9]{8})?\.iso"
  $isoMatch = [regex]::Match($releaseHistoryPage.Content, $isoPattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

  if (-not $isoMatch.Success) {
    throw "Unable to find an ISO filename for Veeam Service Provider Console $Version in $releaseHistoryUrl."
  }

  return $isoMatch.Value
}

function global:au_GetLatest {
    $CurrentProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    $releaseVersion = Get-VeeamDownloadVersion

    $version = Get-Version ($releaseVersion)
    $majversion = $version.ToString(1)

    $filename = Get-VeeamIsoFilename -Version $releaseVersion -MajorVersion $majversion
    $url = "https://download2.veeam.com/VSPC/v$($majversion)/$($filename)"

    $releaseNotesPage = (Invoke-VeeamWebRequest $releaseNotesFeed).Content | ConvertFrom-Json

    $ReleaseNotes = $releaseNotesPage.payload.products[0].documentGroups[0].documents[0].links.pdf
    if (-not $ReleaseNotes) {
      $ReleaseNotes = $releaseNotesPage.payload.products[0].documentGroups[0].documents[0].links.html
    }

    $ProgressPreference = $CurrentProgressPreference

    return @{
        Filename = $filename
        URL32 = $url
        Version = $version
        ReleaseNotes = $ReleaseNotes
        Options  = $options
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
