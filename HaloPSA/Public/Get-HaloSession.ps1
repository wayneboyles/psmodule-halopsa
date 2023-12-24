
function Get-HaloSession() {
    [CmdletBinding()]
    param ( )
    process {
        $HaloSession | Format-Table
    }
}
