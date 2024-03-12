Import-Module Chocolatey-AU

$releases = "https://marketplace.visualstudio.com/items?itemName=redhat.ansible"

function global:au_BeforeUpdate($Package) {
  $vscode = $Package.nuspecXml.package.metadata.dependencies.dependency | ? id -Match '^vscode$'

  if (([version]$Latest.VsCodeVersion) -lt '1.30.0') {
    $vscode.version = '1.30.0'
  }
  else {
    $vscode.version = $Latest.VsCodeVersion
  }
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(redhat.ansible@)[^']*" = "`${1}$($Latest.RemoteVersion)"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -UseBasicParsing $releases

  if ($download_page.Content -match 'assetUri":"([^"]+)') {
    $assetUri = $Matches[1]
  }
  else {
    throw "Unable to grab asset uri file"
  }

  $json = Invoke-RestMethod -UseBasicParsing "$assetUri/Microsoft.VisualStudio.Code.Manifest"

  $vsCodeVersion = $json.engines.vscode.TrimStart('^')
  if ($vsCodeVersion -eq '1.5.0') { $vsCodeVersion = '1.5' }

  @{
    Version       = $json.version
    RemoteVersion = $json.version
    VsCodeVersion = $vsCodeVersion
  }
}

update -ChecksumFor none
