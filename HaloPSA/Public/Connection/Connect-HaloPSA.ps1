<#
.SYNOPSIS
    Connects to the HaloPSA API.

.DESCRIPTION
    Connects to the HaloPSA API using one of two authentication methods.

.NOTES

.LINK

.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Connect-HaloPSA() {
    [OutputType([System.Void])]
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
        [string[]] $Scopes = "all",

        [Parameter(Mandatory, ParameterSetName = "UserPassword")]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Credential,

        [Parameter(ParameterSetName = "UserPassword")]
        [ValidateNotNullOrEmpty()]
        [string] $Tenant
    )
    begin {

        if (-not [uri]::IsWellFormedUriString($BaseUrl, 'Absolute')) {
            throw [System.ArgumentException]::new("The url '$BaseUrl' is not valid.  It must be a relative URL.")
        }

        if ($Scopes -is [array]) {
            $AuthScopes = $Scopes -join ' '
        } else {
            $AuthScopes = $Scopes
        }

        $BaseUrl = $BaseUrl.TrimEnd('/')
        $Endpoint = "$BaseUrl/auth/token"
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq 'ClientCredentials') {
            $AuthBody = @{
                "grant_type" = "client_credentials"
                "client_id" = $ClientId
                "client_secret" = $ClientSecret
                "scope" = $AuthScopes
            }
        } else {
            $AuthBody = @{
                "grant_type" = "password"
                "client_id" = $ClientId
                "username" = $Credential.GetNetworkCredential().UserName
                "password" = $AuthScopes.GetNetworkCredential().password
            }

            if (-not [string]::IsNullOrWhiteSpace($Tenant)) {
                $Endpoint = "$Endpoint?tenant=$Tenant"
            }
        }

        $AuthHeaders = @{
            "accept" = "application/json"
        }

        do {
            $AuthRetries++

            try {
                $AuthResponse = Invoke-WebRequest -Uri $Endpoint -Method 'Post' -Body $AuthBody -Headers $AuthHeaders
                $TokenPayload = ConvertFrom-Json -InputObject $AuthResponse.Content

                # Update our Session variable
                $HaloSession.BaseUrl = $BaseUrl
                $HaloSession.ClientId = $ClientId
                $HaloSession.TokenType = $TokenPayload.token_type
                $HaloSession.AccessToken = $TokenPayload.access_token
                $HaloSession.RefreshToken = $TokenPayload.refresh_token
                $HaloSession.IdToken = $TokenPayload.id_token
                $HaloSession.Expires = [datetime]::Now.AddSeconds($TokenPayload.expires_in)
                $HaloSession.Scopes = $TokenPayload.scope

                $Authenticated = $true
            } catch {
                $Authenticated = $false

                if ($_.Exception.Response.StatusCode.value__ -eq 429) {
                    Write-Warning "The request was throttled.  Waiting for 5 seconds and trying again."
                    Start-Sleep -Seconds 5
                    continue
                } else {
                    throw $_
                    break
                }
            }

        } while ((-not $Authenticated) -and ($AuthRetries -lt 10))

        if ($AuthRetries -gt 1) {
             throw 'Retried auth request {0} times, request unsuccessful.' -f $Retries
        }

        if ($Authenticated) {
            Write-Output "Connected to the HaloPSA API"
        }
    }
}
