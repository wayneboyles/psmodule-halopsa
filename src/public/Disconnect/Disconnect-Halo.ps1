function Disconnect-Halo() {
    [CmdletBinding()]
    param ()
    process {
        $HaloSession.BaseUrl = $null
        $HaloSession.AccessToken = $null

        Write-Host "Disconnected from the HaloPSA API"
    }
}