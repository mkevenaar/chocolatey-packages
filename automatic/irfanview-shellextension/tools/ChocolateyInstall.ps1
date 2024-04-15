$ErrorActionPreference = 'Stop'

$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$bits = Get-OSArchitectureWidth
$32bitDLL = 'IrfanViewShellExt.dll'
$64bitDLL = 'IrfanViewShellExt64.dll'
$Found = "False"

if (Test-Path $env:ProgramFiles\IrfanView) {
  $Found = "True"
  $ShellDir = "$env:ProgramFiles\IrfanView\Shell Extension"
  if ($bits -eq 64) {
	   $UseDLL = $64bitDLL
	   $DLLDir = '64 bit'
  }
  else {
	   $UseDLL = $32bitDLL
	   $DLLDir = '32 bit'
  }
}
else {
  if (Test-Path "{$env:ProgramFiles(x86)}\IrfanView") {
    $Found = "True"
    $ShellDir = "{$env:ProgramFiles(x86)}\IrfanView\Shell Extension"
    $UseDLL = $32bitDLL
    $DLLDir = '32 bit'
  }
}

if ($Found -eq "True") {
  New-Item $ShellDir -type directory -force | out-null
  Write-Host "Irfanview default install path found!" -foreground green -backgroundcolor blue
}
else {
	 Write-Host "Cannot find IrfanView install location. Aborting." -foreground red -backgroundcolor blue
	 throw
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType      = 'zip'
  file           = "$toolsdir\irfanview_shell_extension.zip"
  validExitCodes = @(0)
}

Get-ChocolateyUnzip  @packageArgs

Copy-Item "$toolsDir\$DLLDir\$UseDLL" -Destination $ShellDir
& regsvr32.exe /s $ShellDir\$UseDLL
Get-ChildItem $toolsPath\*.zip | ForEach-Object { Remove-Item $_ -ea 0; if (Test-Path $_) { Set-Content "$_.ignore" } }
Remove-Item "$toolsDir\32 bit" -recurse | out-null
Remove-Item "$toolsDir\64 bit" -recurse | out-null
Remove-Item "$toolsDir\Readme_first.txt" | out-null
