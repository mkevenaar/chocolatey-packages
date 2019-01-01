$packageName = $env:ChocolateyPackageName
$packageSearch = "Tweaking.com*"
$installerType = 'exe'
$validExitCodes = @(0)

$reg = Get-ItemProperty -Path @( 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' ) `
                        -ErrorAction:SilentlyContinue `
       | Where-Object   { $_.DisplayName -like "$packageSearch" }

$unString = ($reg.UninstallString -Split '\" \"')[0] + '"'
$silentArgs = '"' + ($reg.UninstallString -Split '\" \"')[1] + ' /S'
Start-ChocolateyProcessAsAdmin "& $unString $silentArgs" -ValidExitCodes $validExitCodes
