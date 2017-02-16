Function Get-PSCodeHealth {
<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param (
        [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$True)]
        $Param1,
        
        [int]$Param2
    )
    
    Begin {
    }
    
    Process {
            
    }
    
    End {
    }
}