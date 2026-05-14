$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$is64 = (Get-OSArchitectureWidth 64) -and $env:chocolateyForceX86 -ne 'true'

$packageArgs = @{
  packageName   = $Env:ChocolateyPackageName
  url           = 'https://download.cpuid.com/cpu-z/cpu-z_2.20-en.zip'
  checksum      = '7a4addc89744b9b198d2e721882b7eccf6f9a0c8ff8ed172f1ddddf49ca7a219'
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
