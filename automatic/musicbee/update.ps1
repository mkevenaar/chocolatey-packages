Import-Module Chocolatey-AU

$releases = 'https://www.getmusicbee.com/downloads/'
$majorGeeksMirror = 'https://www.majorgeeks.com/mg/getmirror/musicbee,1.html'
$downloadTimeoutSeconds = 300

function Get-MusicBeeMirrorDownloadUrl {
  $downloadPage = Invoke-WebRequest -Uri $majorGeeksMirror -UseBasicParsing -TimeoutSec 60
  $downloadUrlPattern = "https?://files\d+\.majorgeeks\.com/[^\s`"'<]+/MusicBeeSetup[^\s`"'<]+\.zip"
  $match = [regex]::Match($downloadPage.Content, $downloadUrlPattern)

  if (!$match.Success) {
    throw "Unable to find MusicBee installer download URL on $majorGeeksMirror"
  }

  # The MajorGeeks file hosts currently fail TLS negotiation with Windows web clients.
  return $match.Value -replace '^https:', 'http:'
}

function Save-MusicBeeInstaller {
  param(
    [string] $Url,
    [string] $Destination
  )

  $expectedLength = $null

  try {
    $headResponse = Invoke-WebRequest -Uri $Url -UseBasicParsing -Method Head -TimeoutSec 60
    if ($headResponse.Headers.'Content-Length') {
      $expectedLength = [int64] @($headResponse.Headers.'Content-Length')[0]
    }
  }
  catch {
    Write-Warning "Unable to read MusicBee installer content length: $($_.Exception.Message)"
  }

  Invoke-WebRequest -Uri $Url -UseBasicParsing -OutFile $Destination -TimeoutSec $downloadTimeoutSeconds

  if (!(Test-Path -LiteralPath $Destination)) {
    throw "MusicBee installer was not downloaded to $Destination"
  }

  $file = Get-Item -LiteralPath $Destination

  if ($file.Length -eq 0) {
    throw "MusicBee installer download is empty: $Destination"
  }

  if ($expectedLength -and $file.Length -ne $expectedLength) {
    throw "MusicBee installer download size mismatch. Expected $expectedLength bytes, got $($file.Length) bytes."
  }

  return $file
}

function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = (Resolve-Path tools).Path

  Write-Host 'Purging' $ext
  Remove-Item -Force "$toolsPath\*.$ext" -ea ignore

  $Algorithm = 'sha256'

  $CurrentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'

  try {
    $fileName = [IO.Path]::GetFileName(([uri] $Latest.Url32).AbsolutePath)

    if ([string]::IsNullOrWhiteSpace($fileName)) {
      throw "Unable to determine MusicBee installer file name from $($Latest.Url32)"
    }

    $file = Save-MusicBeeInstaller -Url $Latest.Url32 -Destination (Join-Path $toolsPath $fileName)

    $Latest.Checksum32 = Get-FileHash $file.FullName -Algorithm $Algorithm | ForEach-Object Hash
    $Latest.ChecksumType32 = $Algorithm
    $Latest.FileName32 = $file.Name
  }
  catch {
    throw $_
  }
  finally {
    $ProgressPreference = $CurrentProgressPreference
  }
}

function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -TimeoutSec 60

  $url = Get-MusicBeeMirrorDownloadUrl

  $version = $download_page.Content -Match 'MusicBee\s+([\d.]+)'
  if (!$version) {
    throw "Unable to find MusicBee version on $releases"
  }
  $versionData = Get-Version($Matches[1])
  $version = $versionData.toString()

  return @{
    URL32    = $url
    Version  = $version
    FileType = 'zip'
  }
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
    }
    ".\legal\VERIFICATION.txt"      = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
    }
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  update -ChecksumFor None -NoCheckUrl
}
