$allDeps = @(
  'chocolatey-core.extension'
  'autohotkey.portable'
  'jre8'
  'kb2999226'
  'kb3033929'
  'kb3035131'
  'vcredist2012'
  'vcredist2015'
  'vcredist140'
  'dotnet4.0'
  'dotnet4.5'
  'dotnet4.5.1'
  'dotnet4.5.2'
  'dotnet4.6'
  'dotnet4.6.1'
  'dotnet4.6.2'
  'dotnet4.7'
)# | ForEach-Object {
# "Updating version for dependency $_..."
# . $PSScriptRoot\Update-Dependency.ps1 $_
#}

$foundDeps = . choco search $allDeps -r | ConvertFrom-Csv -Delimiter '|' -Header 'id', 'version'

$allDeps | ForEach-Object {
  "Updating version for dependency $_..."
  $dependency = $foundDeps | Where-Object id -EQ $_ | Select-Object -First 1
  . $PSScriptRoot\Update-Dependency.ps1 $_ -Version $dependency.version
}

# Convert and update other references
@{
  'chocolatey-uninstall.extension' = 'chocolatey-core.extension'
  'vcredist2017'                   = 'vcredist140'
}.GetEnumerator() | ForEach-Object {
  "Changing dependency from $($_.Key) to $($_.Value) and using latest version..."
  $dependency = $foundDeps | Where-Object id -EQ $_.Value | Select-Object -First 1
  if ($dependency) {
    . $PSScriptRoot\Update-Dependency.ps1 -OldDependencyName $_.Key -NewDependencyName $_.Value -Version $dependency.version
  } else {
    . $PSScriptRoot\Update-Dependency.ps1 -OldDependencyName $_.Key -NewDependencyName $_.Value
  }
}
