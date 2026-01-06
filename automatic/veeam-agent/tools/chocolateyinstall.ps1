$ErrorActionPreference = 'Stop';
$PackageParameters = Get-PackageParameters
$Version      = '13.0.1.1009'

$toolsDir     = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$url          = 'https://download5.veeam.com/VAW/v13/VeeamAgentWindows_13.0.1.1009.zip'
$checksum     = '0607d457f8f2fa13abad212cdbbd213dbeab63119af0fab3a5f66d59eff4efe2'
$checksumType = 'sha256'

Import-Module -Name "$($toolsDir)\helpers.ps1"

$zipArgs = @{
    packageName   = $env:ChocolateyPackageName
    url           = $url
    unzipLocation = $ENV:TMP
    checksum      = $checksum
    checksumType  = $checksumType
}

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    fileType       = 'EXE'
    file           = "$($ENV:TMP)\VeeamAgentWindows_$($Version).exe"
    silentArgs     = '/silent /accepteula /acceptthirdpartylicenses /acceptlicensingpolicy /acceptrequiredsoftware'
    validExitCodes = @(0, 1000, 1101)
}

Install-ChocolateyZipPackage @zipArgs

Install-ChocolateyInstallPackage @packageArgs

if ($PackageParameters.NoAutostartHard) {
    Update-RegistryValue `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" `
        -Name "Veeam.EndPoint.Tray.exe" `
        -Type Binary `
        -Value ([byte[]](0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)) `
        -Message "Disable Veeam Agent Autostart"
}
else {
    Update-RegistryValue `
        -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" `
        -Name "Veeam.EndPoint.Tray.exe" `
        -Type Binary `
        -Value ([byte[]](0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)) `
        -Message "Default Veeam Agent Autostart"
}

if ($PackageParameters.CleanStartmenu) {
    Remove-FileItem `
        -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Veeam\"
    Install-ChocolateyShortcut `
        -ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Veeam Agent.lnk" `
        -TargetPath "C:\Program Files\Veeam\Endpoint Backup\Veeam.EndPoint.Tray.exe"
    Install-ChocolateyShortcut `
        -ShortcutFilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Veeam File Level Restore.lnk" `
        -TargetPath "C:\Program Files\Veeam\Endpoint Backup\Veeam.EndPoint.FLR.exe"
}
