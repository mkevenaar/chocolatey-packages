Import-Module Chocolatey-AU

$releases = 'https://simulide.com/p/downloads/'
$license = 'https://raw.githubusercontent.com/Arcachofo/SimulIDE-dev/master/COPYING'

function global:au_BeforeUpdate {
  # AU retains fields from the previous stream; remove unavailable architectures.
  foreach ($architecture in @('32', '64')) {
    if ($architecture -notin $Latest.Architectures) {
      foreach ($field in @('URL', 'FileName', 'Checksum', 'ChecksumType')) {
        $Latest.Remove("$field$architecture")
      }
    }
  }
  Get-ChildItem -LiteralPath '.\tools' -Filter 'SimulIDE_*.7z' -File | Remove-Item -Force
  Get-RemoteFiles -NoSuffix -Purge
  $licenseText = (Invoke-WebRequest -Uri $license -UseBasicParsing).Content
  $licenseText = $licenseText.TrimEnd([char[]]"`r`n") -replace '\r?\n', "`r`n"
  $licensePath = Join-Path -Path (Get-Location) -ChildPath 'legal\LICENSE.txt'
  [System.IO.File]::WriteAllText($licensePath, ($licenseText + "`r`n"), [System.Text.UTF8Encoding]::new($false))
}

function Get-SimulIDERelease {
  param([string]$FileName)

  $pattern = '^SimulIDE_(?<version>\d+(?:\.\d+){0,2})(?:[-_](?:SR(?<service>\d+)|R(?<revision>\d{6,8})|(?<prerelease>(?:alpha|beta|rc)\d*(?:[.-]\d+)*)))?[_-]Win(?<architecture>32|64)\.zip$'
  if ($FileName -notmatch $pattern) {
    throw "Cannot determine the SimulIDE version from '$FileName'."
  }

  $parts = @($Matches.version -split '\.')
  $major = $parts[0]
  $service = $Matches.service
  $revision = $Matches.revision
  $prerelease = $Matches.prerelease
  $architecture = $Matches.architecture
  while ($parts.Count -lt 3) { $parts += '0' }
  $version = $parts -join '.'

  if ($service) {
    # Stable Release numbers are revisions, not prereleases.
    $version += ".$service"
  } elseif ($revision) {
    # Upstream's R builds are development releases.
    $version += "-r$revision"
  } elseif ($prerelease) {
    $version += "-$($prerelease.ToLowerInvariant())"
  }

  return @{
    Major = $major
    Version = $version
    Architecture = $architecture
  }
}

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $releasePages = @($downloadPage.Links | ForEach-Object {
    $uri = [uri]::new([uri]$releases, $_.href)
    if ($uri.Host -eq ([uri]$releases).Host -and $uri.AbsolutePath -match '^/p/download\d+/?$') {
      $uri.AbsoluteUri
    }
  } | Sort-Object -Unique)
  if (!$releasePages) { throw 'No SimulIDE release pages were found on the official downloads page.' }

  $streams = @{}
  foreach ($releasePage in $releasePages) {
    $page = Invoke-WebRequest -Uri $releasePage -UseBasicParsing
    $unstableHeadings = [regex]::Matches($page.Content, '<h[1-6]\b[^>]*>(.*?)</h[1-6]>', 'IgnoreCase, Singleline') | Where-Object {
      ($_.Groups[1].Value -replace '<[^>]+>', '') -match '\bSimulIDE\b.*\b(?:unstable|development|alpha|beta|release candidate)\b'
    }
    if ($unstableHeadings) { continue }
    $configMatch = [regex]::Match($page.Content, '(?m)^\s*var\s+CFG\s*=\s*(\{.+\});\s*$')
    $appMatch = [regex]::Match($page.Content, '<form\b[^>]*\bdata-app=["''](simulide\d+)["'']', 'IgnoreCase')
    if (!$configMatch.Success -or !$appMatch.Success) {
      throw "The SimulIDE download configuration was not found on '$releasePage'."
    }

    # Read the same JSON map and base URL used by the site's Download button.
    $config = $configMatch.Groups[1].Value | ConvertFrom-Json
    $app = $appMatch.Groups[1].Value
    $windowsFiles = @($config.map.$app.PSObject.Properties | Where-Object { $_.Name -match '^Windows (32|64)$' })
    if (!$config.basePath -or !$windowsFiles) {
      throw "No Windows downloads were found on '$releasePage'."
    }

    $stream = @{ ReleaseNotes = $releasePage; Architectures = @() }
    foreach ($file in $windowsFiles) {
      $release = Get-SimulIDERelease -FileName $file.Value
      if ($stream.Version -and $stream.Version -ne $release.Version) {
        throw "The Windows downloads on '$releasePage' have different versions."
      }
      $stream.Version = $release.Version
      $stream.Architectures += $release.Architecture
      $stream["URL$($release.Architecture)"] = [uri]::new([uri]$config.basePath, $file.Value).AbsoluteUri
    }

    if ($stream.Version -match '-') { continue }
    $major = $release.Major
    if (!$streams.ContainsKey($major) -or (Get-Version $stream.Version) -gt (Get-Version $streams[$major].Version)) {
      $streams[$major] = $stream
    }
  }

  if (!$streams.Count) { throw 'No stable SimulIDE Windows releases were found.' }
  # AU reverses this map to process older releases first; sort majors numerically.
  $orderedStreams = [ordered]@{}
  foreach ($major in ($streams.Keys | Sort-Object { [int]$_ } -Descending)) {
    $orderedStreams[$major] = $streams[$major]
  }
  return @{ Streams = $orderedStreams }
}

function global:au_SearchReplace {
  $file32 = if ($Latest.FileName32) { '"$toolsDir\' + $Latest.FileName32 + '"' } else { "''" }
  $file64 = if ($Latest.FileName64) { '"$toolsDir\' + $Latest.FileName64 + '"' } else { "''" }
  $checksumType = if ($Latest.ChecksumType64) { $Latest.ChecksumType64 } else { $Latest.ChecksumType32 }
  $checksum32 = if ($Latest.Checksum32) { " $($Latest.Checksum32)" } else { '' }
  $checksum64 = if ($Latest.Checksum64) { " $($Latest.Checksum64)" } else { '' }
  return @{
    '.\tools\chocolateyinstall.ps1' = @{
      '(?i)(^\s*FileFullPath\s*=\s*).*' = "`${1}$file32"
      '(?i)(^\s*FileFullPath64\s*=\s*).*' = "`${1}$file64"
    }
    '.\simulide.nuspec' = @{
      '(<releaseNotes>).*?(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
    '.\legal\VERIFICATION.txt' = @{
      '(?i)(listed on\s*)\<.*\>' = "`${1}<$releases>"
      '(?i)(32-Bit.+)\<.*\>' = "`${1}<$($Latest.URL32)>"
      '(?i)(64-Bit.+)\<.*\>' = "`${1}<$($Latest.URL64)>"
      '(?i)(checksum type:).*' = "`${1} $checksumType"
      '(?i)(checksum32:).*' = "`${1}$checksum32"
      '(?i)(checksum64:).*' = "`${1}$checksum64"
      '(?i)(File ''LICENSE.txt'' is obtained from\s*)\<.*\>' = "`${1}<$license>"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  Update-Package -ChecksumFor None
}
