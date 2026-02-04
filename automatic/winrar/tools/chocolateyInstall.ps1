$ErrorActionPreference = 'Stop';
$toolsDir       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
. $toolsPath\helpers.ps1

$LCID = (Get-UICulture).LCID
$url_version = '720'

$checksumType64 = 'sha256'

$pp = Get-PackageParameters
if ($pp.LCID) {
  Write-Debug "Override local language settings."
  $LCID = $pp.LCID
}
if ($pp.English) {
    Write-Debug "Force install English version"
    $LCID = $null
}

#LCID table: https://msdn.microsoft.com/goglobal/bb964664.aspx
##Arabic - Saudi Arabia  1025
##Arabic - Algeria	5121
##Arabic - Bahrain	15361
##Arabic - Egypt	3073
##Arabic - Iraq		2049
##Arabic - Jordan	11265
##Arabic - Kuwait	13313
##Arabic - Lebanon	12289
##Arabic - Libya	4097
##Arabic - Morocco	6145
##Arabic - Oman		8193
##Arabic - Qatar	16385
##Arabic - Syria	10241
##Arabic - Tunisia	7169
##Arabic - U.A.E.	14337
##Arabic - Yemen	9217
if(($LCID -eq "1025") -or ($LCID -eq "5121") -or ($LCID -eq "15361") -or ($LCID -eq "3073") -or ($LCID -eq "2049") -or ($LCID -eq "11265") -or ($LCID -eq "13313") -or ($LCID -eq "12289") -or ($LCID -eq "4097") -or ($LCID -eq "6145") -or ($LCID -eq "8193") -or ($LCID -eq "16385") -or ($LCID -eq "10241") -or ($LCID -eq "7169") -or ($LCID -eq "14337") -or ($LCID -eq "9271")){
  $code = "ar"
}

##Armenian   1067
elseif($LCID -eq "1067"){
  $code = 'am'
}

##AAzeri (Cyrillic)   2092
##AAzeri (Latin)      1068
elseif(($LCID -eq "2092") -or ($LCID -eq "1068")){
  $code = 'az'
}

##Belarusian   1059
elseif($LCID -eq "1059"){
  $code = 'by'
}

##Bulgarian   1026
elseif($LCID -eq "1026"){
  $code = 'bg'
}

##Catalan   1027
elseif($LCID -eq "1027"){
  $code = 'by'
}

##Chinese - People's Republic of China 	 2052
##Chinese - Singapore					 4100
##Chinese - Hong Kong SAR	             3076
##Chinese - Macao SAR					 5124
elseif(($LCID -eq "2052") -or ($LCID -eq "4100") -or ($LCID -eq "3076") -or ($LCID -eq "5124")){
   $code = 'sc'
}

##Chinese - Taiwan					1028
elseif($LCID -eq "1028"){
  $code = 'tc'
}

##Croatian				          1050
##Croatian (Bosnia/Herzegovina)   4122
elseif(($LCID -eq "1050") -or ($LCID -eq "4122")){
  $code = 'cro'
}

##Czech   1029
elseif($LCID -eq "1029"){
      $code = 'cz'
}

##Danish   1030
elseif($LCID -eq "1030"){
  $code = 'dk'
}

##Dutch - Netherlands		1043
##Dutch - Belgium			2067
elseif(($LCID -eq "1043") -or ($LCID -eq "2067")){
  $code = 'nl'
}

##Estonian			1061
elseif($LCID -eq "1061"){
  $code = 'est'
}

##Finnish			1035
elseif($LCID -eq "1035"){
  $code = 'fi'
}

##French			1036
elseif($LCID -eq "1036"){
  $code = 'fr'
}

##Galician			1110
elseif($LCID -eq "1110"){
  $code = 'gl'
}

##Georgian			1079
elseif($LCID -eq "1079"){
  $code = 'ge'
}

##German			1031
elseif($LCID -eq "1031"){
  $code = 'd'
}

##Greek				1032
elseif($LCID -eq "1032"){
  $code = 'el'
}

##Hebrew			1037
elseif($LCID -eq "1037"){
  $code = 'he'
}

##Hungarian			1038
elseif($LCID -eq "1038"){
  $code = 'hu'
}

##Indonesian		1057
elseif($LCID -eq "1057"){
  $code = 'id'
}

##Italian - Italy			1040
##Italian - Switzerland		2064
elseif(($LCID -eq "1040") -or ($LCID -eq "2064")){
  $code = 'it'
}

##Japanese		1041
elseif($LCID -eq "1041"){
  $code = 'jp'
}

##Korean		1042
elseif($LCID -eq "1042"){
  $code = 'kr'
}

##Lithuanian	1063
elseif($LCID -eq "1063"){
  $code = 'lt'
}

##Macedonian											0047
##Macedonian (Former Yugoslav Republic of Macedonia)	1071
elseif(($LCID -eq "0047") -or ($LCID -eq "1071")){
  $code = 'mk'
}

##Norwegian (Bokmål)		1044
##Norwegian (Nynorsk)		2068
elseif(($LCID -eq "1044") -or ($LCID -eq "2068")){
  $code = 'no'
}

##Persian		0041
##Persian Iran	1065
elseif(($LCID -eq "0041") -or ($LCID -eq "1065")){
  $code = 'prs'
}

##Polish		1045
elseif($LCID -eq "1045"){
  $code = 'pl'
}

##Portuguese - Portugal
##Portuguese - Portugal 2070  (pt-pt)
elseif($LCID -eq "2070"){
  $code = 'pt'
}

##Portuguese - Brazil
##Portuguese - Brazil  1046   (pt-br)
elseif($LCID -eq "1046"){
  $code = 'br'
}

##Romanian			1048
##Romanian Moldava  2072
elseif(($LCID -eq "1048") -or ($LCID -eq "2072")){
  $code = 'ro'
}

##Russian (ru-ru)			1049
##Russian-Moldava (ru-mo)	2073
elseif(($LCID -eq "1049") -or ($LCID -eq "2073")){
  $code = 'ru'
}

##Serbian Cyrillic	3098
elseif($LCID -eq "3098"){
  $code = 'srbcyr'
}

##Serbian Latin		2074
elseif($LCID -eq "2074"){
  $code = 'srblat'
}

##Sinhala			1115
elseif($LCID -eq "1115"){
  $code = 'si'
}

##Slovak			1051
elseif($LCID -eq "1051"){
  $code = 'sk'
}

##Slovenian			1060
elseif($LCID -eq "1060"){
  $code = 'slv'
}

##Spanish - Spain (Modern Sort)			3082
##Spanish - Spain (Traditional Sort)    1034   (es-es)
##Spanish - Argentina   				11274
##Spanish - Bolivia   					16394
##Spanish - Chile   					13322
##Spanish - Colombia   					9226
##Spanish - Costa Rica  			 	5130
##Spanish - Dominican Republic  	 	7178
##Spanish - Ecuador  				 	12298
##Spanish - El Salvador  			 	17418
##Spanish - Guatemala  				 	4106
##Spanish - Honduras   					18442
##Spanish - Latin America 				22538
##Spanish - Mexico				   		2058
##Spanish - Nicaragua   				19466
##Spanish - Panama   					6154
##Spanish - Paraguay   					15370
##Spanish - Peru   						10250
##Spanish - Puerto Rico 		  		20490
##Spanish - United States 		  		21514
##Spanish - Uruguay 			  		14346
##Spanish - Venezuela  			 		8202
elseif(($LCID -eq "3082") -or ($LCID -eq "1034") -or ($LCID -eq "11274") -or ($LCID -eq "16394") -or ($LCID -eq "13322") -or ($LCID -eq "9226") -or ($LCID -eq "5130") -or ($LCID -eq "7178") -or ($LCID -eq "12298") -or ($LCID -eq "17418") -or ($LCID -eq "4106") -or ($LCID -eq "18442") -or ($LCID -eq "22538") -or ($LCID -eq "2058") -or ($LCID -eq "19466") -or ($LCID -eq "6154") -or ($LCID -eq "15370") -or ($LCID -eq "10250") -or ($LCID -eq "20490") -or ($LCID -eq "21514") -or ($LCID -eq "14346") -or ($LCID -eq "8202")){
  $code = 'es'
}

##Swedish					1053
##Swedish - Finland			2077
elseif(($LCID -eq "1053") -or ($LCID -eq "2077")){
  $code = 'sw'
}

##Thai						1054
elseif($LCID -eq "1054"){
  $code = 'th'
}

##Turkish					1055
elseif($LCID -eq "1055"){
  $code = 'tr'
}

##Turkmen					1090
elseif($LCID -eq "1090"){
  $code = 'tkm'
}

##Ukrainian					1058
elseif($LCID -eq "1058"){
  $code = 'ukr'
}

##Uzbek (Cyrillic)			2115
##Uzbek (Latin)				1091
elseif(($LCID -eq "2115") -or ($LCID -eq "1091")){
  $code = 'uz'
}

#Valencian
#Valencian			2051
elseif($LCID -eq "2051"){
  $code = 'va'
}

##Vietnamese		1066
elseif($LCID -eq "1066"){
  $code = 'vn'
}

##English --- all
else{
  $code = 'en'
}

$downloadInfo = GetDownloadInfo -downloadInfoFile "$toolsPath\downloadInfo.csv" -code $code -urlVersion $url_version

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = $downloadInfo.URL64
  checksum64    = $downloadInfo.Checksum64
  checksumType64= $checksumType64
  softwareName  = 'WinRAR*'
  silentArgs    = '/S'
  validExitCodes= @(0)
}
Install-ChocolateyPackage @packageArgs
