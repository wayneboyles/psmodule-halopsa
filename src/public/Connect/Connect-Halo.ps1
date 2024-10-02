<#
.SYNOPSIS
    Connects to the HaloPSA API

.DESCRIPTION
    Connects to the HaloPSA API and stores the access token for future API calls

.NOTES
    Currently only supports Client Credential authentication

.PARAMETER BaseUrl
    The base url of your Halo instance.  For example https://my.halopsa.com

.PARAMETER ClientId
    The Client ID of the API Application within HaloPSA

.PARAMETER ClientSecret
    The Client Secret of the API Application within HaloPSA

.PARAMETER Tenant
    Optional - if using a hosted version of Halo, your Tenant name

.PARAMETER Scope
    The security scope(s) to connect to.  Defaults to 'all'

.PARAMETER NoWelcome
    When set, hides the welcome message when a connection is made

.PARAMETER PassThru
    When set, outputs the access token to the console

.EXAMPLE
    PS C:\> Connect-Halo -BaseUrl "https://my.halopsa.com" -ClientId "1234" -ClientSecret "1234"
    Connects to the Halo instance at my.halopsa.com using the Client ID of 1234
#>
function Connect-Halo() {
    [OutputType([void], [psobject])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('(http[s]?|[s]?)(:\/\/)([^\s,]+)')]
        [string] $BaseUrl,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $ClientId,

        [Parameter(Mandatory, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string] $ClientSecret,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Tenant,

        [Parameter()]
        [ArgumentCompleter([HaloScopesCompleter])]
        [string[]] $Scope = 'all',

        [Parameter()]
        [switch] $NoWelcome,

        [Parameter()]
        [switch] $PassThru

    )
    process {

        # Sanitize the URL
        $Builder = [System.UriBuilder]::new($BaseUrl)
        $Builder.Path = ""
        $Builder.Query = ""
        $BaseUrl = $Builder.Uri.AbsoluteUri
        Write-Verbose "Halo Base URL = $BaseUrl"

        # Create the auth both
        $Body = @{
            grant_type    = "client_credentials"
            client_id     = $ClientId
            client_secret = $ClientSecret
            scope         = ($Scope -join " ")
        }

        if ($PSBoundParameters.ContainsKey('Tenant')) {
            $Body += @{ tenant = $Tenant }
        }

        # Request the access token
        $AccessToken = (Invoke-RestMethod -Uri "$BaseUrl/auth/token" -Method Post -Body $Body).access_token

        # Set the session
        $HaloSession.BaseUrl = $BaseUrl
        $HaloSession.AccessToken = $AccessToken

        if ($PassThru) {
            Write-Output $AccessToken
        }
        else {
            if (-not ($NoWelcome)) {
                $AuthResult = Invoke-HaloRequest -Resource "AuthInfo"
                Write-Output $AuthResult
            }
        }
    }
}