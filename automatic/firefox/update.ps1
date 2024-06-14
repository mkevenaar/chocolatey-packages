[CmdletBinding()]
param($IncludeStream, [switch] $Force)
Import-Module Chocolatey-AU
. "$PSScriptRoot\update_helper.ps1"

$releasesBETA    = 'https://www.mozilla.org/en-US/firefox/beta/all/'
$releasesDEV     = 'https://www.mozilla.org/en-US/firefox/developer/all/'
$product = 'firefox'

function global:au_BeforeUpdate {
  Copy-Item "$PSScriptRoot\Readme.$($Latest.PackageName).md" "$PSScriptRoot\README.md" -Force
}

function global:au_AfterUpdate {
  CreateChecksumsFile -ToolsDirectory "$PSScriptRoot\tools" `
    -ExecutableName $Latest.ExeName `
    -Version $Latest.RemoteVersion `
    -Product $product `
    -ExtendedRelease:$($Latest.PackageName -eq 'FirefoxESR') `
    -DevelopmentRelease:$($Latest.PackageName -eq 'firefox-dev') `
}

function global:au_SearchReplace {
  SearchAndReplace -PackageDirectory "$PSScriptRoot" `
    -Data $Latest
}

function global:au_GetLatest {

  $streams = @{}
  
  $data = GetVersionAndUrlFormats -UpdateUrl $releasesBETA -Product "${product}-beta"
  $version = $data.Version
  $betaversion = $version -replace "b", "."
  $betaversion += "-beta"

  $streams.Add("beta", @{
      LocaleURL     = "$releases"
      Version       = $betaversion
      RemoteVersion = $version
      Win32Format   = $data.Win32Format
      Win64Format   = $data.Win64Format
      SoftwareName  = 'Mozilla Firefox'
      SoftwareTitle = "Firefox Beta"
      ReleaseNotes  = "https://www.mozilla.org/firefox/beta/notes/"
      IconURL       = "https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@92fc1201bdb7d7deb90a0b4ec4b12f26e6e5412c/icons/firefox-beta.png"
      ProjectURL    = "https://www.mozilla.org/firefox/beta"
      Tags          = "browser mozilla firefox beta admin foss cross-platform"
      PackageName   = 'firefox-beta'
      ExeName       = "Firefox Setup ${version}.exe"
    })

  $data = GetVersionAndUrlFormats -UpdateUrl $releasesDEV -Product "${product}-dev"
  $version = $data.Version
  $betaversion = $version -replace "b", "."
  $betaversion += "-beta"

  $streams.Add("dev", @{
      LocaleURL     = "$releases"
      Version       = $betaversion
      RemoteVersion = $version
      Win32Format   = $data.Win32Format
      Win64Format   = $data.Win64Format
      SoftwareName  = 'Firefox Developer Edition'
      SoftwareTitle = "Firefox Developer Edition"
      ReleaseNotes  = "https://www.mozilla.org/en-US/firefox/developer/notes/"
      IconURL       = "https://cdn.jsdelivr.net/gh/mkevenaar/chocolatey-packages@b40e08792b4d113bcb96960eaa184c093471a01e/icons/firefox-dev.png"
      ProjectURL    = "https://www.mozilla.org/firefox/developer"
      Tags          = "browser mozilla firefox developmer admin foss cross-platform"
      PackageName   = 'firefox-dev'
      ExeName       = "Firefox Setup ${version}.exe"
    })

  return @{ Streams = $streams }
}

update -ChecksumFor none -IncludeStream $IncludeStream -Force:$Force
