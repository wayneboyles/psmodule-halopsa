
$RequiredModules = @(
	'BuildHelpers',
    'InvokeBuild',
    'Pester',
    'platyPS',
    'PSScriptAnalyzer'
)

$ModuleInstallScope = 'CurrentUser'

Get-PackageProvider -Name 'NuGet' -ForceBootstrap | Out-Null

foreach ($RequiredModule in $RequiredModules) {
	if (-not (Get-Module $RequiredModule)) {
		if (-not (Get-Module $RequiredModule -ListAvailable)) {
			$null = Install-Module $RequiredModule -Force -AllowClobber -Scope $ModuleInstallScope -SkipPublisherCheck
		}
	}

	Import-Module $RequiredModule
}

Set-BuildEnvironment
Get-ChildItem Env:BH*

# function Write-Log() {
# 	[CmdletBinding()]
# 	param (
# 		[Parameter(Mandatory, Position = 0)]
# 		[ValidateNotNullOrEmpty()]
# 		[string] $Message,

# 		[Parameter()]
# 		[ValidateSet('Info', 'Warning', 'Error')]
# 		[string] $Level = 'Info'
# 	)
# 	process {
# 		$Prefix, $Color = switch ($Level) {
# 			'Info'    { "INF ", [System.ConsoleColor]::White }
# 			'Warning' { "WARN", [System.ConsoleColor]::Yellow }
# 			'Error'   { "ERR ", [System.ConsoleColor]::Red }
# 			default   { "INF ", [System.ConsoleColor]::White }
# 		}

# 		$Now = Get-Date -DisplayHint Time

# 		Write-Host "$Now [" -NoNewline
# 		Write-Host $Level -ForegroundColor $Color -NoNewline
# 		Write-Host "] " -NoNewline
# 		Write-Host $Message -ForegroundColor White
# 	}
# }



# $Module = "HaloPSA"

# Push-Location $PSScriptRoot

# # Build the dotnet project and output to the bin directory
# Write-Log "Building the .NET project..."
# dotnet build $PSScriptRoot\src\$Module.csproj -o $PSScriptRoot\Output\$Module\bin

# # Copy module manifest and definition
# Copy-Item "$PSScriptRoot\$Module\*" "$PSScriptRoot\Output\$Module" -Recurse -Force

# # Import our module
# Write-Log "Importing the HaloPSA module..."
# if (Get-Module -Name $Module) {
# 	Remove-Module $Module -Force
# }

# Import-Module "$PSScriptRoot\Output\$Module\$Module.psd1" -Force
# Import-Module -Name HaloPSA

# # Pester Tests
# # Invoke-Pester "$PSScriptRoot\Tests"

# # Build Documentation
# $DocOutputFolder = "$PSScriptRoot\Docs"

# # If the docs folder is empty then we're building the docs for the first time
# # and it needs to be initialized.  If the docs folder has content, update the docs
# # rather than creating new.
# $DocItems = Get-ChildItem -Path $DocOutputFolder
# if ($DocItems.Length -eq 0) {
# 	$DocParams = @{
# 		Module = $Module
# 		OutputFolder = $DocOutputFolder
# 		AlphabeticParamsOrder = $true
# 		WithModulePage = $true
# 		ExcludeDontShow = $true
# 		Encoding = [System.Text.Encoding]::UTF8
# 	}

# 	New-MarkdownHelp @DocParams
# 	New-MarkdownAboutHelp -OutputFolder $DocOutputFolder -AboutName "HaloPSA"
# } else {
# 	$DocParams = @{
# 		Path = $DocOutputFolder
# 		RefreshModulePage = $true
# 		AlphabeticParamsOrder = $true
# 		UpdateInputOutput = $true
# 		ExcludeDontShow = $true
# 		LogPath = "$PSScriptRoot"
# 		Encoding = [System.Text.Encoding]::UTF8
# 	}

# 	Update-MarkdownHelpModule @DocParams
# }

# # Unload our module
# Remove-Module $Module -Force