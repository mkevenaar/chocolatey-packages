function Resolve-PsqlUrl([string] $url) {
  if ($url -match '-windows-x64-binaries\.zip(?:\?|$)') { return $url }

  $params = @{
    MaximumRedirection = 0
    Uri                = $url
    Method             = 'Head'
    UseBasicParsing    = $true
    ErrorAction        = 'ignore'
  }
  $url = try {
    Invoke-WebRequest @params | ForEach-Object Headers | ForEach-Object Location
  } catch {
    if (!$_.Exception.Response) { throw }
    $_.Exception.Response.Headers.Location
  }
  if (!$url) { throw 'Unable to resolve the EDB binary download URL' }
  [string] $url
}

function Get-PsqlVersion([string] $url, [string] $expectedVersion) {
  $uri = $null
  if (![uri]::TryCreate($url, [UriKind]::Absolute, [ref] $uri) -or $uri.Scheme -ne 'https') {
    throw "Invalid PostgreSQL binary URL: '$url'"
  }

  $fileName = [System.IO.Path]::GetFileName($uri.AbsolutePath)
  if ($fileName -notmatch '^postgresql-(?<Version>\d+\.\d+)-(?<Revision>\d+)-windows-x64-binaries\.zip$') {
    throw "Unable to determine the PostgreSQL binary version and revision from '$url'"
  }

  $version = $Matches.Version
  $revision = $Matches.Revision
  if ($version -ne $expectedVersion) {
    throw "PostgreSQL binary version '$version' does not match download page version '$expectedVersion'"
  }

  # Match postgresql's numeric package version, including the EDB build revision.
  "$version.$revision"
}
