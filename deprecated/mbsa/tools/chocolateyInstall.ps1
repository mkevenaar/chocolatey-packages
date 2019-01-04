$packageName = 'mbsa'
$installerType = 'msi'
$url = 'https://download.microsoft.com/download/8/E/1/8E16A4C7-DD28-4368-A83A-282C82FC212A/MBSASetup-x86-EN.msi'
$checksum = '2092b91d03d6d4a2b07b6dd25974f35ee5c7b1cf'
$checksumType = 'sha1'
$url64 = 'https://download.microsoft.com/download/8/E/1/8E16A4C7-DD28-4368-A83A-282C82FC212A/MBSASetup-x64-EN.msi'
$checksum64 = 'de4a9df45ac40dd901c956edfe2f766d2bfddc92'
$checksumType64 = 'sha1'
$silentArgs = '/quiet /qn /norestart'
$validExitCodes = @(0,3010)  # http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -Url "$url" `
                          -Url64bit "$url64" `
                          -SilentArgs "$silentArgs" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType" `
                          -Checksum64 "$checksum64" `
                          -ChecksumType64 "$checksumType64"