Import-Module Chocolatey-AU

function global:au_SearchReplace {
  @{}
}

function global:au_GetLatest {
    return @{
        Version = '6.0.0'
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}
