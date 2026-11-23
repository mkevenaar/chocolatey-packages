$ErrorActionPreference = "Stop"

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

if (!(Get-OSArchitectureWidth -Compare 64)) { throw 'psql requires 64-bit Windows.' }

$packageArgs = @{
  PackageName     = $Env:ChocolateyPackageName
  Url64           = 'https://get.enterprisedb.com/postgresql/postgresql-19.0-2-windows-x64-binaries.zip'
  Checksum64      = 'A8F9CF38F72C403F31BF3EF9DB0C441924FAE0CADA0D61850AFA590D5ECA55A1'
  ChecksumType64  = 'sha256'
  UnzipLocation   = $toolsDir
  SpecificFolder  = 'pgsql/bin'
}

Install-ChocolateyZipPackage @packageArgs

# Keep the client commands and the DLLs supplied with this release. DLL names
# change between PostgreSQL majors and EDB rebuilds.
$files = @(
  'psql.exe'
  'pg_dump.exe'
  'pg_dumpall.exe'
  'pg_restore.exe'
)

$extractedDir = [System.IO.Path]::GetFullPath((Join-Path $toolsDir 'pgsql'))
$toolsRoot = [System.IO.Path]::GetFullPath($toolsDir).TrimEnd('\') + '\'
if (!$extractedDir.StartsWith($toolsRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw 'The extracted PostgreSQL directory must be inside the package tools directory.'
}
$binDir = Join-Path $extractedDir 'bin'
foreach ($file in $files) {
  if (!(Test-Path -LiteralPath (Join-Path $binDir $file) -PathType Leaf)) {
    throw "The PostgreSQL archive is missing $file"
  }
}

# Remove DLLs from the previous release before replacing the client files.
Get-ChildItem -LiteralPath $toolsDir -Filter '*.dll' -File | Remove-Item -Force
Get-ChildItem -LiteralPath $binDir -File | Where-Object {
  $_.Name -in $files -or $_.Extension -eq '.dll'
} | ForEach-Object { Move-Item -LiteralPath $_.FullName -Destination $toolsDir -Force }
Remove-Item -LiteralPath $extractedDir -Recurse -Force
