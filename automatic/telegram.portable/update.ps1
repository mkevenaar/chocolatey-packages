Import-Module Chocolatey-AU

# Reuse release discovery, embedded downloads and verification from the install package.
. $PSScriptRoot\..\telegram.install\update.ps1

function global:au_GetLatest { Get-TelegramRelease -Portable }

if ($MyInvocation.InvocationName -ne '.') {
    Update-Package -ChecksumFor none
}
