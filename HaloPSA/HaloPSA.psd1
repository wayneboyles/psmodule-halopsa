@{

    # Script module or binary module file associated with this manifest.
    RootModule        = 'HaloPSA.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.1'

    # ID used to uniquely identify this module
    GUID              = 'bbe47640-aae7-404c-beba-746c2dd8cb6a'

    # Author of this module
    Author            = 'Wayne Boyles'

    # Company or vendor of this module
    CompanyName       = 'Wayne Boyles'

    # Copyright statement for this module
    Copyright         = 'Copyright (C) 2023 Wayne Boyles'

    # Description of the functionality provided by this module
    Description       = 'PowerShell Module for working with the HaloPSA API'

    # Minimum version of the PowerShell engine required by this module
    # PowerShellVersion = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    FunctionsToExport = @(
        'Get-HaloSession',
        'Connect-HaloPSA',
        'Disconnect-HaloPSA'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('HaloPSA', 'PowerShell', 'API')

            # A URL to the license for this module.
            LicenseUri = 'https://raw.githubusercontent.com/wayneboyles/psmodule-halopsa/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/wayneboyles/psmodule-halopsa'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/wayneboyles/psmodule-halopsa/main/Halo.png'

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
