# Share release discovery and search/replace rules with the installer package.
. $PSScriptRoot\..\windowsrepair.install\update.ps1

function global:au_GetLatest {
    Get-WindowsRepairLatest -Portable
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor 32
}
