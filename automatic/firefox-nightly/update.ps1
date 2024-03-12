[CmdletBinding()]
param($IncludeStream, [switch] $Force)
Import-Module Chocolatey-AU
. "$PSScriptRoot\update_helper.ps1"

$releasesNIGHTLY = 'https://releases.mozilla.org/pub/firefox/nightly/latest-mozilla-central-l10n/'
$product = 'firefox'

function global:au_BeforeUpdate {
  cp "$PSScriptRoot\Readme.$($Latest.PackageName).md" "$PSScriptRoot\README.md" -Force
}

function global:au_AfterUpdate {
  CreateChecksumsFile -ToolsDirectory "$PSScriptRoot\tools" `
    -ExecutableName $Latest.ExeName `
    -Version $Latest.RemoteVersion `
    -Product $product `
    -ExtendedRelease:$($Latest.PackageName -eq 'FirefoxESR') `
    -DevelopmentRelease:$($Latest.PackageName -eq 'firefox-dev') `
    -NightlyRelease:$($Latest.PackageName -eq 'firefox-nightly')
}

function global:au_SearchReplace {
  SearchAndReplace -PackageDirectory "$PSScriptRoot" `
    -Data $Latest
}

function global:au_GetLatest {

  $streams = @{}
  
  $data = GetVersionAndUrlFormats -UpdateUrl $releasesNIGHTLY -Product "${product}-nightly"
  $version = $data.Version

  $streams.Add("nightly", @{
      LocaleURL     = "$releases"
      Version       = $data.chocoversion
      RemoteVersion = $version
      Win32Format   = $data.Win32Format
      Win64Format   = $data.Win64Format
      SoftwareName  = 'Nightly'
      ReleaseNotes  = "https://hg.mozilla.org/mozilla-central/log/"
      IconURL       = "https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@972436b98f0066a91d8f6899e42a6ccf06c7acbf/icons/firefox-nightly.png"
      ProjectURL    = "https://www.mozilla.org/firefox/nightly/"
      Tags          = "browser mozilla firefox alpha admin foss cross-platform"
      PackageName   = 'firefox-nightly'
      ExeName       = "firefox-${version}.${locale}.win32.exe"
      ExeName64     = "firefox-${version}.${locale}.win64.exe"
    })

  return @{ Streams = $streams }
}

update -ChecksumFor none -IncludeStream $IncludeStream -Force:$Force
