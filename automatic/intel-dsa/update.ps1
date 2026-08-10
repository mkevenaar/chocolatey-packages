Import-Module Chocolatey-AU
[string]$DownloadURL = 'https://dsadata.intel.com/installer'

function global:au_SearchReplace {
  @{
    "tools\chocolateyinstall.ps1" = @{
      "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
    }
  }
}

function global:au_BeforeUpdate {}

function global:au_GetLatest {
  $ReturnHt = @{
    URL32 = $DownloadURL
  }

  $TempFile = Join-Path $env:TEMP "$(New-Guid).exe"
  $PreviousProgressPreference = $ProgressPreference

  try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing -OutFile $TempFile

    $LatestVersion = (Get-ItemProperty -Path $TempFile).VersionInfo.ProductVersion
    if (-not $LatestVersion) {
      throw "Failed to determine the Intel DSA version from '$DownloadURL'."
    }

    $ReturnHt.Checksum32 = Get-FileHash -Path $TempFile -Algorithm SHA256 | ForEach-Object Hash
  }
  finally {
    $ProgressPreference = $PreviousProgressPreference

    if (Test-Path -LiteralPath $TempFile) {
      Remove-Item -LiteralPath $TempFile -Force
    }
  }

  $ReturnHt.Version = $LatestVersion

  return $ReturnHt
}

Update-Package -ChecksumFor 32 -NoCheckUrl
