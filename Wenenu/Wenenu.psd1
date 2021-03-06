@{
RootModule = 'Wenenu.psm1'

ModuleVersion = '0.1.1'

# Supported PSEditions
# CompatiblePSEditions = @()

GUID = 'cb4497b8-4ff4-4404-b635-0d2c02f4c9fc'

Author = 'Wenenu'

CompanyName = 'NMI-net LTD'

Copyright = '(c) 2022 Wenenu. All rights reserved.'

Description = 'PowerShell script collection to handle Wenenu resources'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

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

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Get-WenenuScenario',
    'Get-WenenuScenarioConfig',
    'Set-WenenuScenarioConfig',
    'New-WenenuScenario',
    'Get-WenenuTimeZones'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
DscResourcesToExport = @()

# List of all modules packaged with this module
ModuleList = @()

# List of all files packaged with this module
FileList = @('Wenenu.psm1')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        Prerelease = '-preview'

        Tags = @('Wenenu', 'ResourceManager', 'AzureBackup', 'BackupTesting')

        license = 'https://github.com/nmi-net/wenenu-powershell/blob/main/LICENSE'

        ProjectUri = 'https://github.com/nmi-net/wenenu-powershell'

        icon = 'https://wenenuwebsite.blob.core.windows.net/public/wenenu_logo.png'

        # ReleaseNotes of this module
        # ReleaseNotes = ''
    }

}

HelpInfoURI = 'https://github.com/nmi-net/wenenu-powershell/blob/main/README.md'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''
}