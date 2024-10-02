function Remove-HaloAction() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [int] $Id,

        [QueryNameAttribute("ticket_id")]
        [Parameter(Mandatory, Position = 1)]
        [int] $TicketId,

        [QueryIgnoreAttribute()]
        [Parameter()]
        [switch] $PassThru
    )
    begin {
        Write-Verbose "Executing $($MyInvocation.MyCommand)"
        $Parameters = Build-QueryStringParameters -FuncInfo $MyInvocation.MyCommand -BoundParameters $PSBoundParameters
    }
    process {
        $Result = Invoke-HaloRequest -Resource "Actions/$Id" -Method Delete -Parameters $Parameters

        if ($PassThru) {
            Write-Output $Result
        }
        else {
            $OutputObject = @{
                TicketId = $Result.ticket_id
                Status   = "Action Deleted"
                Outcome  = $Result.outcome
                Who      = $Result.who
            }

            Write-Output $OutputObject
        }

    }
}