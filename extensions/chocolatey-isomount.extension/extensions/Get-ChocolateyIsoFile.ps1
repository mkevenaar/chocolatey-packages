function Get-ChocolateyIsoFile {
<#
.SYNOPSIS
    Copies a single file from an ISO to a destination on disk.

.DESCRIPTION
    Mounts the specified ISO using built-in PowerShell cmdlets, selects the
    appropriate 32-bit or 64-bit file path, and copies that file to the
    destination. This does not rely on 7-Zip or any other external tooling.

.NOTES
    This command will assert UAC/Admin privileges on the machine because it
    uses Mount-DiskImage.

.PARAMETER IsoFile
    Full path to the ISO file to mount.

.PARAMETER FilePath
    Relative path of the file inside the ISO to copy for 32-bit systems.

.PARAMETER FilePath64
    Relative path of the file inside the ISO to copy for 64-bit systems.
    If provided on a 64-bit system, this file is used instead of FilePath.

.PARAMETER Destination
    Path to copy the file to. If this points to an existing directory (or
    ends with a path separator), the file name from FilePath is used.

.PARAMETER PackageName
    OPTIONAL - Used to log the copied file path alongside other Chocolatey
    package activity.

.PARAMETER DisableLogging
    OPTIONAL - Disables logging of the copied file.

.PARAMETER IgnoredArguments
    Allows splatting with arguments that do not apply. Do not use directly.

.OUTPUTS
    Returns the destination path of the copied file.

.EXAMPLE
    >
    $toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
    Get-ChocolateyIsoFile -IsoFile "$toolsDir\\image.iso" `
                          -FilePath 'setup.msi' `
                          -Destination $toolsDir

.LINK
    https://mkevenaar.github.io/chocolatey-packages/chocolatey-isomount.extension/HelpersGetChocolateyIsoFile.html
#>
    [CmdletBinding(HelpUri='https://mkevenaar.github.io/chocolatey-packages/chocolatey-isomount.extension/HelpersGetChocolateyIsoFile.html')]
    param(
        [parameter(Mandatory=$true, Position=0)][string] $isoFile,
        [alias("file")][parameter(Mandatory=$true, Position=1)][string] $filePath,
        [alias("destinationPath")][parameter(Mandatory=$true, Position=2)][string] $destination,
        [alias("file64")][parameter(Mandatory=$false)][string] $filePath64,
        [parameter(Mandatory=$false, Position=3)][string] $packageName,
        [parameter(Mandatory=$false)][switch] $disableLogging,
        [parameter(ValueFromRemainingArguments = $true)][Object[]] $ignoredArguments
    )
    # POSH3 is required for `Mount-DiskImage`
    if ($PSVersionTable.PSVersion -lt (New-Object 'Version' 3,0)) {
        throw 'This function requires PowerShell 3 or higher'
    }

    Write-FunctionCallLogMessage -Invocation $MyInvocation -Parameters $PSBoundParameters

    $bitnessMessage = ''
    $targetFilePath = $filePath
    if ((Get-OSArchitectureWidth 32) -or $env:ChocolateyForceX86 -eq 'true') {
        if (!$filePath) {
            throw "32-bit file path is not supported for $packageName"
        }
        if ($filePath64) {
            $bitnessMessage = '32-bit '
        }
    }
    elseif ($filePath64) {
        $targetFilePath = $filePath64
        $bitnessMessage = '64-bit '
    }

    if ([string]::IsNullOrWhiteSpace($targetFilePath)) {
        throw 'Package parameters incorrect, either FilePath or FilePath64 must be specified.'
    }

    if (-not (Test-Path -LiteralPath $isoFile -PathType Leaf)) {
        throw "ISO file not found at '$isoFile'."
    }

    $mountResult = $null
    try {
        $mountResult = Mount-DiskImage -ImagePath $isoFile -StorageType ISO -PassThru -ErrorAction Stop
        $isoVolume = $mountResult | Get-Volume -ErrorAction Stop | Where-Object { $_.DriveLetter } | Select-Object -First 1
        if (-not $isoVolume) {
            throw "Unable to determine drive letter for mounted ISO '$isoFile'."
        }

        $isoDrive = "$($isoVolume.DriveLetter):"
        $sourcePath = Join-Path $isoDrive $targetFilePath

        if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
            throw "File '$targetFilePath' not found in ISO '$isoFile'."
        }

        $destinationPath = $destination
        $destinationIsDirectory = $false
        try {
            $destinationIsDirectory = Test-Path -LiteralPath $destination -PathType Container -ErrorAction Stop
        }
        catch {
            $destinationIsDirectory = $false
        }

        if ($destinationIsDirectory -or $destination.EndsWith('\') -or $destination.EndsWith('/')) {
            if (-not $destinationIsDirectory) {
                New-Item -ItemType Directory -Path $destination -Force | Out-Null
            }
            $destinationPath = Join-Path $destination (Split-Path $targetFilePath -Leaf)
        }
        else {
            $destinationDirectory = Split-Path $destinationPath -Parent
            if (![string]::IsNullOrWhiteSpace($destinationDirectory) -and -not (Test-Path -LiteralPath $destinationDirectory -PathType Container)) {
                New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null
            }
        }

        Write-Host "Copying ${bitnessMessage}${sourcePath} to $destinationPath..."
        Copy-Item -LiteralPath $sourcePath -Destination $destinationPath -Force -ErrorAction Stop

        if ($packageName -and -not $disableLogging) {
            $packagelibPath = $env:ChocolateyPackageFolder
            if (!(Test-Path -LiteralPath $packagelibPath)) {
                New-Item $packagelibPath -ItemType Directory -Force | Out-Null
            }

            $isoFilename = Split-Path $isoFile -Leaf
            $extractLogFullPath = Join-Path $packagelibPath "$isoFilename.txt"
            Set-Content $extractLogFullPath $destinationPath -Encoding UTF8 -Force
        }

        $env:ChocolateyPackageInstallLocation = Split-Path $destinationPath -Parent
        return $destinationPath
    }
    finally {
        if ($mountResult) {
            Dismount-DiskImage -ImagePath $isoFile -ErrorAction SilentlyContinue | Out-Null
        }
    }
}
