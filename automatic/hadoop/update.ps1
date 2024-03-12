Import-Module Chocolatey-AU

$releases = 'http://hadoop.apache.org/releases.html'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]mirrors\s*=\s*)('.*')"    = "`$1'$($Latest.MIRRORS)'"
      "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $regex = '\.tar\.gz$'

  $get_dl_url = $download_page.links | Where-Object href -match $regex | Select-Object -First 2 -expand href

  $version = $get_dl_url[0] -split '/|-' | Select-Object -Last 1 -Skip 1

  $get_mirror_page = Invoke-WebRequest -Uri $get_dl_url[1] -UseBasicParsing

  $url = $get_mirror_page.links | Where-Object href -match $regex | Select-Object -First 1 -expand href

  return @{ MIRRORS = $get_dl_url[1]; URL32 = $url; Version = $version }
}

function global:au_AfterUpdate ($Package) {

  if ($Package.RemoteVersion -ne $Package.NuspecVersion) {

      Get-RemoteFiles -NoSuffix

      $file = [IO.Path]::Combine("tools", $Latest.FileName32)

      Write-Output "Submitting file $file to VirusTotal"

      # Assumes vt-cli Chocolatey package is installed!
      vt.exe scan file $file --apikey $env:VT_APIKEY

      Remove-Item $file -ErrorAction Ignore

      $Latest.Remove("FileName32")
  }
}

update -ChecksumFor 32
