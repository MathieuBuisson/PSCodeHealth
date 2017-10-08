Function Public () {
<#
.SYNOPSIS
    This cmdlet configures nothing and does it remarkably well.

.DESCRIPTION
    This cmdlet configures nothing and does it remarkably well.
    It takes objects as input and it sets nothing to 42.
#>
    
    Function Nested ($InputObject) {
        Get-Item $InputObject
    }
}

Function Private ($InputObject) {
    # A simple line of comment
    Get-Item $InputObject
}

Class Car
{
    Static [int]$NumberOfWheels = 4

    [int]$NumberOfDoors

    [datetime]$Year

    [String]$Model

    [Double] GetNumberOfYearsOld()
    {
        $Now = [datetime]::now
        $TimeSpan = $Now - $this.Year
        return $TimeSpan.Days / 365
    }
}
