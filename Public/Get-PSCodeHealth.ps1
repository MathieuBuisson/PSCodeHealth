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
    [OutputType([String])]
    Param (
        # Param1 help description
        [Parameter(Mandatory=True,Position=0,ValueFromPipeline=True)]
        [ValidateSet("sun", "moon", "earth")]
        Param1,
        
        # Param2 help description
        [ValidateScript({True})]
        [int]Param2
    )
    
    Begin {
    }
    
    Process {
            
    }
    
    End {
    }
}