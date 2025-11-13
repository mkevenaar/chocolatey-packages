$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Default values
$desktop = 0
$thumbs = 0
$group = 1
$allusers = 1
$assoc = 1
$ini = "%APPDATA%\IrfanView"
$folder = $null

$packageParameters = $env:chocolateyPackageParameters

if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+))=(?<value>([`"'])?([a-zA-Z0-9- _\\:%\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | ForEach-Object {
          $arguments.Add(
              $_.Groups[$option_name].Value.Trim(),
              $_.Groups[$value_name].Value.Trim())
      }
    } else {
        Throw "Package Parameters were found but were invalid (REGEX failure)"
    }

    if ($arguments.ContainsKey("desktop")) {
        Write-Verbose "Adding desktop shortcut to IrfanView"
        $desktop = 1
    }

    if ($arguments.ContainsKey("thumbs")) {
        Write-Verbose "Adding desktop shortcut to IrfanView Thumbnails"
        $thumbs = 1
    }

    if ($arguments.ContainsKey("group")) {
        Write-Verbose "Adding IrfanView group to start menu"
        $group = 1
    }

    if ($arguments.ContainsKey("allusers")) {
        Write-Verbose "Installing IrfanView for only current user"
        $allusers = 0
    }

    if ($arguments.ContainsKey("assoc")) {
        Write-Verbose "Associating IrfanView to file types"
        $assoc = $arguments["assoc"]
    }

    if ($arguments.ContainsKey("ini")) {
        Write-Verbose "You want to use a custom configuration Path"
        $ini = $arguments["ini"]
    }

    if ($arguments.ContainsKey("folder")) {
        Write-Verbose "You want to use a custom configuration Path"
        $folder = $arguments["folder"]
    }

} else {
    Write-Debug "No package parameters passed in"
}

$silentArgs = "/silent" +
              " /desktop=" + $desktop +
              " /thumbs=" + $thumbs +
              " /group=" + $group +
              " /allusers=" + $allusers +
              " /assoc=" + $assoc
if ($ini) { $silentArgs += " /ini=" + $ini }
if ($folder) { $silentArgs += " /folder=" + $folder }
Write-Debug "Silent arguments Chocolatey will use are: $silentArgs"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file          = "$toolsDir\iview473_setup.exe"
  file64        = "$toolsDir\iview473_x64_setup.exe"
  silentArgs     = $silentArgs
  validExitCodes = @(0)
  softwareName   = 'IrfanView*'
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }

