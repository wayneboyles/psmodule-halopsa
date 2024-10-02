function Build-QueryStringParameters() {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [System.Management.Automation.FunctionInfo] $FuncInfo,

        [Parameter(Mandatory, Position = 1)]
        [hashtable] $BoundParameters,

        [Parameter()]
        [switch] $IncludeId
    )
    process {
        Write-Verbose "Bound Parameters:"

        $Parameters = @{}

        foreach ($Param in $BoundParameters.GetEnumerator()) {
            $Key = $Param.Key
            $Value = $Param.Value

            # Id will be passed in the URL
            if ($Key -eq "Id" -and -not $IncludeId) {
                continue
            }

            # Should we be ignoring this attribute?
            $Ignore = (Get-Command -Name $FuncInfo.Name).Parameters[$Key].Attributes.Where{ $_.TypeId.Name -eq 'QueryIgnoreAttribute' }
            if ($Ignore) {
                continue
            }

            # Filter out common parameters (Verbose, ErrorAction, etc.)
            if ($Key -in [System.Management.Automation.Cmdlet]::CommonParameters) { continue }

            # Attempt to get the custom attribute on this property.  If it exists, update the key name
            $Attribute = (Get-Command -Name $FuncInfo.Name).Parameters[$Key].Attributes.Where{ $_.TypeId.Name -eq 'QueryNameAttribute' }
            if ($Attribute) {
                $Key = $Attribute.QueryName
            }

            # Add to the parameters hashtable
            #$Parameters += @{ $Key = $Value }
            $Parameters.$Key = $Value
        }

        $Parameters | Out-String | Write-Verbose

        $Parameters
    }
}