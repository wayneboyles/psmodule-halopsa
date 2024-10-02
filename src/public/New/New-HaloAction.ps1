function New-HaloAction() {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $private_note
    )
    DynamicParam {
        $RootPath = $MyInvocation.MyCommand.Module.ModuleBase
        $DataPath = Join-Path -Path $RootPath -ChildPath "data\HaloPSA\Action.json"

        $ParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        $JSON = Get-Content -Raw -Path $DataPath -Force | ConvertFrom-Json
        $Variables = $JSON | Get-Member -Name * -MemberType NoteProperty

        foreach ($Var in $Variables) {
            #$Formatted = (Get-Culture).TextInfo.ToTitleCase($Var.Name) -replace '_', ''
            $Formatted = $Var.Name

            # Build the attribute
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $NewVarAttribute = New-Object System.Management.Automation.ParameterAttribute -Property @{ Mandatory = $false }
            $AttributeCollection.Add($NewVarAttribute);

            # Create the attribute with the correct type (string, int, bool etc.)
            $TypeName = $Var.Definition.ToString()
            if ($TypeName -like 'long*') {
                $NewVar = New-Object System.Management.Automation.RuntimeDefinedParameter($Formatted, [int], $AttributeCollection)
                $ParamDictionary.Add($Formatted, $NewVar);
            }
            elseif ($TypeName -like 'string*') {
                $NewVar = New-Object System.Management.Automation.RuntimeDefinedParameter($Formatted, [string], $AttributeCollection)
                $ParamDictionary.Add($Formatted, $NewVar);
            }
            elseif ($TypeName -like 'bool*') {
                $NewVar = New-Object System.Management.Automation.RuntimeDefinedParameter($Formatted, [switch], $AttributeCollection)
                $ParamDictionary.Add($Formatted, $NewVar);
            }
            elseif ($TypeName -like '*PSCustomObject*') {
                $NewVar = New-Object System.Management.Automation.RuntimeDefinedParameter($Formatted, [hashtable], $AttributeCollection)
                $ParamDictionary.Add($Formatted, $NewVar);
            }
        }

        $ParamDictionary
    }
    begin {
        Write-Verbose "Executing $($MyInvocation.MyCommand)"
        $Parameters = Build-QueryStringParameters -FuncInfo $MyInvocation.MyCommand -BoundParameters $PSBoundParameters -IncludeId
    }
    process {
        Invoke-HaloRequest -Resource "Actions" -Method Post -Content ($Parameters | ConvertTo-Json -AsArray)
    }
}