$ErrorActionPreference = "Stop"

$pp = Get-PackageParameters
if(!$pp.Password) {
    $pp.Password = [guid]::NewGuid().ToString("N")
    Write-Warning "You did not specify a password for the postgres user so an insecure one has been generated for you. Please change it immediately."
    Write-Warning "Generated password: $($pp.Password)"
}

$silentArgs = @{
    Mode                = "unattended"
    UnattendedModeUI    = "none"
    SuperPassword       = $pp.Password
    Enable_ACLedit      = 1
    Install_Runtimes    = 0
}
if ($pp.Port) { Write-Host "Using port: $($pp.Port)"; $silentArgs.ServerPort = $pp.Port }

$packageArgs = @{
    packageName     = $Env:ChocolateyPackageName
    fileType        = 'exe'
    url64           = 'https://get.enterprisedb.com/postgresql/postgresql-19.0-2-windows-x64.exe'
    checksum64      = 'FBED8EF8EDB2870F2FAF6EACAB927E633ABA8FF501D52AFE03846B058EA3C00E'
    checksumType64  = 'sha256'
    url             = ''
    checksum        = ''
    checksumType32  = 'sha256'
    silentArgs      =  ($silentArgs.Keys | ForEach-Object { "--{0} {1}" -f $_.Tolower(), $silentArgs.$_}) -join ' '
    validExitCodes  = @(0)
    softwareName    = 'PostgreSQL 19*'
}
Install-ChocolateyPackage @packageArgs
Write-Host "Installation log: $Env:TEMP\install-postgresql.log"

$installLocation = Get-AppInstallLocation $packageArgs.softwareName
if (!$installLocation)  { Write-Warning "Can't find install location"; return }
Write-Host "Installed to '$installLocation'"

if (!$pp.NoPath) { Install-ChocolateyPath "$installLocation\bin" -PathType 'Machine' }

if ($pp.AllowRemote) {
    Write-Host "Allowing remote connections"
"
# Added by Chocolatey package
host    all             all             0.0.0.0/0               md5
host    all             all             ::0/0                   md5
" | Out-File -Append "$installLocation\data\pg_hba.conf" -Encoding ascii
}
