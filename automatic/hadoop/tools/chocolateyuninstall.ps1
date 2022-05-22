$hadoop_home = $env:HADOOP_HOME

# remove from Path
$path = [Environment]::GetEnvironmentVariable("Path", 'Machine')
$newPath = ($path.Split(';') | Where-Object { $_ -notmatch '.*hadoop.*' }) -join ';'
[Environment]::SetEnvironmentVariable("Path", $newPath, 'Machine')


Install-ChocolateyEnvironmentVariable `
    -VariableName "HADOOP_HOME" `
    -VariableValue $null `
    -VariableType 'Machine'

Install-ChocolateyEnvironmentVariable `
    -VariableName "JAVA_HOME" `
    -VariableValue $null `
    -VariableType 'User'


Remove-Item $hadoop_home -Recurse -Force
