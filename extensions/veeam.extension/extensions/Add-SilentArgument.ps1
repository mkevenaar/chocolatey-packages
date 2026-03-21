function Add-SilentArgument {
<#
.SYNOPSIS
  Adds a trimmed installer argument to a buffer when it is non-empty.

.DESCRIPTION
  Ensures a valid buffer is provided, ignores null/whitespace values, trims
  the input, and appends it to the supplied List[string]. Useful when building
  Chocolatey silent argument lists conditionally.

.PARAMETER Buffer
  A System.Collections.Generic.List[string] to append arguments to.

.PARAMETER Value
  The argument text to add when not null or whitespace.

.EXAMPLE
  >
  $silentArgs = New-Object System.Collections.Generic.List[string]
  Add-SilentArgument -Buffer $silentArgs -Value '/qn'
  Add-SilentArgument -Buffer $silentArgs -Value ("INSTALLDIR=`"{0}`"" -f $pp.installDir)

.LINK
  https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersAddSilentArgument.html
#>
  [CmdletBinding(HelpUri='https://mkevenaar.github.io/chocolatey-packages/veeam.extension/HelpersAddSilentArgument.html')]
  param(
    [System.Collections.Generic.List[string]]$Buffer,
    [string]$Value
  )

  if (-not $Buffer) {
    throw "Add-SilentArgument called without a valid buffer."
  }

  if ([string]::IsNullOrWhiteSpace($Value)) {
    return
  }

  $Buffer.Add($Value.Trim())
}
