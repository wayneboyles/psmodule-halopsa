<#
.SYNOPSIS
    Invokes a new Halo HTTP request

.DESCRIPTION
    Invokes a new Halo HTTP request for the given resource and returns the
    results

.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Invoke-HaloRequest() {
    [OutputType([string], [hashtable])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Resource,

        [Parameter()]
        [ValidateSet('Get', 'Post', 'Delete')]
        [string] $Method = 'Get',

        [Parameter()]
        [hashtable] $Parameters = @{},

        [Parameter()]
        [array] $Content,

        [Parameter()]
        [hashtable] $Headers = @{},

        [Parameter()]
        [string] $ContentType = "application/json"
    )
    begin {
        $AccessToken = $HaloSession.AccessToken
        if ([string]::IsNullOrEmpty($AccessToken)) {
            Write-Error "No access token set!  Please call 'Connect-Halo' to retrieve the access token."
            Exit 1
        }
    }
    process {
        # Process query parameters
        $ParamCollection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        if ($null -ne $Parameters) {
            foreach ($Item in ($Parameters.GetEnumerator() | Sort-Object -CaseSensitive -Property Key)) {
                $ParamCollection.Add($Item.Key, $Item.Value)
            }
        }

        # Format the request uri
        $Uri = "{0}/api/{1}" -f $HaloSession.BaseUrl.TrimEnd('/'), $Resource

        # If we have query parameters, add them to the request
        $Params = $ParamCollection.ToString()
        if ($Params) {
            $Builder = [System.UriBuilder]::new($Uri)
            $Builder.Query = $Params
            $Uri = $Builder.Uri
        }

        Write-Verbose ("{0} [{1}]" -f $Method, $Uri)

        # Build the headers
        $Headers += @{
            Authorization = "Bearer $AccessToken"
        }

        # Build the request
        $RestMethod = @{
            Method      = $Method
            Uri         = $Uri
            Headers     = $Headers
            ContentType = $ContentType
        }

        # Build the body so it's in the correct format
        if ($PSBoundParameters.ContainsKey('Content')) {
            $RestMethod.Body = $Body
        }

        # If we have content, add that
        if ($Method -ne 'Get' -and $PSBoundParameters.ContainsKey('Content')) {
            $RestMethod.Body = $Content
        }

        try {
            $Result = Invoke-RestMethod @RestMethod
        }
        catch {
            if ("$_".trim() -eq 'Retry later' -or "$_".trim() -eq 'The remote server returned an error: (429) Too Many Requests.') {
                Write-Information 'Hudu API Rate limited. Waiting 30 Seconds then trying again'

                Start-Sleep 30

                $Result = Invoke-HaloRequest @RestMethod
            }
            else {
                Write-Error "'$_'"
            }
        }

        $Result
    }
}