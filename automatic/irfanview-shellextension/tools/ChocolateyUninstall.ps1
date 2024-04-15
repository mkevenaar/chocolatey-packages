$FoundDLL = "False"

if (Test-Path "$Env:ProgramFiles\IrfanView\Shell Extension\IrfanViewShellExt64.dll") {
  $FoundDLL = "True"
  $RemoveDLL = "$Env:ProgramFiles\IrfanView\Shell Extension\IrfanViewShellExt64.dll"
}
if (Test-Path "$Env:ProgramFiles\IrfanView\Shell Extension\IrfanViewShellExt.dll") {
  $FoundDLL = "True"
  $RemoveDLL = "$Env:ProgramFiles\IrfanView\Shell Extension\IrfanViewShellExt.dll"
}
if (Test-Path "{$Env:ProgramFiles(x86)}\IrfanView\Shell Extension\IrfanViewShellExt.dll") {
  $FoundDLL = "True"
  $RemoveDLL = "{$Env:ProgramFiles(x86)}\IrfanView\Shell Extension\IrfanViewShellExt.dll"
}
if ($FoundDLL -eq "True") {
  & regsvr32.exe /s /u $RemoveDLL
  Remove-Item $RemoveDLL -Force -ErrorAction 'SilentlyContinue' | out-null
}
else {
  Write-Host "Irfanview Shell Extension not found! Sorry, I tried the normal places." -foreground red -backgroundcolor blue
}
