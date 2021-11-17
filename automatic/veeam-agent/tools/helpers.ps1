function Test-RegistryValue {

    param (
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Value
    )

    try {
        Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Value -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }

}

function Remove-FileItem {

    param (
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Path
    )

    try {
        Remove-Item `
            -Path $Path `
            -Recurse
        Write-Output `
            -InputObject "Remove $($Path)"
        return $true
    }
    catch {
        Write-Output `
            -InputObject "Failed remove $($Path)"
    }

}

function Update-RegistryValue {

    param (
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Path,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Name,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Value,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Type,
        [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Message
    )

    if(Test-RegistryValue -Path $Path -Value $Name) {
        Set-ItemProperty `
            -Path $Path `
            -Name $Name `
            -Value $Value
        Write-Output `
            -InputObject $Message
    } else {
            New-Item  `
                -Path $Path `
                -Force
            New-ItemProperty `
                -Path $Path `
                -Name $Name `
                -PropertyType $Type `
                -Value $Value
            Write-Output `
                -InputObject $Message
    }

}