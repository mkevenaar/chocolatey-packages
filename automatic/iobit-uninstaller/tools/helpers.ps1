function GetProc($proc) {
    Get-Process -Name $proc -ErrorAction 0
}
function GetServ($Service) {
    Get-Service -DisplayName $Service -ErrorAction 0
}

function Close-Iobit {
    $MainProc = 'IObitUninstaler'
    $OtherProcs = @( 'IUService', 'iush', 'UninstallMonitor', 'AUpdate',
                     'AutoUpdate', 'CrRestore', 'DPMRCTips', 'DSPut',
                     'DataRecoveryTips', 'Feedback', 'IObitDownloader',
                     'IUProtip', 'NoteIcon', 'PPUninstaller', 'ScreenShot',
                     'SendBugReportNew', 'SpecUTool', 'UninstallPromote',
                     'cbtntips')
    GetProc $MainProc | ForEach-Object { $_.CloseMainWindow() | Out-Null }
    Start-Sleep 1
    GetProc $MainProc |             Stop-Process -Force
    GetServ "Iobit Uninstaller*" |  Stop-Service -Force
    foreach( $Proccess in $OtherProcs){
        GetProc $Proccess | Stop-Process -Force
    }
}
function Get-MergeTasks([hashtable] $pp) {
    $tasks = @()
    $tasks += '!'* $pp.NoDesktopIcon     + 'desktopicon'

    Write-Host "Merge Tasks: $tasks"
    return $tasks -join ','
}
