function Update-Metadata() {
  param(
    [Parameter(Mandatory = $true)][string]$key,
    [Parameter(Mandatory = $true)][string]$value)

  Write-Host "Setting the nuspec $key element to '$value'..."

  $nuspecFileName = Resolve-Path "*.nuspec"
  $nu = New-Object xml
  $nu.PSBase.PreserveWhitespace = $true
  $nu.Load($nuspecFileName)
  $nu.package.metadata."$key" = $value

  $utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($false)

  [System.IO.File]::WriteAllText($nuspecFileName, $nu.InnerXml, $utf8NoBomEncoding)
}
