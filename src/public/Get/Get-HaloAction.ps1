function Get-HaloAction() {
    [CmdletBinding(DefaultParameterSetName = "All")]
    param (

        [Parameter(Mandatory, ParameterSetName = "Single", Position = 0)]
        [int] $Id,

        [QueryNameAttribute("ticket_id")]
        [Parameter(ParameterSetName = "All")]
        [Parameter(Mandatory, ParameterSetName = "Single", Position = 1)]
        [int] $TicketId,

        [Parameter(ParameterSetName = "All")]
        [int] $Count,

        [QueryNameAttribute("excludesys")]
        [Parameter(ParameterSetName = "All")]
        [switch] $ExcludeSystemActions,

        [QueryNameAttribute("conversationonly")]
        [Parameter(ParameterSetName = "All")]
        [switch] $ConversationsOnly,

        [Parameter(ParameterSetName = "All")]
        [Parameter(ParameterSetName = "Single")]
        [switch] $AgentOnly,

        [Parameter(ParameterSetName = "All")]
        [switch] $SupplierOnly,

        [Parameter(ParameterSetName = "All")]
        [switch] $ExcludePrivate,

        [Parameter(ParameterSetName = "All")]
        [switch] $IncludeHtmlNote,

        [Parameter(ParameterSetName = "All")]
        [switch] $IncludeHtmlEmail,

        [Parameter(ParameterSetName = "All")]
        [switch] $IncludeAttachments,

        [Parameter(ParameterSetName = "All")]
        [switch] $ImportantOnly,

        [Parameter(ParameterSetName = "All")]
        [switch] $SLAOnly,

        [QueryNameAttribute("ischildnotes")]
        [Parameter(ParameterSetName = "All")]
        [switch] $ChildNotesOnly,

        [Parameter(ParameterSetName = "Single")]
        [switch] $IncludeEmail,

        [Parameter(ParameterSetName = "Single")]
        [switch] $IncludeDetails,

        [Parameter(ParameterSetName = "Single")]
        [switch] $MostRecent,

        [Parameter(ParameterSetName = "Single")]
        [switch] $EmailOnly,

        [QueryNameAttribute("nonsystem")]
        [Parameter(ParameterSetName = "Single")]
        [switch] $NonSystemActions
    )
    begin {
        Write-Verbose "Executing $($MyInvocation.MyCommand)"
        $Parameters = Build-QueryStringParameters -FuncInfo $MyInvocation.MyCommand -BoundParameters $PSBoundParameters
    }
    process {
        if ($PSCmdlet.ParameterSetName -eq "All") {
            $Result = Invoke-HaloRequest -Resource "Actions" -Parameters $Parameters
        }

        if ($PSCmdlet.ParameterSetName -eq "Single") {
            $Result = Invoke-HaloRequest -Resource "Actions/$Id" -Parameters $Parameters
        }

        $Result
    }
}