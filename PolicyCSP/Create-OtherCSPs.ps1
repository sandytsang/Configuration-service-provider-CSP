Import-Module Microsoft.Graph.Intune
Connect-MSGraph
$omaSettingsList =$null
$omaSettingsList = @()


<#
[array]$omaurls = "./Device/Vendor/MSFT/BitLocker/RequireDeviceEncryption", "./Device/Vendor/MSFT/BitLocker/RequireDeviceEncryptafaf"
foreach ($omaurl in $omaurls) {
    $omasetting = New-OmaSettingObject -displayName 01Test -omaUri "$omaurl" -omaSettingInteger -value 0
    $omaSettingsList += $omasetting
}
#>

$PolicyCSPs = Get-CimClass -ClassName MDM_* -Namespace "root\cimv2\mdm\dmmap" | Where-Object {$_.CimClassName -notmatch "^MDM_Policy"} |  Sort-Object -Property CimClassName
Foreach ($PolicyCSP in $PolicyCSPs) {
    $CimClassName = $($PolicyCSP.CimClassName)
    $PolicyName = $CimClassName -replace "MDM_" -replace "_01" -replace "01" -replace "02" -replace "03" -replace "04"   
    $CimClassProperties = $($PolicyCSP.CimClassProperties).Name | Where-Object {$_ -ne "ParentID" -and $_ -ne "PSComputerName" -and $_ -ne "InstanceID"}
    foreach ($CimClassPropertie in $CimClassProperties) {
    $Omaurl = ("./Vendor/MSFT/$PolicyName/$CimClassPropertie").Replace("_","/")
    $Omaurl
    $omasetting = New-OmaSettingObject -displayName "$CimClassPropertie" -omaUri "$omaurl" -omaSettingInteger -value 1
    $omaSettingsList += $omasetting
    }
}
$omaSettingsList.Count

$omaSettingsList1 =$omaSettingsList | Sort-Object omaUri | Select-Object -First 125
$omaSettingsList2 =$omaSettingsList | Sort-Object omaUri | Select-Object -Skip 125 -First 125
$omaSettingsList3 =$omaSettingsList | Sort-Object omaUri | Select-Object -Skip 250 -First 125
$omaSettingsList4 =$omaSettingsList | Sort-Object omaUri | Select-Object -Skip 375 -First 125
$omaSettingsList5 =$omaSettingsList | Sort-Object omaUri | Select-Object -Skip 500



New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList1 -displayName "001.Iot Other CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList2 -displayName "002.Iot Other CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList3 -displayName "003.Iot Other CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList4 -displayName "004.Iot Other CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList5 -displayName "005.Iot Other CSP test" -windows10CustomConfiguration


