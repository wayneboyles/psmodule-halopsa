function Get-HaloTicket() {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param (
        [Parameter(Mandatory, ParameterSetName = "Single", Position = 0)]
        [string] $Id,

        [Parameter(ParameterSetName = "Single")]
        [switch] $IncludeDetails,

        [Parameter(ParameterSetName = "Single")]
        [switch] $IncludeLastAction,

        [Parameter(ParameterSetName = "All")]
        [Parameter(ParameterSetName = "Single")]
        [switch] $TicketIdOnly,

        [Parameter(ParameterSetName = "All")]
        [string] $OrderBy,

        [Parameter(ParameterSetName = "All")]
        [switch] $Descending,

        [Parameter(ParameterSetName = "All")]
        [int] $PageSize,

        [Parameter(ParameterSetName = "All")]
        [int] $PageNumber
    )
    begin {
        Write-Verbose "Executing $($MyInvocation.MyCommand)"
        Write-Verbose "Bound Parameters:"

        $Parameters = @{}

        foreach ($Param in $PSBoundParameters.GetEnumerator()) {
            $Key = $Param.Key
            $Value = $Param.Value

            # Id will be passed in the URL
            if ($Key -eq "Id") {
                continue
            }

            # Filter out common parameters (Verbose, ErrorAction, etc.)
            if ($Key -in [System.Management.Automation.Cmdlet]::CommonParameters) { continue }

            # Attempt to get the custom attribute on this property.  If it exists, update the key name
            $Attribute = (Get-Command -Name $MyInvocation.MyCommand).Parameters[$Key].Attributes.Where{ $_.TypeId.Name -eq 'QueryNameAttribute' }
            if ($Attribute) {
                $Key = $Attribute.QueryName
            }

            # Add to the parameters hashtable
            #$Parameters += @{ $Key = $Value }
            $Parameters.$Key = $Value
        }

        $Parameters | Out-String | Write-Verbose
    }
    process {

        # $QueryParams = @{}

        # # TicketID Only
        # if ($PSBoundParameters.ContainsKey('TicketIdOnly')) { $QueryParams.ticketidonly = $TicketIdOnly.IsPresent }

        # Single Ticket
        if ($PSCmdlet.ParameterSetName -eq "Single") {

            # if ($PSBoundParameters.ContainsKey('IncludeDetails')) { $QueryParams.includedetails = $IncludeDetails.IsPresent }
            # if ($PSBoundParameters.ContainsKey('IncludeLastAction')) { $QueryParams.includelastaction = $IncludeLastAction.IsPresent }

            $Result = Invoke-HaloRequest -Resource "tickets/$Id" -Parameters $Parameters
        }

        # All / Multiple Tickets
        if ($PSCmdlet.ParameterSetName -eq "All") {

            # if ($PSBoundParameters.ContainsKey('OrderBy')) { $QueryParams.order = $OrderBy }
            # if ($PSBoundParameters.ContainsKey('Descending')) { $QueryParams.orderdesc = $Descending.IsPresent }

            # Paging support

            # Invoke
            $Result = Invoke-HaloRequest -Resource "tickets" -Parameters $Parameters
        }



        # if ($PSBoundParameters.ContainsKey('TicketId')) {
        #     Write-Verbose "Retrieving ticket with ID $TicketId"
        #     Invoke-HaloRequest -Resource "tickets/$TicketId"
        # }
        # else {
        #     Write-Verbose "Retrieving all tickets"
        #     Invoke-HaloRequest -Resource "tickets"
        # }

        $Result
    }
}