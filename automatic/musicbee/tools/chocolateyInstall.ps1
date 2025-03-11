$ErrorActionPreference = 'Stop';

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$downloadArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  file          = "xxx"
}

Get-ChocolateyUnzip @downloadArgs

$fileLocation = (Get-ChildItem $toolsDir -Filter *.exe | Select-Object -First 1).FullName

$installArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'MusicBee*'
  file          = $fileLocation
  fileType      = 'exe'
  silentArgs    = "/S"
  validExitCodes= @(0)
  destination   = $toolsDir
}

Install-ChocolateyInstallPackage @installArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content -Value "" -Path "$_.ignore" }}
