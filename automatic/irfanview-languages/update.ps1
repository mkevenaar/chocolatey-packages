Import-Module Chocolatey-AU

$releases = 'https://www.irfanview.com/languages.htm'

$headers = @{
  Referer = 'https://www.irfanview.com/languages.htm'
  "User-Agent" = "Chocolatey AU update check. https://chocolatey.org"
}

$options =
@{
  Headers = $headers
}

function global:au_SearchReplace {
  return @{
    ".\legal\VERIFICATION.txt"   = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUri)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
    }
    "$($Latest.PackageName).nuspec" = @{
      "(\<dependency .+?`"irfanview`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.Version)`""
    }
  }
}

function name4url($url) {
  if ($FileNameBase) { return $FileNameBase }
  $res = $url -split '/' | Select-Object -Last 1
  $res -replace '\.[^.]+$'
}

function global:au_BeforeUpdate {
  $ext = $Latest.FileType
  $toolsPath = Resolve-Path tools
  $legalPath = Resolve-Path legal
  $NoSuffix = $true

  Write-Host 'Purging' $ext
  Remove-Item -Force "$toolsPath\*.$ext" -ea ignore

  $Algorithm = 'sha256'

  $CurrentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'

  $csvdata = 'Filename,Checksum'

  try {
    $client = New-Object System.Net.WebClient
    $headers.GetEnumerator() | ForEach-Object { $client.Headers.Add($_.Key, $_.Value) | Out-Null }

    $Latest.URLLIST | ForEach-Object {
      $base_name = name4url $_
      $file_name = "{0}{2}.{1}" -f $base_name, $ext, $(if ($NoSuffix) { '' } else {'_x32'})
      $file_path = Join-Path $toolsPath $file_name

      Write-Host "Downloading to $file_name -" $Latest.URL32
      $client.DownloadFile($_, $file_path)
      $Checksum32 = Get-FileHash $file_path -Algorithm $Algorithm | ForEach-Object Hash
      $csvdata += "`r`n`"" + $file_name + '","' + $Checksum32 + '"'
   }
   $Latest.ChecksumType32 = $Algorithm
   $csvfilename = Join-Path $legalPath 'checksums.csv'
   $csvdata | Out-File $csvfilename -Encoding UTF8 -Force -NoNewline

  } catch {
    throw $_
  } finally {
    $client.Dispose()
    $ProgressPreference = $CurrentProgressPreference
  }
}

function global:au_AfterUpdate($Package) {
  Invoke-VirusTotalScan $Package
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'Languages for version (.+\d)</h3>'
  $version = ([regex]::Match($download_page.content, $re)).Captures.Groups[1].value

  $urllist = $download_page.Links | Where-Object -Property href -match "irfanview_lang_(.+).zip" | Select-Object -ExpandProperty href


  return @{
    URLLIST  = $urllist
    Version  = $version
    Options  = $options
    FileType = 'zip'
    ReleaseUri = $releases
  }
}

update -ChecksumFor None -NoCheckUrl
