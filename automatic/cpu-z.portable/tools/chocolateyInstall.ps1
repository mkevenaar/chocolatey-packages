$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$is64 = (Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne 'true'

$packageArgs = @{
  packageName   = $Env:ChocolateyPackageName
  url           = 'https://download.cpuid.com/cpu-z/cpu-z_2.20.1-en.zip'
  checksum      = '8a277400c04cef3950c77f1c944e31e2d0caa3e6b7b957ad7dd25ecbf43e169e'
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
