$packageName        = $env:ChocolateyPackageName
$installerType      = 'exe'
$silentArgs         = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
$url                = 'https://www.ultraiso.com/uiso9_pe.exe'
$checksum           = 'E4B6A512B686BCD7EBD7297E6A991DA0A9A4B3367A08333A655A9FADA5723A04'
$checksumType       = 'sha256'
$validExitCodes     = @(0)

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"