$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageDir = "$($toolsDir | Split-Path -parent)"

Get-ChildItem -Path "$packageDir" -filter exiftool-*.txt | Foreach-Object {
  $zipArchive = $_.Name -Match '(?<Archive>^.*zip)' | foreach-object { $Matches.Archive }
  Uninstall-ChocolateyZipPackage 'exiftool' "$zipArchive"
  Remove-Item -Path $_.FullName
}
