$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  packageName    = 'telegram.install'
  fileType       = 'exe'
  file           = "$toolsPath\td-setup-win-x86-7.2.9_x32.exe"
  file64         = "$toolsPath\td-setup-win-x64-7.2.9_x64.exe"
  silentArgs     = '/Verysilent'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs
Get-ChildItem -Path $toolsPath -Filter '*.exe' | ForEach-Object {
  Remove-Item -LiteralPath $_.FullName -ErrorAction SilentlyContinue
  if (Test-Path -LiteralPath $_.FullName) {
    Set-Content -LiteralPath "$($_.FullName).ignore" -Value ''
  }
}

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

Register-Application "$installLocation\$packageName.exe"
Write-Host "$packageName registered as $packageName"
