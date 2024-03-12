param(
  [Parameter(Mandatory = $true)]
  [string]$OldDependencyName,
  [string]$NewDependencyName = $OldDependencyName,
  [string]$Version = $null
)

if (!($Version)) {
  $nuspecFile = Get-ChildItem -Path "$PSScriptRoot/../" -Include "$NewDependencyName.nuspec" -Recurse

  if (!($nuspecFile)) {
    # Lets check with choco
    $Version = ((choco search $NewDependencyName -r | Select-Object -First 1) | Where-Object { $_ -match "^$NewDependencyName\|" }) -split '\|' | Select-Object -Last 1
  } else {
    Get-Content $nuspecFile.FullName | Where-Object { $_ -match "\<version\>(.+)\<\/version\>" } | Out-Null
    $Version = $Matches[1]
    if ($Version -eq "{{PackageVersion}}") {
      $Version = ((choco info $NewDependencyName -r) | Where-Object { $_ -match "^$NewDependencyName\|" }) -split '\|' | Select-Object -Last 1
    }
  }

  if (!($Version)) {
    Write-Error "Unable to get version for $NewDependencyName"
    return
  }
}

$re = "\<dependency\s*id=`"$OldDependencyName`"(\s*version=`".+`")?"
$versionRe = "\<dependency\s*id=`"$NewDependencyName`"\s*version=`"$Version`""

$filesWithDependency = Get-ChildItem -Path "$PSScriptRoot/../" -Include "*.nuspec" -Recurse | Where-Object { Get-Content $_.FullName | Where-Object { $_ -match $re -and $_ -notmatch $versionRe } } | Select-Object -expand FullName

$encoding = New-Object System.Text.UTF8Encoding($false)

foreach ($file in $filesWithDependency) {
  $content = [System.IO.File]::ReadAllLines($file, $encoding)
  $content = $content -replace "$re", "`<dependency id=`"$NewDependencyName`" version=`"$Version`"" -replace '\t', '  '
  [System.IO.File]::WriteAllText($file, "$($content -join "`n")`n", $encoding)
  Write-Verbose "Updated $NewDependencyName version in $($file -split '\\' | Select-Object -Last 1)"
}

$encoding = $null
