$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

# The setup has MinVersion=10.0.19041 and exits with code 1 without a message on older systems.
if ([Environment]::OSVersion.Version -lt [Version]'10.0.19041') {
  throw "SuperPuTTY Community Edition requires Windows 10 version 2004 (build 19041) / Windows Server 2022 or later. This system is $([Environment]::OSVersion.Version)."
}

$logFile  = "$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).InnoInstall.log"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  file64         = "$toolsDir\SuperPuTTY-CE-1.8.5-setup-win-x64.exe"
  silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /ALLUSERS /LOG=`"$logFile`""
  softwareName   = 'SuperPuTTY Community Edition*'
  validExitCodes = @(0)
}

try {
  Install-ChocolateyInstallPackage @packageArgs
}
catch {
  if ((Test-Path -LiteralPath $logFile) -and (Select-String -Path $logFile -Pattern 'SPCE_MIGRATION_REQUIRED' -Quiet)) {
    throw ("An existing SuperPuTTY MSI installation was detected. SuperPuTTY Community Edition cannot upgrade it automatically. " +
      "Back up %USERPROFILE%\SuperPuTTY.settings and your sessions/layouts folder, uninstall the MSI version " +
      "(Settings > Apps), then run this install again. " +
      "See https://github.com/greyhair-atx/superputty/blob/master/docs/manual/upgrading.md. Setup log: $logFile")
  }
  throw
}
finally {
  Get-ChildItem -Path "$toolsDir\*.exe" | ForEach-Object { Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue; if (Test-Path -LiteralPath $_.FullName) { Set-Content -Path "$($_.FullName).ignore" -Value '' } }
}
