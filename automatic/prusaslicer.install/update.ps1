Import-Module Chocolatey-AU

$releases = "https://files.prusa3d.com/wp-content/uploads/repository/PrusaSlicer-settings-master/live/PrusaSlicer.version"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName64)`""
    }
    "$($Latest.PackageName).nuspec" = @{
      "(?i)(^\s*\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
    }

    ".\legal\VERIFICATION.txt" = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUri)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType64)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_BeforeUpdate {
  Get-RemoteFiles -Purge
}

function Get-PrusaSlicerVersionFile {
  $response = Invoke-WebRequest -Uri $releases -UseBasicParsing

  if ($response.Content -is [byte[]]) {
    return [System.Text.Encoding]::UTF8.GetString($response.Content)
  }

  [string]$response.Content
}

function ConvertFrom-PrusaSlicerVersionFile {
  param(
    [Parameter(Mandatory)]
    [string] $Content
  )

  $section = 'root'
  $versionData = @{
    root = @{}
  }

  foreach ($line in ($Content -split '\r?\n')) {
    $line = $line.Trim()

    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#') -or $line.StartsWith(';')) {
      continue
    }

    if ($line -match '^\[(?<section>[^\]]+)\]$') {
      $section = $matches['section'].Trim()
      if (-not $versionData.ContainsKey($section)) {
        $versionData[$section] = @{}
      }
      continue
    }

    if ($line -match '^(?<key>[^=]+?)\s*=\s*(?<value>.+)$') {
      $key = $matches['key'].Trim()
      $value = $matches['value'].Trim()
      $versionData[$section][$key] = $value
      continue
    }

    if ($section -eq 'root' -and $line -match '^\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?$') {
      $versionData[$section]['release'] = $line
    }
  }

  $versionData
}

function Get-PrusaSlicerVersionValue {
  param(
    [Parameter(Mandatory)]
    [hashtable] $VersionData,

    [Parameter(Mandatory)]
    [string] $Name
  )

  if ($VersionData.ContainsKey('common') -and $VersionData['common'].ContainsKey($Name)) {
    return $VersionData['common'][$Name]
  }

  if ($VersionData.ContainsKey('root') -and $VersionData['root'].ContainsKey($Name)) {
    return $VersionData['root'][$Name]
  }

  $null
}

function global:au_GetLatest {
  $versionData = ConvertFrom-PrusaSlicerVersionFile -Content (Get-PrusaSlicerVersionFile)

  $releaseVersion = Get-PrusaSlicerVersionValue -VersionData $versionData -Name 'release'

  if (-not $releaseVersion) {
    throw "Could not find the latest PrusaSlicer release version on $releases."
  }

  if (-not $versionData.ContainsKey('release:win64') -or -not $versionData['release:win64'].ContainsKey('url')) {
    throw "Could not find the PrusaSlicer Windows 64-bit download URL on $releases."
  }

  $url = $versionData['release:win64']['url']
  $version = Get-Version($releaseVersion)
  $releaseUri = "https://github.com/prusa3d/PrusaSlicer/releases/tag/version_${releaseVersion}"

  @{
    URL64        = $url
    Version      = $version
    ReleaseUri   = $releaseUri
    ReleaseNotes = $releaseUri
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor none
}
