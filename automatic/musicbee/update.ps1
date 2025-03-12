Import-Module Chocolatey-AU

$releases = 'https://www.getmusicbee.com/downloads/'

function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = Resolve-Path tools

  Write-Host 'Purging' $ext
  Remove-Item -Force "$toolsPath\*.$ext" -ea ignore

  $Algorithm = 'sha256'

  $CurrentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'

  try {
    & $env:LocalAppData\MEGAcmd\MEGAclient.exe get $Latest.Url32 $toolsPath

    $file_object = Get-ChildItem $toolsPath -Filter *.zip | Select-Object -First 1
    $file_path = $file_object.FullName
    $file_name = $file_object.Name

    $Latest.Checksum32 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
    $Latest.ChecksumType32 = $Algorithm
    $Latest.FileName32 = $file_name
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
  $download_page = Invoke-WebRequest -Uri $releases

  $url = ($download_page.Links | Where-Object innerText -Match "Get MusicBee Installer").href

  $version = $download_page.Content -Match 'MusicBee ([\d.]+)'
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
