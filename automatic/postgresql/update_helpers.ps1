function Get-WebRequestTable {
  param(
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest
  )

  $table = @($WebRequest.ParsedHtml.getElementsByTagName('table'))
  $titles = @()
  $rows = @($table.Rows)

  foreach ($row in $rows) {
    $cells = @($row.Cells)
    if ($cells[0].tagName -eq "TH") {
      $titles = @($cells | ForEach-Object { ("" + $_.InnerText).Trim() })
      continue
    }
    if (!$titles) { $titles = @(1..($cells.Count + 2) | ForEach-Object { "P$_" }) }

    $resultObject = [Ordered] @{}
    for ($counter = 0; $counter -lt $cells.Count; $counter++) {
      $title = $titles[$counter]
      if (!$title) { continue }
      $resultObject[$title] = ("" + $cells[$counter].InnerHtml).Trim()
    }
    [PSCustomObject] $resultObject
  }
}

function Resolve-PostgreUrl([string] $url) {
  if ($url.EndsWith('.exe')) { return $url }

  $params = @{
    MaximumRedirection = 0
    Uri                = $url
    ErrorAction        = 'ignore'
  }
  $url = try { Invoke-WebRequest @params | ForEach-Object Headers | ForEach-Object Location } catch { $_.Exception.Response.Headers.Location.OriginalString }
  $url
}

function Get-PostgreVersion([string] $url, [string] $expectedVersion) {
  $uri = $null
  if (![uri]::TryCreate($url, [UriKind]::Absolute, [ref] $uri) -or $uri.Scheme -notin 'http', 'https') {
    throw "Invalid PostgreSQL installer URL: '$url'"
  }

  $fileName = [System.IO.Path]::GetFileName($uri.AbsolutePath)
  if ($fileName -notmatch '^postgresql-(?<Version>\d+(?:\.\d+){1,2})-(?<Revision>\d+)-windows-x64\.exe$') {
    throw "Unable to determine the PostgreSQL version and installer revision from '$url'"
  }

  $version = $Matches.Version
  $revision = $Matches.Revision
  if ($version -ne $expectedVersion) {
    throw "PostgreSQL installer version '$version' does not match download page version '$expectedVersion'"
  }

  # Preserve EDB's installer revision as a numeric Chocolatey version segment.
  "$version.$revision"
}
