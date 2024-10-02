<#
.SYNOPSIS
    Adds a private note to a ticket

.DESCRIPTION
    Adds a private note to a ticket with the option to specify the agent name.  This
    note will be hidden from the end user.

.NOTES
    This function uses ActionId 55 (Private Note)

.PARAMETER TicketId
    The ID of the ticket to add the note to

.PARAMETER Note
    The note to add to the ticket

.PARAMETER Who
    The optional name of the agent adding the private note

.PARAMETER PassThru
    When set, the ticket being updated will be output to the console

.EXAMPLE
    New-HaloPrivateNote -TicketId 1234 -Who "My Agent" -Note "This is my note"
    This example adds a new private note from the agent "My Agent"

.EXAMPLE
    New-HaloPrivateNote -TicketId 1234 -Note "This is my note"
    This example adds a new private note from the default agent of "HaloAPI"
#>
function New-HaloPrivateNote() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrWhiteSpace()]
        [string] $TicketId,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrWhiteSpace()]
        [string] $Note,

        [Parameter()]
        [string] $Who = "HaloAPI",

        [Parameter()]
        [switch] $PassThru
    )
    process {
        $Body = @(
            @{
                ticket_id      = $TicketId
                outcome        = "Private Note"
                outcome_id     = 55
                who_type       = 1
                who            = $Who
                hiddenfromuser = 1
                private_note   = $Note
            }
        ) | ConvertTo-Json -AsArray

        $Response = Invoke-HaloRequest -Resource "actions" -Method Post -Content $Body
        if ($PassThru) {
            $Response
        }
    }
}