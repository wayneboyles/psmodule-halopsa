function Get-HaloTicketType() {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param (
        [Parameter(ParameterSetName = "All")]
        [switch] $ShowCounts,

        [Parameter(ParameterSetName = "All")]
        [string] $Domain,

        [Parameter(ParameterSetName = "All")]
        [int] $ViewId,

        [Parameter(ParameterSetName = "All")]
        [switch] $ShowInactive,

        [Parameter(ParameterSetName = "All")]
        [int] $ClientId,

        [Parameter(Mandatory, ParameterSetName = "Single", Position = 0)]
        [int] $Id,

        [Parameter(ParameterSetName = "Single")]
        [switch] $ShowDetails
    )
    process {

        $QueryParams = @{}

        if ($PSCmdlet.ParameterSetName -eq "All") {

            # Show Counts
            if ($PSBoundParameters.ContainsKey('ShowCounts')) { $QueryParams.showcounts = $ShowCounts.IsPresent }

            # Domain
            if ($PSBoundParameters.ContainsKey('Domain')) { $QueryParams.domain = $Domain }

            # View ID
            if ($PSBoundParameters.ContainsKey('ViewId')) { $QueryParams.view_id = $ViewId }

            # Show Inactive
            if ($PSBoundParameters.ContainsKey('ShowInactive')) { $QueryParams.showinactive = $ShowInactive.IsPresent }

            # Client Id
            if ($PSBoundParameters.ContainsKey('ClientId')) { $QueryParams.client_id = $ClientId }

            # Invoke
            $Result = Invoke-HaloRequest -Resource "TicketType" -Parameters $QueryParams
        }

        if ($PSCmdlet.ParameterSetName -eq "Single") {

            # Include Details
            if ($PSBoundParameters.ContainsKey('IncludeDetails')) { $QueryParams.includedetails = $IncludeDetails.IsPresent }

            # Invoke
            $Result = Invoke-HaloRequest -Resource "TicketType/$Id" -Parameters $QueryParams
        }

        $Result
    }
}