$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp = Get-PackageParameters

# Keep the package defaults when an option is omitted.
$options = [ordered]@{
  desktop  = 0
  thumbs   = 0
  group    = 1
  allusers = 1
  assoc    = 1
}

foreach ($name in @('desktop', 'thumbs', 'group', 'allusers', 'currentuser', 'assocallusers')) {
  if ($pp.ContainsKey($name)) {
    # Get-PackageParameters returns $true for a switch without a value.
    $value = $pp[$name]
    if ($value -is [bool]) { $value = [int]$value }
    if ("$value" -notmatch '^[01]$') {
      throw "Package parameter /$name must be 0 or 1, or supplied without a value."
    }
    $pp[$name] = [int]$value
    if ($options.Contains($name)) { $options[$name] = $pp[$name] }
  }
}

if ($pp.ContainsKey('currentuser')) {
  $options.allusers = 1 - $pp.currentuser
}
if ($pp.ContainsKey('assoc')) {
  if ("$($pp.assoc)" -notmatch '^[012]$') {
    throw 'Package parameter /assoc must be 0 (none), 1 (images), or 2 (all).'
  }
  $options.assoc = $pp.assoc
}

$paths = [ordered]@{ ini = '%APPDATA%\IrfanView' }
foreach ($name in @('ini', 'folder')) {
  if ($pp.ContainsKey($name)) {
    if ($pp[$name] -is [bool] -or [string]::IsNullOrWhiteSpace($pp[$name]) -or $pp[$name] -match '["\r\n]') {
      throw "Package parameter /$name requires a folder path without embedded double quotes or newlines."
    }
    $paths[$name] = $pp[$name]
  }
}

$silentArgs = '/silent'
foreach ($option in $options.GetEnumerator()) {
  $silentArgs += " /$($option.Key)=$($option.Value)"
}
if ($pp.assocallusers -eq 1) { $silentArgs += ' /assocallusers' }
foreach ($path in $paths.GetEnumerator()) {
  $silentArgs += ' /{0}="{1}"' -f $path.Key, $path.Value
}
Write-Debug "Silent arguments Chocolatey will use are: $silentArgs"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file          = "$toolsDir\iview476_setup.exe"
  file64        = "$toolsDir\iview476_x64_setup.exe"
  silentArgs     = $silentArgs
  validExitCodes = @(0)
  softwareName   = 'IrfanView*'
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

