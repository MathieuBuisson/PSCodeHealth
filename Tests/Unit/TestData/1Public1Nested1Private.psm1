Function Public () {
    
    Function Nested ($InputObject) {
        Get-Item $InputObject
    }
}

Function Private ($InputObject) {
    Get-Item $InputObject
}
