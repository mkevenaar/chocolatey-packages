Import-Module Chocolatey-AU

$releases = 'https://uvnc.com/downloads/ultravnc.html'

$headers = @{
  Referer = 'https://uvnc.com/'
}

$options =
@{
  Headers = $headers
}

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
  $versionPage = Invoke-WebRequest -Uri $releases -UseBasicParsing -ErrorAction Stop
  $versionMatch = [regex]::Match($versionPage.Content, '(?i)Latest release version:\s*UltraVNC\s+(\d+(?:\.\d+){2,3})\s*<')
  if (!$versionMatch.Success) { throw 'Unable to determine the latest stable UltraVNC version' }
  $version = $versionMatch.Groups[1].Value
  $versionShort = $version -replace '\.', ''

  $releaseLinks = @($versionPage.Links | Where-Object {
    $_.href -match '/downloads/ultravnc/[^/]+\.html$' -and
    [Net.WebUtility]::HtmlDecode(($_.outerHTML -replace '<[^>]+>', '')).Trim() -eq "UltraVNC $version"
  } | Select-Object -ExpandProperty href -Unique)
  if ($releaseLinks.Count -ne 1) { throw "Expected one release page for UltraVNC $version; found $($releaseLinks.Count)" }
  $releaseUrl = [uri]::new([uri]$releases, $releaseLinks[0])
  $releasePage = Invoke-WebRequest -Uri $releaseUrl -UseBasicParsing -ErrorAction Stop

  $urls = @{}
  foreach ($architecture in @('x86', 'x64')) {
    $downloadLinks = @($releasePage.Links | Where-Object {
      $_.href -match "/summary/[^/]+/\d+-ultravnc-${versionShort}-${architecture}-setup\.html$"
    } | Select-Object -ExpandProperty href -Unique)
    if ($downloadLinks.Count -ne 1) { throw "Expected one $architecture installer for UltraVNC $version; found $($downloadLinks.Count)" }

    # jDownloads returns a JavaScript redirect to the actual installer directory.
    $downloadUrl = [uri]::new($releaseUrl, ($downloadLinks[0] -replace '/summary/', '/send/'))
    $downloadPage = Invoke-WebRequest -Uri $downloadUrl -UseBasicParsing -ErrorAction Stop
    $redirect = [regex]::Match($downloadPage.Content, '(?i)document\.location\.href\s*=\s*["''](?<Url>https://(?:www\.)?uvnc\.eu/download/[^"''<>]+)["'']')
    if (!$redirect.Success) { throw "Unable to resolve the UltraVNC $version $architecture installer URL" }
    $url = [Net.WebUtility]::HtmlDecode($redirect.Groups['Url'].Value)
    if ([IO.Path]::GetFileName(([uri]$url).AbsolutePath) -ine "UltraVNC_${versionShort}_${architecture}_Setup.exe") {
      throw "Unexpected installer URL for UltraVNC $version ${architecture}: $url"
    }
    $urls[$architecture] = $url
  }

  # Retain the package's historical version format (for example, 1.2.3.4 -> 1.2340).
  $major, $minor = $version -split '\.', 2
  $packageVersion = '{0}.{1}' -f $major, ($minor.Replace('.', '').PadRight(4, '0'))

  return @{
    URL32 = $urls.x86
    URL64 = $urls.x64
    Version = $packageVersion
    FileType = 'exe'
    Options = $options
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None
}
