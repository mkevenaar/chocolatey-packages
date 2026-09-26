Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_BeforeUpdate {
  $dest = Join-Path $env:TEMP ("viber-{0}.msi" -f [guid]::NewGuid())

  try {
    Get-WebFile $Latest.URL64 $dest | Out-Null
    $version = (Get-MsiInformation -Path $dest -Property ProductVersion -ErrorAction Stop).ProductVersion
    if ($version -ne $Latest.InstallerVersion) {
      throw "Viber MSI version '$version' does not match the advertised version '$($Latest.InstallerVersion)'."
    }

    $Latest.ChecksumType64 = 'sha256'
    $Latest.Checksum64 = (Get-FileHash -Path $dest -Algorithm $Latest.ChecksumType64).Hash
  }
  finally {
    # Release the MSI database handles left by Get-MsiInformation before deleting the download.
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    if (Test-Path -LiteralPath $dest) {
      Remove-Item -LiteralPath $dest -Force
    }
  }
}

function global:au_GetLatest {
  $downloadDirectory = Join-Path $env:TEMP ("viber-{0}" -f [guid]::NewGuid())
  $bootstrapper = Join-Path $downloadDirectory 'ViberSetup.exe'

  try {
    New-Item -Path $downloadDirectory -ItemType Directory | Out-Null
    Get-WebFile 'https://download.cdn.viber.com/desktop/windows/ViberSetup.exe' $bootstrapper | Out-Null
    # Read the Burn manifest without running the bootstrapper, which fails unattended with exit code 1602.
    Get-ChocolateyUnzip -FileFullPath $bootstrapper -Destination $downloadDirectory -SpecificFolder '0' -DisableLogging | Out-Null
    [xml]$manifest = Get-Content -LiteralPath (Join-Path $downloadDirectory '0') -Raw -ErrorAction Stop
    $payload = @($manifest.BurnManifest.Payload | Where-Object Id -eq 'ViberSetup')
    $package = @($manifest.BurnManifest.Chain.MsiPackage | Where-Object Id -eq 'ViberSetup')
    if ($payload.Count -ne 1 -or $package.Count -ne 1) {
      throw 'Unable to locate the current Viber MSI in the bootstrapper manifest.'
    }

    $url64 = $payload[0].DownloadUrl
    $version = $package[0].Version
    if ($version -notmatch '^\d+\.\d+\.\d+\.\d+$' -or
        $url64 -notmatch '^https://download\.cdn\.viber\.com/desktop/windows/\d+(?:\.\d+){2,3}/ViberSetup\.msi$') {
      throw 'The Viber bootstrapper does not advertise a valid version and version-specific MSI URL.'
    }

    return @{
      URL64            = $url64
      Version          = $version
      InstallerVersion = $version
    }
  }
  finally {
    if (Test-Path -LiteralPath $downloadDirectory) {
      if ((Get-Item -LiteralPath $downloadDirectory).Parent.FullName -ne (Get-Item -LiteralPath $env:TEMP).FullName) {
        throw "Refusing to remove a Viber download directory outside '$env:TEMP'."
      }
      Remove-Item -LiteralPath $downloadDirectory -Recurse -Force
    }
  }
}

update -ChecksumFor none
