Import-Module Chocolatey-AU
[string]$ReleasesUrl = 'https://www.intel.com/content/www/us/en/download/785597/intel-arc-graphics-windows.html'

$headers = @{
  "Accept"          = "*/*"
  "Accept-Language" = "en-US,en;q=0.9"
  "User-Agent"      = "curl/8.0.1"
}

$regexOptions = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline

function Get-RegexMatch {
  param(
    [string]$Content,
    [string]$Pattern,
    [string]$ErrorMessage
  )

  $match = [regex]::Match($Content, $Pattern, $regexOptions)
  if (-not $match.Success) { throw $ErrorMessage }
  $match
}

function Get-RemoteChecksum {
  param(
    [string]$Url
  )

  $checksumType = 'sha256'
  $fileName = Split-Path -Path ([System.Uri]$Url).AbsolutePath -Leaf
  $downloadDirectory = Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString())
  $destination = Join-Path -Path $downloadDirectory -ChildPath $fileName
  $previousProgressPreference = $ProgressPreference

  try {
    $ProgressPreference = 'SilentlyContinue'
    New-Item -Path $downloadDirectory -ItemType Directory -Force | Out-Null
    Invoke-WebRequest -Uri $Url -UseBasicParsing -OutFile $destination
    $checksum = Get-FileHash -Path $destination -Algorithm $checksumType | ForEach-Object Hash
  }
  finally {
    $ProgressPreference = $previousProgressPreference
    if (Test-Path -LiteralPath $downloadDirectory) {
      Remove-Item -LiteralPath $downloadDirectory -Recurse -Force
    }
  }

  @{
    Checksum64     = $checksum
    ChecksumType64 = $checksumType
  }
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
      "(^[$]checksum64\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum64)'"
      "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }

    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
    }
  }
}

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $ReleasesUrl -UseBasicParsing -Headers $headers

  $versionMatch = Get-RegexMatch `
    -Content $downloadPage.Content `
    -Pattern '<meta\s+name="DownloadVersion"\s+content="(?<Version>\d+(?:\.\d+){3})(?:\s+[^"]*)?"\s*/?>' `
    -ErrorMessage "Failed to locate the Intel Arc graphics driver version on '$ReleasesUrl'."

  $downloadMatch = Get-RegexMatch `
    -Content $downloadPage.Content `
    -Pattern 'https://downloadmirror\.intel\.com/(?<PackageNumber>\d+)/gfx_win_(?<DriverVersion>\d+\.\d+)\.exe' `
    -ErrorMessage "Failed to locate the Intel Arc graphics driver download URL on '$ReleasesUrl'."

  $releaseNotesMatch = Get-RegexMatch `
    -Content $downloadPage.Content `
    -Pattern 'https://downloadmirror\.intel\.com/\d+/ReleaseNotes_\d+(?:\.\d+)+(?:_\d+(?:\.\d+)*)?(?:_?WHQL|_)?\.pdf' `
    -ErrorMessage "Failed to locate the Intel Arc graphics driver release notes URL on '$ReleasesUrl'."

  $checksum = Get-RemoteChecksum -Url $downloadMatch.Value

  @{
    URL64         = $downloadMatch.Value
    Checksum64    = $checksum.Checksum64
    ChecksumType64 = $checksum.ChecksumType64
    Version       = $versionMatch.Groups['Version'].Value
    ReleaseNotes  = $releaseNotesMatch.Value
  }
}

Update-Package -ChecksumFor none -NoCheckUrl
