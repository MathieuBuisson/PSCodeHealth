Function Merge-PSCodeHealthSetting {
<#
.SYNOPSIS
    Merges user-defined settings (metrics thresholds, etc...) into the default PSCodeHealth settings.

.DESCRIPTION
    Merges user-defined settings (metrics thresholds, etc...) into the default PSCodeHealth settings.  
    The default PSCodeHealth settings are stored in PSCodeHealthSettings.json, but user-defined custom settings can override these defaults.  
    The custom settings are stored in JSON format in a file (similar to PSCodeHealthSettings.json).
    Any setting specified in the custom settings file override the defaults and settings not specified in the custom settings file will use the defaults from PSCodeHealthSettings.json.  

.PARAMETER DefaultSettings
    PSCustomObject converted from the JSON data in PSCodeHealthSettings.json.

.PARAMETER CustomSettings
    PSCustomObject converted from the JSON data in a user-defined custom settings file.

.OUTPUTS
    System.Management.Automation.PSCustomObject

#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param(
        [Parameter(Mandatory=$True,Position=0)]
        [PSCustomObject]$DefaultSettings,

        [Parameter(Mandatory=$True,Position=1)]
        [PSCustomObject]$CustomSettings
    )

    # Checking if $CustomSettings contains something
    $ContainsSettings = $CustomSettings | Get-Member -MemberType Properties
    If ( -not($ContainsSettings) ) {
        Write-VerboseOutput -Message 'Custom settings do not contain any data, the resulting settings will be the defaults.'
        return $DefaultSettings
    }

    $ContainsFunctionHealthRecordSettings = 'FunctionHealthRecordMetricsRules' -in $ContainsSettings.Name
    $ContainsOverallHealthReportSettings = 'OverallHealthReportMetricsRules' -in $ContainsSettings.Name

    If ( -not($ContainsFunctionHealthRecordSettings) -and -not($ContainsOverallHealthReportSettings) ) {
        Write-Warning -Message 'Custom settings do not contain any of the settings groups expected by PSCodeHealth.'
        return $DefaultSettings
    }

    If ( $ContainsFunctionHealthRecordSettings) {
        $CustomFunctionSettings = $CustomSettings.FunctionHealthRecordMetricsRules | Where-Object { $_ }

        # Casting to a list in case we need to add elements to it
        $DefaultFunctionSettings = ($DefaultSettings.FunctionHealthRecordMetricsRules | Where-Object { $_ }) -as [System.Collections.ArrayList]
                
        Foreach ( $CustomFunctionSetting in $CustomFunctionSettings ) {
            $MetricName = ($CustomFunctionSetting | Get-Member -MemberType Properties).Name
            Write-VerboseOutput -Message "Processing custom settings for metric : $MetricName"

            $DefaultFunctionSetting = $DefaultFunctionSettings | Where-Object { $_.$($MetricName) }
            If ( $DefaultFunctionSetting ) {
                Write-VerboseOutput -Message "The setting '$MetricName' is present in the default settings, overriding it."
                $DefaultFunctionSetting.$($MetricName) = $CustomFunctionSetting.$($MetricName)
            }
            Else {
                Write-VerboseOutput -Message "The setting '$MetricName' is absent from the default settings, adding it."
                $Null = $DefaultFunctionSettings.Add($CustomFunctionSetting)
            }
        }
    }

    If ( $ContainsOverallHealthReportSettings ) {
        $CustomOverallSettings = $CustomSettings.OverallHealthReportMetricsRules | Where-Object { $_ }

        # Casting to a list in case we need to add elements to it
        $DefaultOverallSettings = ($DefaultSettings.OverallHealthReportMetricsRules | Where-Object { $_ }) -as [System.Collections.ArrayList]

        Foreach ( $CustomOverallSetting in $CustomOverallSettings ) {
            $MetricName = ($CustomOverallSetting | Get-Member -MemberType Properties).Name
            Write-VerboseOutput -Message "Processing custom settings for metric : $MetricName"

            $DefaultOverallSetting = $DefaultOverallSettings | Where-Object { $_.$($MetricName) }
            If ( $DefaultOverallSetting ) {
                Write-VerboseOutput -Message "The setting '$MetricName' is present in the default settings, overriding it."
                $DefaultOverallSetting.$($MetricName) = $CustomOverallSetting.$($MetricName)
            }
            Else {
                Write-VerboseOutput -Message "The setting '$MetricName' is absent from the default settings, adding it."
                $Null = $DefaultOverallSettings.Add($CustomOverallSetting)
            }
        }
    }
    $MergedSettingsProperties = [ordered]@{
        FunctionHealthRecordMetricsRules = $DefaultFunctionSettings
        OverallHealthReportMetricsRules = $DefaultOverallSettings
    }
    $MergedSettings = New-Object -TypeName PSCustomObject -Property $MergedSettingsProperties
    return $MergedSettings
}