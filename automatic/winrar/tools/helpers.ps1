function GetDownloadInfo {
  param(
    [string]$downloadInfoFile,
    [string]$code,
    [string]$urlVersion
  )
  Write-Debug "Reading CSV file from $downloadInfoFile"
  $downloadInfo = Get-Content -Encoding UTF8 -Path $downloadInfoFile | ConvertFrom-Csv -Delimiter '|' -Header 'Code','URL32','Checksum32','URL64','Checksum64'
  $downloadInfo | Where-Object { $_.Code -eq $code } | Select-Object -first 1
}
