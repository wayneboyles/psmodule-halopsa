
#===================================================================#
# USINGS
#===================================================================#

using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

#===================================================================#
# CLASSES
# Classes are difficult to import using the regular method
# TODO: Consider moving the classes to external C# class library
#===================================================================#

class HaloScopes {

    [array] static $Scopes = @(
        "all",
        "all:standard",
        "admin",
        "all:teams",
        "admin:webhooks",
        "read:tickets",
        "edit:tickets",
        "read:calendar",
        "edit:calendar",
        "read:customers",
        "edit:customers",
        "read:crm",
        "edit:crm",
        "read:contracts",
        "edit:contracts",
        "read:suppliers",
        "edit:suppliers",
        "read:items",
        "edit:items",
        "read:projects",
        "edit:projects",
        "read:sales",
        "edit:sales",
        "read:quotes",
        "edit:quotes",
        "read:sos",
        "edit:sos",
        "read:pos",
        "edit:pos",
        "read:invoices",
        "edit:invoices",
        "read:reporting",
        "edit:reporting",
        "read:timesheets",
        "editMine:timesheets",
        "edit:timesheets",
        "read:softwarelicensing",
        "edit:softwarelicensing",
        "read:software",
        "edit:software",
        "read:kb",
        "edit:kb",
        "read:assets",
        "edit:assets",
        "read:distributionlists",
        "edit:distributionlists",
        "access:chat",
        "access:adpasswordreset"
    )

    [array] static GetScopes() {
        return [HaloScopes]::Scopes
    }
}

class HaloScopesCompleter : IArgumentCompleter {

    [string[]] $Scopes = @(
        "all",
        "tickets:read",
        "tickets:write",
        "customers:read",
        "customers:write"
    )


    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $Command,
        [string] $Parameter,
        [string] $WordToComplete,
        [CommandAST] $CommandAST,
        [IDictionary] $FakeBoundParams
    ) {
        $Wildcard = ("*$($WordToComplete)*")
        $Results = [List[CompletionResult]]::new()
        $Scopes = [HaloScopes]::GetScopes()

        $Scopes -like $Wildcard | ForEach-Object {
            $Results.Add([CompletionResult]::new($_, $_, 'ParameterValue', $_))
        }

        return $Results
    }
}

class QueryNameAttribute : System.Attribute {
    [string] $QueryName = $null

    QueryNameAttribute($QueryName) {
        $this.QueryName = $QueryName
    }

    [string] ToString() {
        return $this.QueryName
    }
}

class QueryIgnoreAttribute : System.Attribute {

}

#===================================================================#
# IMPORTS
#===================================================================#

$Public = Get-ChildItem $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue
$Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue

foreach ($import in @($Public + $Private)) {
    try { . $import }
    catch { Write-Error "Failed to import function $($import.FullName): $_" }
}

Export-ModuleMember -Function $Public.BaseName

#===================================================================#
# VARIABLES
#===================================================================#

$HaloSession = [ordered] @{
    BaseUrl     = $null
    AccessToken = $null
}

New-Variable -Name HaloSession -Value $HaloSession -Scope Script -Force