
function Disconnect-HaloPSA() {
    [CmdletBinding()]
    param ( )
    process {
        Write-Verbose "Destroying the current HaloPSA session..."

        $HaloSession.BaseUrl = ""
        $HaloSession.ClientId = ""
        $HaloSession.TokenType = ""
        $HaloSession.AccessToken = ""
        $HaloSession.RefreshToken = ""
        $HaloSession.IdToken = ""
        $HaloSession.Expires = $null
        $HaloSession.Scopes = ""

        Write-Output "Disconnected from the HaloPSA API."
    }
}
