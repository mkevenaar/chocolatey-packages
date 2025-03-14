Import-Module Chocolatey-AU

$releases = 'http://www.cpuid.com/softwares/cpu-z.htm'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
    }
  }
}

function global:au_GetLatest {
  $re = 'cpu-z.+exe'

  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -Expand href

  $download_page = Invoke-WebRequest -Uri "http://www.cpuid.com/$url" -UseBasicParsing
  $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -Expand href

  $current_checksum = (Get-Item $PSScriptRoot\tools\chocolateyInstall.ps1 | Select-String '\bchecksum\b') -split "=|'" | Select-Object -Last 1 -Skip 1
  if ($current_checksum.Length -ne 64) { throw "Can't find current checksum" }
  $remote_checksum = Get-RemoteChecksum $url
  if ($current_checksum -ne $remote_checksum) {
    Write-Host 'Remote checksum is different then the current one, forcing update'
    $global:au_old_force = $global:au_force
    $global:au_force = $true
  }

  @{
    Version    = $url -split '[_-]' | Select-Object -Last 1 -Skip 1
    URL32      = $url
    Checksum32 = $remote_checksum
  }
}

if ($MyInvocation.InvocationName -ne '.') {
  # run the update only if script is not sourced
  update -ChecksumFor none
  if ($global:au_old_force -is [bool]) { $global:au_force = $global:au_old_force }
}
