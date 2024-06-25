$ErrorActionPreference = 'Stop';

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'GrafanaOSS*'
  fileType       = 'msi'
  silentArgs     = "/qn /norestart /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  file           = "$toolsdir\grafana-11.0.1.windows-amd64.msi"
  validExitCodes = @(0,1641,3010)
}

Write-Verbose "Downloading and installing program..."
Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsPath\*.msi | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
