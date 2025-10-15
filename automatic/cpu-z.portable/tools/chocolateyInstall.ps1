$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$is64 = (Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne 'true'

$packageArgs = @{
  packageName   = $Env:ChocolateyPackageName
  url           = 'https://download.cpuid.com/cpu-z/cpu-z_2.17-en.zip'
  checksum      = 'aa4d68627d441804ce5b6abe23ae630aee9e0492a69140aeec79da62c45c5215'
  checksumType  = 'sha256'
  unzipLocation = $toolsPath
}

Install-ChocolateyZipPackage @packageArgs

if ($is64) {
  Remove-Item $toolsPath\cpuz_x32.exe
  Move-Item -force $toolsPath\cpuz_x64.exe $toolsPath\cpuz.exe
}
else {
  Remove-Item $toolsPath\cpuz_x64.exe
  Move-Item -force $toolsPath\cpuz_x32.exe $toolsPath\cpuz.exe
}

# create empty sidecar so shimgen creates shim for GUI rather than console
Set-Content -Path (Join-Path $toolsPath "cpuz.exe.gui") -Value $null

Write-Host "$packageName installed to $toolsPath"
