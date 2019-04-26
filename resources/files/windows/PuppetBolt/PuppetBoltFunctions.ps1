Add-Type -TypeDefinition @"
public enum BoltOutputLevel
{
   Verbose,
   Debug,
   Trace
}
"@

Add-Type -TypeDefinition @"
public enum BoltRerunTypes
{
   all,
   failure,
   success
}
"@

function Convert-BoltParams {
    <#
    .SYNOPSIS
    This is an internal-only function used to parse parameters to CLI flags
    #>
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [object]  $Parameters,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltRerunTypes]  $Rerun,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [switch]  $Noop,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Description,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSL,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSLVerify,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $HostKeyCheck=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Username,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Password,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SSHPrivateKey,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $RunAs,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SudoPassword,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $Concurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $CompileConcurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ModulePath,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltDir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ConfigFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $InventoryFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SaveRerun,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Transport,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $ConnectTimeout,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $TTY,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Tmpdir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $Color,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltOutputLevel]  $OutputLevel,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [object]  $CommandString,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $PlanName,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $TaskName,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltCommand,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ScriptLocation,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $PuppetManifest,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Source,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Destination,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Targets,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Query
    )
    process {
        $_flags = ''
        if ($Parameters -ne $null) {
            $_flags += ' --params ' + "'$(($Parameters | ConvertTo-Json -Compress) -replace '"','\"')'"
        }
        if ($Rerun) {
            $_flags += " --rerun $Rerun"
        }
        if ($Noop) {
            $_flags += " --noop"
        }
        if ($Description) {
            $_flags += " --description $Description"
        }
        if ($SSL) {
            $_flags += ' --ssl'
        } else {
            $_flags += ' --no-ssl'
        }
        if ($SSLVerify) {
            $_flags += ' --ssl-verify'
        } else {
            $_flags += ' --no-ssl-verify'
        }
        if ($HostKeyCheck) {
            $_flags += ' --host-key-check'
        } else {
            $_flags += ' --no-host-key-check'
        }
        if ($Username) {
            $_flags += " --user $Username"
        }
        if ($Password) {
            $_flags += " --password $Password"
        }
        if ($SSHPrivateKey) {
            $_flags += " --private-key $SSHPrivateKey"
        }
        if ($RunAs) {
            $_flags += " --run-as $RunAs"
        }
        if ($SudoPassword) {
            $_flags += " --sudo-password $SudoPassword"
        }
        if ($Concurrency) {
            $_flags += " --concurrency $Concurrency"
        }
        if ($CompileConcurrency) {
            $_flags += " --compile-concurrency $CompileConcurrency"
        }
        if ($ModulePath) {
            $_flags += " --modulepath $ModulePath"
        }
        if ($BoltDir) {
            $_flags += " --boltdir $BoltDir"
        }
        if ($ConfigFile) {
            $_flags += " --configfile $ConfigFile"
        }
        if ($InventoryFile) {
            $_flags += " --inventoryfile $InventoryFile"
        }
        if ($SaveRerun) {
            $_flags += ' --save-rerun'
        } else {
            $_flags += ' --no-save-rerun'
        }
        if ($Transport) {
            $_flags += " --transport $Transport"
        }
        if ($ConnectTimeout) {
            $_flags += " --connect-timeout $ConnectTimeout"
        }
        if ($TTY) {
            $_flags += ' --tty'
        } else {
            $_flags += ' --no-tty'
        }
        if ($Tmpdir) {
            $_flags += " --tmpdir $Tmpdir"
        }
        if ($Color) {
            $_flags += ' --color'
        } else {
            $_flags += ' --no-color'
        }
        switch ($OutputLevel) {
            "Verbose" { $_flags += ' --verbose' }
            "Debug"   { $_flags += ' --verbose --debug' }
            "Trace"   { $_flags += ' --verbose --debug --trace' }
        }
        return $_flags
    }
}

function Invoke-BoltInternal {
    <#
    .SYNOPSIS
    This is an internal-only function to validate that either Targets or
    Query is present and then run a bolt command.
    #>
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [object]  $CommandString,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [object]  $Parameters,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltRerunTypes]  $Rerun,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [switch]  $Noop,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Description,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSL,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSLVerify,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $HostKeyCheck=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Username,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Password,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SSHPrivateKey,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $RunAs,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SudoPassword,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $Concurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $CompileConcurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ModulePath,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltDir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ConfigFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $InventoryFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SaveRerun,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Transport,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $ConnectTimeout,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $TTY,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Tmpdir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $Color,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltOutputLevel]  $OutputLevel,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $PlanName,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $TaskName,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltCommand,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ScriptLocation,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $PuppetManifest,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Source,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Destination,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Targets,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Query
    )
    begin {
        $_flags = Convert-BoltParams @PSBoundParameters
    }
    process {
        if ($Targets) {
            $_targets = "--nodes=$Targets"
        } elseif ($Query) {
            $_targets = "--query=$Query"
        } else {
            Write-Error "Must specify one of -Targets,-Query"
            throw
        }
        if ($OutputLevel) {
            $_result = Invoke-Expression "bolt $CommandString $_targets --format=json $_flags"
        } else {
            $_result = Invoke-Expression "bolt $CommandString $_targets --format=json $_flags" 2>$null
        }
        return ($_result | ConvertFrom-Json)
    }
}

function Invoke-BoltTask {
    <#
    .SYNOPSIS
    Execute Puppet Bolt task
    .DESCRIPTION
    This function will execute 'bolt task run <task>' on the targets specified by the -Targets
    or -Query parameter. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER TaskName
    The name of the bolt task to execute
    .PARAMETER Targets
    [One of -Targets or -Query is required] Identifies the targets to execute on.
    Enter a comma-separated list of node URIs or group names.
    Or read a target list from an input file '@<file>' or stdin '-'.
    Example: -Targets localhost,node_group,ssh://nix.com:23,winrm://windows.puppet.com
    * URI format is [protocol://]host[:port]
    * SSH is the default protocol; may be ssh, winrm, pcp, local, docker, remote
    * For Windows nodes, specify the winrm:// protocol if it has not be configured
    * For SSH, port defaults to `22`
    * For WinRM, port defaults to `5985` or `5986` based on the --[no-]ssl setting
    .PARAMETER Query
    [One of -Targets or -Query is required] Query PuppetDB to determine the targets
    .PARAMETER Parameters
    Parameters to a task or plan as:
    * a valid json string
    * powershell HashTable
    * a json file: '@<file>'
    * on stdin: '-'
    .PARAMETER Rerun
    Retry on nodes from the last run
    * 'all' all nodes that were part of the last run.
    * 'failure' nodes that failed in the last run.
    * 'success' nodes that succeeded in the last run.
    .PARAMETER Noop
    Execute a task that supports it in noop mode
    .PARAMETER Description
    Description to use for the job
    .PARAMETER User
    User to authenticate as
    .PARAMETER Password
    Password to authenticate with. Omit the value to prompt for the password.
    .PARAMETER SSHPrivateKey
    Private ssh key to authenticate with
    .PARAMETER HostKeyCheck
    Check host keys with SSH
    .PARAMETER SSL
    Use SSL with WinRM
    .PARAMETER SSLVerify
    Verify remote host SSL certificate with WinRM
    .PARAMETER RunAs
    User to run as using privilege escalation
    .PARAMETER SudoPassword
    Password for privilege escalation. Omit the value to prompt for the password.
    .PARAMETER Concurrency
    Maximum number of simultaneous connections (default: 100)
    .PARAMETER CompileConcurrency
    Maximum number of simultaneous manifest block compiles (default: number of cores)
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER InventoryFile
    Specify where to load inventory from (default: ~/.puppetlabs/bolt/inventory.yaml)
    .PARAMETER SaveRerun
    Whether to update the rerun file after this command.
    .PARAMETER Transport
    Specify a default transport: ssh, winrm, pcp, local, docker, remote
    .PARAMETER ConnectionTimeout
    Connection timeout (defaults vary)
    .PARAMETER TTY
    Request a pseudo TTY on targets that support it
    .PARAMETER Tmpdir
    The directory to upload and execute temporary files on the target
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory,ValueFromPipeline=$True,ValueFromPipelineByPropertyName,Position=0)]
        [string]  $TaskName,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Targets,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [object]  $Parameters,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Query,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltRerunTypes]  $Rerun,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [switch] $Noop,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Description,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSL=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSLVerify=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $HostKeyCheck=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Username,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Password,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SSHPrivateKey,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $RunAs,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SudoPassword,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $Concurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $CompileConcurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ModulePath,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltDir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ConfigFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $InventoryFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SaveRerun=$false,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Transport,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $ConnectTimeout,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $TTY=$false,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Tmpdir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $Color=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltOutputLevel]  $OutputLevel
    )
    process {
        return Invoke-BoltInternal -CommandString "task run $TaskName" @PSBoundParameters
    }
}

function Invoke-BoltPlan {
    <#
    .SYNOPSIS
    Execute Puppet Bolt task plan
    .DESCRIPTION
    This function will execute 'bolt plan run <plan>' on the targets specified by the -Targets
    or -Query parameter. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER PlanName
    The name of the bolt plan to execute
    .PARAMETER Targets
    [One of -Targets or -Query is required] Identifies the targets to execute on.
    Enter a comma-separated list of node URIs or group names.
    Or read a target list from an input file '@<file>' or stdin '-'.
    Example: -Targets localhost,node_group,ssh://nix.com:23,winrm://windows.puppet.com
    * URI format is [protocol://]host[:port]
    * SSH is the default protocol; may be ssh, winrm, pcp, local, docker, remote
    * For Windows nodes, specify the winrm:// protocol if it has not be configured
    * For SSH, port defaults to `22`
    * For WinRM, port defaults to `5985` or `5986` based on the --[no-]ssl setting
    .PARAMETER Query
    [One of -Targets or -Query is required] Query PuppetDB to determine the targets
    .PARAMETER Parameters
    Parameters to a task or plan as:
    * a valid json string
    * powershell HashTable
    * a json file: '@<file>'
    * on stdin: '-'
    .PARAMETER Rerun
    Retry on nodes from the last run
    * 'all' all nodes that were part of the last run.
    * 'failure' nodes that failed in the last run.
    * 'success' nodes that succeeded in the last run.
    .PARAMETER Noop
    Execute a task that supports it in noop mode
    .PARAMETER Description
    Description to use for the job
    .PARAMETER User
    User to authenticate as
    .PARAMETER Password
    Password to authenticate with. Omit the value to prompt for the password.
    .PARAMETER SSHPrivateKey
    Private ssh key to authenticate with
    .PARAMETER HostKeyCheck
    Check host keys with SSH
    .PARAMETER SSL
    Use SSL with WinRM
    .PARAMETER SSLVerify
    Verify remote host SSL certificate with WinRM
    .PARAMETER RunAs
    User to run as using privilege escalation
    .PARAMETER SudoPassword
    Password for privilege escalation. Omit the value to prompt for the password.
    .PARAMETER Concurrency
    Maximum number of simultaneous connections (default: 100)
    .PARAMETER CompileConcurrency
    Maximum number of simultaneous manifest block compiles (default: number of cores)
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER InventoryFile
    Specify where to load inventory from (default: ~/.puppetlabs/bolt/inventory.yaml)
    .PARAMETER SaveRerun
    Whether to update the rerun file after this command.
    .PARAMETER Transport
    Specify a default transport: ssh, winrm, pcp, local, docker, remote
    .PARAMETER ConnectionTimeout
    Connection timeout (defaults vary)
    .PARAMETER TTY
    Request a pseudo TTY on targets that support it
    .PARAMETER Tmpdir
    The directory to upload and execute temporary files on the target
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory,ValueFromPipeline=$True,ValueFromPipelineByPropertyName,Position=0)]
        [string]  $PlanName,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Targets,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [object]  $Parameters,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Query,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltRerunTypes]  $Rerun,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [switch]  $Noop,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Description,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSL=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSLVerify=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $HostKeyCheck=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Username,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Password,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SSHPrivateKey,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $RunAs,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SudoPassword,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $Concurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $CompileConcurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ModulePath,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltDir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ConfigFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $InventoryFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SaveRerun=$false,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Transport,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $ConnectTimeout,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $TTY=$false,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Tmpdir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $Color=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltOutputLevel]  $OutputLevel
    )
    process {
        return Invoke-BoltInternal -CommandString "plan run $PlanName" @PSBoundParameters
    }
}

function Invoke-BoltFileUpload {
    <#
    .SYNOPSIS
    Execute Puppet Bolt file upload
    .DESCRIPTION
    This function will execute 'bolt file upload <source> <dest>' on the targets specified by the -Targets
    or -Query parameter. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER Source
    Location of the source file to upload
    .PARAMETER Destination
    Location on the remote target where the file should be uploaded to
    .PARAMETER Targets
    [One of -Targets or -Query is required] Identifies the targets to execute on.
    Enter a comma-separated list of node URIs or group names.
    Or read a target list from an input file '@<file>' or stdin '-'.
    Example: -Targets localhost,node_group,ssh://nix.com:23,winrm://windows.puppet.com
    * URI format is [protocol://]host[:port]
    * SSH is the default protocol; may be ssh, winrm, pcp, local, docker, remote
    * For Windows nodes, specify the winrm:// protocol if it has not be configured
    * For SSH, port defaults to `22`
    * For WinRM, port defaults to `5985` or `5986` based on the --[no-]ssl setting
    .PARAMETER Query
    [One of -Targets or -Query is required] Query PuppetDB to determine the targets
    .PARAMETER Parameters
    Parameters to a task or plan as:
    * a valid json string
    * powershell HashTable
    * a json file: '@<file>'
    * on stdin: '-'
    .PARAMETER Rerun
    Retry on nodes from the last run
    * 'all' all nodes that were part of the last run.
    * 'failure' nodes that failed in the last run.
    * 'success' nodes that succeeded in the last run.
    .PARAMETER Noop
    Execute a task that supports it in noop mode
    .PARAMETER Description
    Description to use for the job
    .PARAMETER User
    User to authenticate as
    .PARAMETER Password
    Password to authenticate with. Omit the value to prompt for the password.
    .PARAMETER SSHPrivateKey
    Private ssh key to authenticate with
    .PARAMETER HostKeyCheck
    Check host keys with SSH
    .PARAMETER SSL
    Use SSL with WinRM
    .PARAMETER SSLVerify
    Verify remote host SSL certificate with WinRM
    .PARAMETER RunAs
    User to run as using privilege escalation
    .PARAMETER SudoPassword
    Password for privilege escalation. Omit the value to prompt for the password.
    .PARAMETER Concurrency
    Maximum number of simultaneous connections (default: 100)
    .PARAMETER CompileConcurrency
    Maximum number of simultaneous manifest block compiles (default: number of cores)
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER InventoryFile
    Specify where to load inventory from (default: ~/.puppetlabs/bolt/inventory.yaml)
    .PARAMETER SaveRerun
    Whether to update the rerun file after this command.
    .PARAMETER Transport
    Specify a default transport: ssh, winrm, pcp, local, docker, remote
    .PARAMETER ConnectionTimeout
    Connection timeout (defaults vary)
    .PARAMETER TTY
    Request a pseudo TTY on targets that support it
    .PARAMETER Tmpdir
    The directory to upload and execute temporary files on the target
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory,ValueFromPipeline=$True,ValueFromPipelineByPropertyName,Position=0)]
        [string]  $Source,

        [parameter(Mandatory,ValueFromPipeline=$True,ValueFromPipelineByPropertyName,Position=1)]
        [string]  $Destination,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Targets,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Query,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltRerunTypes]  $Rerun,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [switch] $Noop,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Description,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSL=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SSLVerify=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $HostKeyCheck=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Username,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Password,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SSHPrivateKey,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $RunAs,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $SudoPassword,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $Concurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $CompileConcurrency,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ModulePath,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltDir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ConfigFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $InventoryFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $SaveRerun=$false,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Transport,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [int]     $ConnectTimeout,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $TTY=$false,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $Tmpdir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $Color=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltOutputLevel]  $OutputLevel
    )
    process {
        return Invoke-BoltInternal -CommandString "file upload $Source $Destination" @PSBoundParameters
    }
}

function Invoke-BoltCommandRun {
    <#
    .SYNOPSIS
    Execute command on remote host with Puppet Bolt
    .DESCRIPTION
    This function will execute 'bolt command run <command>' on the targets specified by the -Targets
    or -Query parameter. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER Command
    The command to execute on remote targets
    .PARAMETER Targets
    [One of -Targets or -Query is required] Identifies the targets to execute on.
    Enter a comma-separated list of node URIs or group names.
    Or read a target list from an input file '@<file>' or stdin '-'.
    Example: -Targets localhost,node_group,ssh://nix.com:23,winrm://windows.puppet.com
    * URI format is [protocol://]host[:port]
    * SSH is the default protocol; may be ssh, winrm, pcp, local, docker, remote
    * For Windows nodes, specify the winrm:// protocol if it has not be configured
    * For SSH, port defaults to `22`
    * For WinRM, port defaults to `5985` or `5986` based on the --[no-]ssl setting
    .PARAMETER Query
    [One of -Targets or -Query is required] Query PuppetDB to determine the targets
    .PARAMETER Parameters
    Parameters to a task or plan as:
    * a valid json string
    * powershell HashTable
    * a json file: '@<file>'
    * on stdin: '-'
    .PARAMETER Rerun
    Retry on nodes from the last run
    * 'all' all nodes that were part of the last run.
    * 'failure' nodes that failed in the last run.
    * 'success' nodes that succeeded in the last run.
    .PARAMETER Noop
    Execute a task that supports it in noop mode
    .PARAMETER Description
    Description to use for the job
    .PARAMETER User
    User to authenticate as
    .PARAMETER Password
    Password to authenticate with. Omit the value to prompt for the password.
    .PARAMETER SSHPrivateKey
    Private ssh key to authenticate with
    .PARAMETER HostKeyCheck
    Check host keys with SSH
    .PARAMETER SSL
    Use SSL with WinRM
    .PARAMETER SSLVerify
    Verify remote host SSL certificate with WinRM
    .PARAMETER RunAs
    User to run as using privilege escalation
    .PARAMETER SudoPassword
    Password for privilege escalation. Omit the value to prompt for the password.
    .PARAMETER Concurrency
    Maximum number of simultaneous connections (default: 100)
    .PARAMETER CompileConcurrency
    Maximum number of simultaneous manifest block compiles (default: number of cores)
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER InventoryFile
    Specify where to load inventory from (default: ~/.puppetlabs/bolt/inventory.yaml)
    .PARAMETER SaveRerun
    Whether to update the rerun file after this command.
    .PARAMETER Transport
    Specify a default transport: ssh, winrm, pcp, local, docker, remote
    .PARAMETER ConnectionTimeout
    Connection timeout (defaults vary)
    .PARAMETER TTY
    Request a pseudo TTY on targets that support it
    .PARAMETER Tmpdir
    The directory to upload and execute temporary files on the target
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
 param(
     [parameter(Mandatory,ValueFromPipeline=$True,ValueFromPipelineByPropertyName,Position=0)]
     [string]  $Command,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Targets,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Query,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltRerunTypes]  $Rerun,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [switch] $Noop,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Description,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SSL=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SSLVerify=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $HostKeyCheck=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Username,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Password,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $SSHPrivateKey,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $RunAs,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $SudoPassword,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $Concurrency,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $CompileConcurrency,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ModulePath,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $BoltDir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ConfigFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $InventoryFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SaveRerun=$false,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Transport,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $ConnectTimeout,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $TTY=$false,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Tmpdir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $Color=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltOutputLevel]  $OutputLevel
 )
 begin {
     $_flags = Convert-BoltParams @PSBoundParameters
 }
 process {
     return Invoke-BoltInternal -CommandString "command run $Command" @PSBoundParameters
 }
}

function Invoke-BoltApply {
    <#
    .SYNOPSIS
    Execute Puppet apply on targets with Puppet Bolt
    .DESCRIPTION
    This function will execute 'bolt apply <manifest>' on the targets specified by the -Targets
    or -Query parameter. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER PuppetManifest
    The location of the puppet manifest to apply on targets
    .PARAMETER Targets
    [One of -Targets or -Query is required] Identifies the targets to execute on.
    Enter a comma-separated list of node URIs or group names.
    Or read a target list from an input file '@<file>' or stdin '-'.
    Example: -Targets localhost,node_group,ssh://nix.com:23,winrm://windows.puppet.com
    * URI format is [protocol://]host[:port]
    * SSH is the default protocol; may be ssh, winrm, pcp, local, docker, remote
    * For Windows nodes, specify the winrm:// protocol if it has not be configured
    * For SSH, port defaults to `22`
    * For WinRM, port defaults to `5985` or `5986` based on the --[no-]ssl setting
    .PARAMETER Query
    [One of -Targets or -Query is required] Query PuppetDB to determine the targets
    .PARAMETER Parameters
    Parameters to a task or plan as:
    * a valid json string
    * powershell HashTable
    * a json file: '@<file>'
    * on stdin: '-'
    .PARAMETER Rerun
    Retry on nodes from the last run
    * 'all' all nodes that were part of the last run.
    * 'failure' nodes that failed in the last run.
    * 'success' nodes that succeeded in the last run.
    .PARAMETER Noop
    Execute a task that supports it in noop mode
    .PARAMETER Description
    Description to use for the job
    .PARAMETER User
    User to authenticate as
    .PARAMETER Password
    Password to authenticate with. Omit the value to prompt for the password.
    .PARAMETER SSHPrivateKey
    Private ssh key to authenticate with
    .PARAMETER HostKeyCheck
    Check host keys with SSH
    .PARAMETER SSL
    Use SSL with WinRM
    .PARAMETER SSLVerify
    Verify remote host SSL certificate with WinRM
    .PARAMETER RunAs
    User to run as using privilege escalation
    .PARAMETER SudoPassword
    Password for privilege escalation. Omit the value to prompt for the password.
    .PARAMETER Concurrency
    Maximum number of simultaneous connections (default: 100)
    .PARAMETER CompileConcurrency
    Maximum number of simultaneous manifest block compiles (default: number of cores)
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER InventoryFile
    Specify where to load inventory from (default: ~/.puppetlabs/bolt/inventory.yaml)
    .PARAMETER SaveRerun
    Whether to update the rerun file after this command.
    .PARAMETER Transport
    Specify a default transport: ssh, winrm, pcp, local, docker, remote
    .PARAMETER ConnectionTimeout
    Connection timeout (defaults vary)
    .PARAMETER TTY
    Request a pseudo TTY on targets that support it
    .PARAMETER Tmpdir
    The directory to upload and execute temporary files on the target
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
 param(
     [parameter(Mandatory,ValueFromPipeline=$True,ValueFromPipelineByPropertyName,Position=0)]
     [string]  $PuppetManifest,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Targets,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Query,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltRerunTypes]  $Rerun,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [switch] $Noop,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Description,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SSL=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SSLVerify=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $HostKeyCheck=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Username,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Password,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $SSHPrivateKey,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $RunAs,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $SudoPassword,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $Concurrency,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $CompileConcurrency,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ModulePath,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $BoltDir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ConfigFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $InventoryFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SaveRerun=$false,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Transport,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $ConnectTimeout,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $TTY=$false,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Tmpdir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $Color=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltOutputLevel]  $OutputLevel
 )
 begin {
     $_flags = Convert-BoltParams @PSBoundParameters
 }
 process {
     return Invoke-BoltInternal -CommandString "apply $PuppetManifest" @PSBoundParameters
 }
}

function Invoke-BoltScriptRun {
    <#
    .SYNOPSIS
    Execute script on targets with Puppet Bolt
    .DESCRIPTION
    This function will execute 'bolt script run <script>' on the targets specified by the -Targets
    or -Query parameter. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER ScriptLocation
    The location of the script to run on targets
    .PARAMETER Targets
    [One of -Targets or -Query is required] Identifies the targets to execute on.
    Enter a comma-separated list of node URIs or group names.
    Or read a target list from an input file '@<file>' or stdin '-'.
    Example: -Targets localhost,node_group,ssh://nix.com:23,winrm://windows.puppet.com
    * URI format is [protocol://]host[:port]
    * SSH is the default protocol; may be ssh, winrm, pcp, local, docker, remote
    * For Windows nodes, specify the winrm:// protocol if it has not be configured
    * For SSH, port defaults to `22`
    * For WinRM, port defaults to `5985` or `5986` based on the --[no-]ssl setting
    .PARAMETER Query
    [One of -Targets or -Query is required] Query PuppetDB to determine the targets
    .PARAMETER Parameters
    Parameters to a task or plan as:
    * a valid json string
    * powershell HashTable
    * a json file: '@<file>'
    * on stdin: '-'
    .PARAMETER Rerun
    Retry on nodes from the last run
    * 'all' all nodes that were part of the last run.
    * 'failure' nodes that failed in the last run.
    * 'success' nodes that succeeded in the last run.
    .PARAMETER Noop
    Execute a task that supports it in noop mode
    .PARAMETER Description
    Description to use for the job
    .PARAMETER User
    User to authenticate as
    .PARAMETER Password
    Password to authenticate with. Omit the value to prompt for the password.
    .PARAMETER SSHPrivateKey
    Private ssh key to authenticate with
    .PARAMETER HostKeyCheck
    Check host keys with SSH
    .PARAMETER SSL
    Use SSL with WinRM
    .PARAMETER SSLVerify
    Verify remote host SSL certificate with WinRM
    .PARAMETER RunAs
    User to run as using privilege escalation
    .PARAMETER SudoPassword
    Password for privilege escalation. Omit the value to prompt for the password.
    .PARAMETER Concurrency
    Maximum number of simultaneous connections (default: 100)
    .PARAMETER CompileConcurrency
    Maximum number of simultaneous manifest block compiles (default: number of cores)
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER InventoryFile
    Specify where to load inventory from (default: ~/.puppetlabs/bolt/inventory.yaml)
    .PARAMETER SaveRerun
    Whether to update the rerun file after this command.
    .PARAMETER Transport
    Specify a default transport: ssh, winrm, pcp, local, docker, remote
    .PARAMETER ConnectionTimeout
    Connection timeout (defaults vary)
    .PARAMETER TTY
    Request a pseudo TTY on targets that support it
    .PARAMETER Tmpdir
    The directory to upload and execute temporary files on the target
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
 param(
     [parameter(Mandatory,ValueFromPipeline=$True,ValueFromPipelineByPropertyName,Position=0)]
     [string]  $ScriptLocation,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Targets,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Query,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltRerunTypes]  $Rerun,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [switch] $Noop,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Description,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SSL=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SSLVerify=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $HostKeyCheck=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Username,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Password,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $SSHPrivateKey,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $RunAs,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $SudoPassword,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $Concurrency,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $CompileConcurrency,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ModulePath,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $BoltDir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ConfigFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $InventoryFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $SaveRerun=$false,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Transport,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [int]     $ConnectTimeout,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $TTY=$false,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $Tmpdir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $Color=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltOutputLevel]  $OutputLevel
 )
 begin {
     $_flags = Convert-BoltParams @PSBoundParameters
 }
 process {
     return Invoke-BoltInternal -CommandString "script run $ScriptLocation" @PSBoundParameters
 }
}

function Read-BoltPlans {
    <#
    .SYNOPSIS
    Read all bolt plans available to Puppet Bolt
    .DESCRIPTION
    This function will execute 'bolt plan show <plan>' to list available plans or details
    on a specific plan. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER PlanName
    Name of the bolt plan to show details on
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
 param(
     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ModulePath,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $BoltDir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ConfigFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $Color=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltOutputLevel]  $OutputLevel
 )
 begin {
     $_flags = Convert-BoltParams @PSBoundParameters
 }
 process {
     if ($OutputLevel) {
         $_result = Invoke-Expression "bolt plan show --format=json $_flags"
     } else {
         $_result = Invoke-Expression "bolt plan show --format=json $_flags" 2>$null
     }
     return ($_result | ConvertFrom-Json)
 }
}

function Read-BoltTasks {
    <#
    .SYNOPSIS
    Read all bolt tasks available to Puppet Bolt
    .DESCRIPTION
    This function will execute 'bolt task show <task>' to list available task or details
    on a specific task. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER TaskName
    Name of the bolt task to show details on
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
 param(
     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ModulePath,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $BoltDir,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [string]  $ConfigFile,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [bool]    $Color=$true,

     [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
     [BoltOutputLevel]  $OutputLevel
 )
 begin {
     $_flags = Convert-BoltParams @PSBoundParameters
 }
 process {
     if ($OutputLevel) {
         $_result = Invoke-Expression "bolt task show --format=json $_flags"
     } else {
         $_result = Invoke-Expression "bolt task show --format=json $_flags" 2>$null
     }
     return ($_result | ConvertFrom-Json)
 }
}

function Read-BoltModules {
    <#
    .SYNOPSIS
    Read all modules available to Puppet Bolt
    .DESCRIPTION
    This function will execute 'bolt puppetfile show-modules' to list available modules.
    Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ModulePath,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltDir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ConfigFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $Color=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltOutputLevel]  $OutputLevel
    )
    begin {
        $_flags = Convert-BoltParams @PSBoundParameters
    }
    process {
        if ($OutputLevel) {
            $_result = Invoke-Expression "bolt puppetfile show-modules --format=json $_flags"
        } else {
            $_result = Invoke-Expression "bolt puppetfile show-modules --format=json $_flags" 2>$null
        }
        return ($_result | ConvertFrom-Json)
    }
}

function Install-BoltModules {
    <#
    .SYNOPSIS
    Install bolt modules from puppetfile
    .DESCRIPTION
    This function will execute 'bolt puppetfile install' to install any modules required
    in the puppetfile. Puppet Bolt (https://puppet.com/products/bolt) is an agentless automation
    solution for running ad-hoc tasks and operations on remote targets
    .PARAMETER ModulePath
    List of directories containing modules, separated by ';'
    .PARAMETER BoltDir
    Specify what Boltdir to load config from (default: autodiscovered from current working dir)
    .PARAMETER ConfigFile
    Specify where to load config from (default: ~/.puppetlabs/bolt/bolt.yaml)
    .PARAMETER Color
    Whether to show output in color
    .PARAMETER OutputLevel
    Level of output logging to display (defaults to no output). Must be one of:
    * 'Verbose' only verbose logging
    * 'Debug' both verbose and debug logging
    * 'Trace' all of verbose, debug, and stacktrace logging
    #>
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ModulePath,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $BoltDir,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [string]  $ConfigFile,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [bool]    $Color=$true,

        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName)]
        [BoltOutputLevel]  $OutputLevel
    )
    begin {
        $_flags = Convert-BoltParams @PSBoundParameters
    }
    process {
        if ($OutputLevel) {
            $_result = Invoke-Expression "bolt puppetfile install --format=json $_flags"
        } else {
            $_result = Invoke-Expression "bolt puppetfile install --format=json $_flags" 2>$null
        }
        return ($_result | ConvertFrom-Json)
    }
}

Export-ModuleMember -Function Invoke-BoltPlan
Export-ModuleMember -Function Invoke-BoltTask
Export-ModuleMember -Function Invoke-BoltCommandRun
Export-ModuleMember -Function Invoke-BoltScriptRun
Export-ModuleMember -Function Invoke-BoltApply
Export-ModuleMember -Function Invoke-BoltFileUpload
Export-ModuleMember -Function Read-BoltPlans
Export-ModuleMember -Function Read-BoltTasks
Export-ModuleMember -Function Read-BoltModules
Export-ModuleMember -Function Install-BoltModules
