#Requires -Version 4
Function Get-Nothing {
<#
.SYNOPSIS
    This cmdlet does nothing and does it remarkably well.

.DESCRIPTION
    This cmdlet does absolutely nothing and does it remarkably well.
    It takes objects as input and it outputs nothing.

.PARAMETER InputObject
    Specifies one or more object(s) to get.
    It can be string(s), integer(s), file(s), any type of object.

.PARAMETER Filter
    Specifies a filter in the provider's format or language. The value of this parameter qualifies the InputObject.
    The syntax of the filter, including the use of wildcards, or regular expressions, depends on the provider.

.EXAMPLE
    Get-Nothing -InputObject Item,Thing,Stuff -Filter @{Name -like "*null*"}

    Takes the objects Item,Thing and Stuff, filters only the ones with a name containing "null" and does nothing.

.EXAMPLE
    Get-Content ".\File.txt" | Get-Nothing

    Takes the content of the file File.txt as input and does nothing.
#>
    [CmdletBinding()]
    
    Param(
        [Parameter(Mandatory,Position=0,ValueFromPipeline=$True)]
        [PSObject[]]$InputObject,

        [Parameter(Position=1)]
        [string]$Filter
    )
    Begin {
    }
    Process {
    }
}
Function Set-Nothing {
<#
.SYNOPSIS
    This cmdlet configures nothing and does it remarkably well.

.DESCRIPTION
    This cmdlet configures nothing and does it remarkably well.
    It takes objects as input and it sets nothing to 42.

.PARAMETER InputObject
    Specifies one or more object(s) to configure.
    It can be string(s), integer(s), file(s), any type of object.

.PARAMETER Value
    Specifies the value to set nothing to.

.EXAMPLE
    Set-Nothing -InputObject Item,Thing,Stuff -Value $Null

    Takes the objects Item,Thing and Stuff, sets nothing to $Null.

.EXAMPLE
    Get-Content ".\File.txt" | Set-Nothing

    Takes the content of the file File.txt as input and sets nothing to 42.
#>
    [CmdletBinding()]
    
    Param(
        [Parameter(Mandatory,Position=0,ValueFromPipeline=$True)]
        [PSObject[]]$InputObject,

        [Parameter(Position=1)]
        [int]$Value = 42
    )
    Begin {
    }
    Process {
        $Null = Get-Nothing
    }
}
