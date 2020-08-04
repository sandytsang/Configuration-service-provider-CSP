Import-Module Microsoft.Graph.Intune
Connect-MSGraph
$omaSettingsList = $null
$omaSettingsList = @()

<#List all the CSPs manually
[array]$omaurls = "./Device/Vendor/MSFT/BitLocker/RequireDeviceEncryption", "./Device/Vendor/MSFT/BitLocker/RequireDeviceEncryptafaf"
foreach ($omaurl in $omaurls) {
    $omasetting = New-OmaSettingObject -displayName 01Test -omaUri "$omaurl" -omaSettingInteger -value 0
    $omaSettingsList += $omasetting
}
#>

<#Gets Policy CSP from WMI
$PolicyCSPs = Get-CimClass -ClassName MDM_* -Namespace "root\cimv2\mdm\dmmap" | Where-Object { $_.CimClassName -notmatch "^MDM_Policy" } |  Sort-Object -Property CimClassName
Foreach ($PolicyCSP in $PolicyCSPs) {
    $($PolicyCSP.CimClassName) -match "[^MDM_Policy_Config01_].*[a-z]" | Out-Null
    $PolicyName = $matches.Values
    $CimClassProperties = $($PolicyCSP.CimClassProperties).Name | Where-Object { $_ -ne "ParentID" -and $_ -ne "PSComputerName" -and $_ -ne "InstanceID" }
    foreach ($CimClassPropertie in $CimClassProperties) {
        $Omaurl = ("./Vendor/MSFT/$PolicyName/$CimClassPropertie").Replace("_", "/")
        $Omaurl
        $omasetting = New-OmaSettingObject -displayName "$CimClassPropertie" -omaUri "$omaurl" -omaSettingInteger -value 1
        $omaSettingsList += $omasetting
    }
}

#>

$omaurls = Import-Csv .\PolicyCSP\PolicyCSP.csv
foreach ($Omaurl in $Omaurls) {
    $displayname = $Omaurl -replace './Vendor/MSFT/Policy/Config/'
    $omasetting = New-OmaSettingObject -displayName "$displayname" -omaUri "$omaurl" -omaSettingString -value "1"
    $omaSettingsList += $omasetting
}

$omaSettingsList.Count

$omaSettingsList1 = $omaSettingsList | Sort-Object omaUri | Select-Object -First 125
$omaSettingsList2 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 125 -First 125
$omaSettingsList3 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 250 -First 125
$omaSettingsList4 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 375 -First 125
$omaSettingsList5 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 500 -First 125
$omaSettingsList6 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 625 -First 125
$omaSettingsList7 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 750 -First 125
$omaSettingsList8 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 875 -First 125
$omaSettingsList9 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 1000 -First 125
$omaSettingsList9 = $omaSettingsList | Sort-Object omaUri | Select-Object -Skip 1125 -First 125

New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList1 -displayName "01.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList2 -displayName "02.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList3 -displayName "03.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList4 -displayName "04.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList5 -displayName "05.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList6 -displayName "06.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList7 -displayName "07.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList8 -displayName "08.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList9 -displayName "09.Iot Policy CSP test" -windows10CustomConfiguration
New-IntuneDeviceConfigurationPolicy -omaSettings $omaSettingsList9 -displayName "10.Iot Policy CSP test" -windows10CustomConfiguration

