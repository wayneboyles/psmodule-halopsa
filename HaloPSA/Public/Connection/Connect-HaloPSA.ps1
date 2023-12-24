
function Connect-HaloPSA() {
    [CmdletBinding(DefaultParameterSetName = "ClientCredentials")]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = "ClientCredentials")]
        [Parameter(Mandatory, Position = 0, ParameterSetName = "UserPassword")]
        [ValidateNotNullOrEmpty()]
        [string] $BaseUrl,

        [Parameter(Mandatory, Position = 1, ParameterSetName = "ClientCredentials")]
        [Parameter(Mandatory, Position = 1, ParameterSetName = "UserPassword")]
        [ValidateNotNullOrEmpty()]
        [string] $ClientId,

        [Parameter(Mandatory, ParameterSetName = "ClientCredentials")]
        [ValidateNotNullOrEmpty()]
        [string] $ClientSecret,

        [Parameter(ParameterSetName = "ClientCredentials")]
        [ValidateNotNullOrEmpty()]
        [string] $Scope = "all",

        [Parameter(Mandatory, ParameterSetName = "UserPassword")]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential
    )
    process {

    }
}
