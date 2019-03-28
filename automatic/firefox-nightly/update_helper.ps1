import-module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"
$localeChecksumFile = 'LanguageChecksums.csv'

function GetVersionAndUrlFormats() {
  param(
    [string]$UpdateUrl,
    [string]$Product,
    [bool]$Supports64Bit = $true
  )

  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $UpdateUrl
  if ($Product -ne 'firefox-dev' -and $Product -ne 'firefox-nightly')   {
    $re = "download.mozilla.*product=$Product.*(&amp;|&)os=win(&amp;|&)lang=en-US"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -first 1 -expand href
    $url = Get-RedirectedUrl $url
    $url = $url -replace 'en-US', '${locale}' -replace '&amp;', '&'
  } elseif ($Product -eq 'firefox-dev') {
    $re = "Setup"
    $url = 'https://releases.mozilla.org' + $download_page.links[-1].href + 'win32/en-US/'
    $download_page = Invoke-WebRequest -UseBasicParsing -Uri $url
    $url = 'https://releases.mozilla.org' + ($download_page.links | Where-Object href -match $re | Select-Object -first 1 -expand href)
    $url = $url -replace 'en-US','${locale}' -replace '&amp;','&'
  } elseif ($Product -eq 'firefox-nightly') {
    $re = "en-US.win64.buildhub.json"
    $url = 'https://releases.mozilla.org' + ($download_page.links | Where-Object href -match $re | Select-Object -last 1 -expand href)
    $json = Invoke-WebRequest $url | ConvertFrom-Json
    $url = $json.download.url
    $url = $url -replace 'en-US','${locale}' -replace '&amp;','&'
    $url = $url -replace -replace 'win64','win32'
  }

  $result = @{
    Version = $url -split '\/' | Select-Object -last 1 -skip 3
    Win32Format = $url
  }
  if ($result.Version.EndsWith('esr')) {
    $result.Version = $result.Version.TrimEnd('esr')
  }
  if ($Product -eq 'firefox-nightly') {
    $result.version = $json.target.version
    $result.chocoversion = ($json.target.version -replace 'a', '.') + "." + ($json.build.id -replace ".{4}$") + "-alpha"
  }
  if ($Supports64Bit) {
    $result += @{
      Win64Format = $url -replace 'os=win','os=win64' -replace 'win32','win64'
    }
  }
  return $result
}

function CreateNightlyChecksumsFile() {
  param(
    [string]$ToolsDirectory,
    [string]$Version,
    [string]$Product
  )
  $sha512re = "^([a-f\d]+)\s*sha512 [\d]+ installer.exe"

  $reOpts = [System.Text.RegularExpressions.RegexOptions]::Multiline `
    -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase

#  #First en-US chekcsums
#  $en32Checksums =  Invoke-WebRequest -UseBasicParsing -Uri "https://releases.mozilla.org/pub/$Product/nightly/latest-mozilla-central/firefox-${Version}.en-US.win32.checksums"
#  $en64Checksums =  Invoke-WebRequest -UseBasicParsing -Uri "https://releases.mozilla.org/pub/$Product/nightly/latest-mozilla-central/firefox-${Version}.en-US.win64.checksums"

#  $checksumRows = [regex]::Matches("$en32Checksums", $sha512re, $reOpts) | ForEach-Object {
#    return "en-US|32|$( $_.Groups[1].Value )`n"
#  }
#  $checksumRows += [regex]::Matches("$en64Checksums", $sha512re, $reOpts) | ForEach-Object {
#    return "en-US|64|$( $_.Groups[1].Value )`n"
#  }

  #Other languages
  $re = "firefox-${Version}.(.+).win(32|64).checksums$"
  $download_page = Invoke-WebRequest -UseBasicParsing -Uri "https://releases.mozilla.org/pub/firefox/nightly/latest-mozilla-central-l10n/"
  $checksumFiles = $download_page.links | Where-Object href -match $re
  $baseUrl = 'https://releases.mozilla.org'

  foreach ($checksumFile in $checksumFiles) {
    $url = $checksumFile.href
    $locale = ([regex]::Match($url,$re)).Captures.Groups[1].value
    $bits = ([regex]::Match($url,$re)).Captures.Groups[2].value
    $data = Invoke-WebRequest -UseBasicParsing -Uri "${baseUrl}${url}"
    $checksum = [regex]::Matches("$data", $sha512re, $reOpts).Captures.Groups[1].value
    $checksumRows += "${locale}|${bits}|${checksum}`n"
  }

  $checksumRows | Out-File "$ToolsDirectory\$localeChecksumFile" -Encoding utf8
}

function CreateChecksumsFile() {
  param(
    [string]$ToolsDirectory,
    [string]$ExecutableName,
    [string]$Version,
    [string]$Product,
    [switch]$ExtendedRelease = $false,
    [switch]$DevelopmentRelease = $false,
    [switch]$NightlyRelease = $false
  )
  if ($ExtendedRelease) {
    $allChecksums = Invoke-WebRequest -UseBasicParsing -Uri "https://releases.mozilla.org/pub/$Product/releases/${Version}esr/SHA512SUMS"
  } elseif ($DevelopmentRelease) {
    $allChecksums = Invoke-WebRequest -UseBasicParsing -Uri "https://releases.mozilla.org/pub/devedition/releases/${Version}/SHA512SUMS"
  } elseif ($NightlyRelease) {
    # Nothing to do here, move along... No need to download someting as it will be done in CreateNightlyChecksumsFile
  }else {
    $allChecksums = Invoke-WebRequest -UseBasicParsing -Uri "https://releases.mozilla.org/pub/$Product/releases/$Version/SHA512SUMS"
  }

  if ($NightlyRelease)
  {
    CreateNightlyChecksumsFile -ToolsDirectory $ToolsDirectory `
    -Version $Version `
    -Product $Product
  } else {
    $reOpts = [System.Text.RegularExpressions.RegexOptions]::Multiline `
      -bor [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    $checksumRows = [regex]::Matches("$allChecksums", "^([a-f\d]+)\s*win(32|64)\/([a-z\-]+)\/$ExecutableName$", $reOpts) | ForEach-Object {
      return "$($_.Groups[3].Value)|$($_.Groups[2].Value)|$($_.Groups[1].Value)"
    }

    $checksumRows | Out-File "$ToolsDirectory\$localeChecksumFile" -Encoding utf8
  }
}

function SearchAndReplace() {
  param(
    [string]$PackageDirectory,
    [hashtable]$Data,
    [bool]$Supports64Bit = $true
  )

  $installReplacements = @{
    "(?i)(^[$]packageName\s*=\s*)('.*')"      = "`$1'$($Data.PackageName)'"
    "(?i)(^[$]softwareName\s*=\s*)('.*')"     = "`$1'$($Data.SoftwareName)'"
    "(?i)(-version\s*)('.*')"                 = "`$1'$($Data.RemoteVersion)'"
    '(?i)(\s*Url\s*=\s*)(".*")'               = "`$1`"$($Data.Win32Format)`""
    '(?i)(\s*\-(checksum|locale)File\s*)".*"' = "`$1`"`$toolsPath\$localeChecksumFile`""
  }

  if ($Supports64Bit) {
    $installReplacements += @{
    '(?i)(\.Url64\s*=\s*)(".*")'              = "`$1`"$($Data.Win64Format)`""
    }
  }

  $result = @{
    "$PackageDirectory\tools\chocolateyInstall.ps1" = $installReplacements
    "$PackageDirectory\tools\chocolateyUninstall.ps1" = @{
      "(?i)(^[$]packageName\s*=\s*)('.*')"      = "`$1'$($Data.PackageName)'"
      "(?i)(-SoftwareName\s*)('.*')"            = "`$1'$($Data.SoftwareName)*'"
    }
  }

  $result += @{
    "$PackageDirectory\*.nuspec" = @{
      "(?i)(\<releaseNotes\>).*(\<\/releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`${2}"
      "(?i)(\<iconUrl\>).*(\<\/iconUrl\>)" = "`${1}$($Latest.IconURL)`${2}"
      "(?i)(\<projectUrl\>).*(\<\/projectUrl\>)" = "`${1}$($Latest.ProjectUrl)`${2}"
      "(?i)(\<tags\>).*(\<\/tags\>)" = "`${1}$($Latest.Tags)`${2}"
    }
  }

  $result
}
