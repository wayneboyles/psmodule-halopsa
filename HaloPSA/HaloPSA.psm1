$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue)

foreach($import in @($Public + $Private)) {
    try {
        Write-Verbose "Importing '$($import.fullname)'..."
        . $import.fullname
    } catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$HaloSession = [ordered] @{
    BaseUrl = ""
    ClientId = ""
    TokenType = ""
    AccessToken = ""
    RefreshToken = ""
    IdToken = ""
    Scopes = ""
    Expires = $null
}

New-Variable -Name HaloSession -Value $HaloSession -Scope Script -Force

Export-ModuleMember -Function $Public.BaseName
