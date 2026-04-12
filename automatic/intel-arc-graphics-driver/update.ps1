Import-Module Chocolatey-AU
[string]$ReleasesUrl = 'https://www.intel.com/content/www/us/en/download/785597/intel-arc-graphics-windows.html'

$headers = @{
  "Accept"          = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8"
  "Accept-Language" = "en-GB,en;q=0.5"
  "Accept-Encoding" = "gzip, deflate, br, zstd"
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
    -Pattern 'Version\s+(?<Version>\d+(?:\.\d+){3})' `
    -ErrorMessage "Failed to locate the Intel Arc graphics driver version on '$ReleasesUrl'."

  $downloadMatch = Get-RegexMatch `
    -Content $downloadPage.Content `
    -Pattern 'https://downloadmirror\.intel\.com/(?<PackageNumber>\d+)/gfx_win_(?<DriverVersion>\d+\.\d+)\.exe' `
    -ErrorMessage "Failed to locate the Intel Arc graphics driver download URL on '$ReleasesUrl'."

  $releaseNotesMatch = Get-RegexMatch `
    -Content $downloadPage.Content `
    -Pattern 'https://downloadmirror\.intel\.com/\d+/ReleaseNotes_\d+(?:\.\d+)+(?:_\d+(?:\.\d+)+)?(?:_WHQL)?\.pdf' `
    -ErrorMessage "Failed to locate the Intel Arc graphics driver release notes URL on '$ReleasesUrl'."

  @{
    URL64         = $downloadMatch.Value
    Version       = $versionMatch.Groups['Version'].Value
    ReleaseNotes  = $releaseNotesMatch.Value
  }
}

Update-Package -ChecksumFor 64 -NoCheckUrl
