$packageName = '{{PackageName}}'
$packageSearch = "MariaDB *"
$installerType = 'msi'
$silentArgs = '/quiet /qn /norestart'
$validExitCodes = @(0,3010)
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$unPath = Join-Path $toolsPath 'Uninstall-ChocolateyPath.psm1'

Write-Verbose "Querying registry for install key..."
$regKey = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                   'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                   'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
                           -ErrorAction:SilentlyContinue `
          | Where-Object {$_.DisplayName -like $packageSearch}

Write-Verbose "Uninstalling program and removing package..."
$regKey | ForEach-Object {
  Uninstall-ChocolateyPackage -PackageName "$packageName" `
                              -FileType "$installerType" `
                              -SilentArgs "$($_.PSChildName) $silentArgs" `
                              -ValidExitCodes $validExitCodes
}

Write-Verbose "Removing from path..."
$binPath = Join-Path $regKey.InstallLocation "bin"
Import-Module $unPath
Uninstall-ChocolateyPath $binPath 'Machine' 