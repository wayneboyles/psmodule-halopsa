
function New-HaloApiRequest() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Endpoint,

        [Parameter()]
        [System.Net.Http.HttpMethod] $Method = 'Get',

        [Parameter()]
        [hashtable] $Headers = @{},

        [Parameter()]
        [hashtable] $QueryString = @{},

        [Parameter()]
        [hashtable] $Body = @{}
    )
    begin {

    }
    process {

    }
}
