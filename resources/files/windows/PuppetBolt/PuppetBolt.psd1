@{
    ModuleToProcess   = 'PuppetBolt.psm1'
    ModuleVersion     = '0.2.0'
    GUID              = 'CF5DDF2B-F69B-4A2B-B7E4-B9A981D7415D'
    Author            = "Puppet, Inc"
    CompanyName       = "Puppet, Inc"
    Copyright         = '(c) 2017 Puppet, Inc. All rights reserved'
    FunctionsToExport = @(
        'bolt',
        'Invoke-BoltPlan',
        'Invoke-BoltTask',
        'Invoke-BoltCommandRun',
        'Invoke-BoltScriptRun',
        'Invoke-BoltApply',
        'Invoke-BoltFileUpload',
        'Read-BoltPlans',
        'Read-BoltTasks',
        'Read-BoltModules',
        'Install-BoltModules'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            # Tags = @()
            LicenseUri   = 'https://github.com/puppetlabs/bolt/blob/master/LICENSE'
            ProjectUri   = 'https://github.com/puppetlabs/bolt'
            # IconUri = ''
            ReleaseNotes = 'https://puppet.com/docs/bolt/0.x/bolt_release_notes.html'
        }
    }
}
