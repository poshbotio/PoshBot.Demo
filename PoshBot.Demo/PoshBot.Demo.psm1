
function Random {
    <#
    .SYNOPSIS
        Get a random thing
    .EXAMPLE
        !random
    #>
    [cmdletbinding()]
    param()

    Write-Output "A random what?"
    Write-Output "Sub commands:"
    Write-Output "random insult`nrandom fact`nrandom joke`nrandom quote"
}

function Random-number {
    <#
    .SYNOPSIS
        Get a random number
    .EXAMPLE
        !random number [--min 42] [--max 8675309]
    #>
    [PoshBot.BotCommand(
        Aliases = ('rand', 'rnd')
    )]
    [cmdletbinding()]
    param(
        [int]$Min = 1,
        [int]$Max = 100
    )

    Get-Random -Minimum $min -Maximum $Max
}

function Random-Insult {
    <#
    .SYNOPSIS
        Send a random insult to someone
    .EXAMPLE
        !random-insult [--who <bob>]
    #>
    [PoshBot.BotCommand(
        CommandName = 'insult'
    )]
    [cmdletbinding()]
    param(
        [string]$Who
    )

    $html = Invoke-WebRequest -Uri 'http://www.randominsults.net/'
    $insult = $html.ParsedHtml.getElementById('AutoNumber1').textContent

    if ($PSBoundParameters.ContainsKey('Who')) {
        $who = $who.TrimStart('@')
        Write-Output "Hey @$Who! $insult"
    } else {
        Write-Output $insult
    }
}

function Random-Fact {
    <#
    .SYNOPSIS
        Gets a random fact
    .EXAMPLE
        !random-fact
    #>
    [PoshBot.BotCommand(
        CommandName = 'fact'
    )]
    [cmdletbinding()]
    param()

    $html = Invoke-WebRequest -Uri 'http://www.randomfunfacts.com/'
    $fact = $html.ParsedHtml.getElementById('AutoNumber1').textContent
    return $fact
}

function Random-Joke {
    <#
    .SYNOPSIS
        Gets a random joke
    .EXAMPLE
        !random-joke
    #>
    [PoshBot.BotCommand(
        CommandName = 'joke'
    )]
    [cmdletbinding()]
    param()

    $html = Invoke-WebRequest -Uri 'http://www.randomfunnyjokes.com/'
    $joke = $html.ParsedHtml.getElementById('AutoNumber1').textContent
    return $joke
}

function Random-Quote {
    <#
    .SYNOPSIS
        Gets a quote from a famous person
    .EXAMPLE
        !random-quote
    #>
    [PoshBot.BotCommand(
        CommandName = 'Quote'
    )]
    [cmdletbinding()]
    param()

    $html = Invoke-WebRequest -Uri 'http://www.quotability.com/'
    $quote = $html.ParsedHtml.getElementById('AutoNumber1').textContent
    return $quote
}

function Roll-Dice {
    <#
    .SYNOPSIS
        Roll one or more (n) sided dice
    .EXAMPLE
        !roll-dice [--dice 2d20] [--bonus 5]
    #>
    [PoshBot.BotCommand(Permissions = 'dice-master')]
    [cmdletbinding()]
    param(
        [parameter(position = 0)]
        [string]$Dice = '2d20',

        [parameter(position = 1)]
        [int]$Bonus = 0
    )
    $quantity, $faces = $Dice -split 'd'
    $total = (1..$quantity | ForEach-Object {
        Get-Random -Minimum $quantity -Maximum ([int]$faces * 2)
    } | Measure-Object -Sum).Sum

    [pscustomobject]@{
        Bonus = [int]$bonus
        Total = ([int]$bonus + $total)
    }
}

function Shipit {
    <#
    .SYNOPSIS
        Display a motivational squirrel
    .EXAMPLE
        !shipit
    #>
    [PoshBot.BotCommand(
        Command = $false,
        CommandName = 'shipit',
        TriggerType = 'regex',
        Regex = 'shipit'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments)]
        $Dummy
    )

    $squirrels = @(
        'http://28.media.tumblr.com/tumblr_lybw63nzPp1r5bvcto1_500.jpg',
        'http://i.imgur.com/DPVM1.png',
        'http://d2f8dzk2mhcqts.cloudfront.net/0772_PEW_Roundup/09_Squirrel.jpg',
        'http://www.cybersalt.org/images/funnypictures/s/supersquirrel.jpg',
        'http://www.zmescience.com/wp-content/uploads/2010/09/squirrel.jpg',
        'https://dl.dropboxusercontent.com/u/602885/github/sniper-squirrel.jpg',
        'http://1.bp.blogspot.com/_v0neUj-VDa4/TFBEbqFQcII/AAAAAAAAFBU/E8kPNmF1h1E/s640/squirrelbacca-thumb.jpg',
        'https://dl.dropboxusercontent.com/u/602885/github/soldier-squirrel.jpg',
        'https://dl.dropboxusercontent.com/u/602885/github/squirrelmobster.jpeg',
        'http://i.imgur.com/tIQluOd.jpg"',
        'http://i.imgur.com/PIQBHKA.jpg',
        'http://i.imgur.com/Qp8iF6l.jpg',
        'http://i.imgur.com/I7drYFb.jpg',
        'http://i.imgur.com/1obU7mz.jpg'
    )

    Write-Output $squirrels | Get-Random
}

function Cookies {
    <#
    .SYNOPSIS
        Respond to cookies
    #>
    [PoshBot.BotCommand(
        Command = $false,
        CommandName = 'cookies',
        TriggerType = 'regex',
        Regex = 'cookies'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments)]
        $Dummy
    )

    Write-Output 'Did someone mention cookies? I love cookies! Nom Nom Nom!'
}

function ChannelTopicChange {
    <#
    .SYNOPSIS
        Responds to channel topic change events
    #>
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'event',
        MessageType = 'Message',
        MessageSubType = 'ChannelTopicChanged'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments)]
        $Dummy
    )

    Write-Output 'I kind of liked the old topic'
}

function ChannelPurposeChange {
    <#
    .SYNOPSIS
        Responds to channel topic change events
    #>
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'event',
        MessageType = 'Message',
        MessageSubType = 'ChannelPurposeChanged'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments)]
        $Dummy
    )

    Write-Output 'So we have a new purpose in live huh?'
}

function WelcomeUserToRoom {
    <#
    .SYNOPSIS
        Responds to channel join events with a friendly message
    #>
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'event',
        MessageType = 'Message',
        MessageSubType = 'ChannelJoined'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments)]
        $Dummy
    )

    Write-Output 'Greetings! We were just talking about you.'
}

function SayGoodbyeTouser {
    <#
    .SYNOPSIS
        Say goodbye to a user when they leave a channel
    #>
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'event',
        MessageType = 'Message',
        MessageSubType = 'ChannelLeft'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments)]
        $Dummy
    )

    Write-Output 'Good riddance. I never liked that person anyway.'
}

function GoldStar {
    <#
    .SYNOPSIS
        Say goodbye to a user when they leave a channel
    #>
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'event',
        MessageType = 'StarAdded'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments)]
        $Dummy
    )

    Write-Output 'Hey everyone look! Someone got a gold star :)'
}

function Start-LongRunningCommand {
    <#
    .SYNOPSIS
        Start a long running command
    .EXAMPLE
        !start-longrunningcommand [--seconds 20]
    #>
    [cmdletbinding()]
    param(
        [parameter(position = 0)]
        [int]$Seconds = 10
    )

    Start-Sleep -Seconds $Seconds
    Write-Output "Command finished after [$Seconds] seconds"
}

function Bad-Command {
    <#
    .SYNOPSIS
        Intentionally throws errors
    .EXAMPLE
        !bad-command
    #>
    [cmdletbinding()]
    param()

    Write-Error -Message "I'm error number one"
    Write-Error -Message "I'm error number two"
}

function Get-Foo {
    <#
    .SYNOPSIS
        Gets parameter value from bot configuration
    .EXAMPLE
        !get-foo
    #>
    [cmdletbinding()]
    param(
        [PoshBot.FromConfig('Config1')]
        [parameter(Mandatory)]
        [string]$Config1
    )

    Write-Output "[$Config1] was passed in from bot configuration"
}

function Create-VM {
    <#
    .SYNOPSIS
        Creates a new VM
    .EXAMPLE
        !create-vm --name server01 -vcpu 2 -ram 1024
    #>
    [cmdletbinding()]
    param(
        [string]$Name = (new-guid).ToString().split('-')[4],
        [string]$Type = 'Win2016Std',
        [int]$vCPU = 1,
        [int]$RAM = 1024
    )

    $r = [pscustomobject]@{
        Name = $Name
        vCPU = $vCPU
        RAM = $RAM
        Type = $Type
        Location = 'Headquarters'
        IPAddress = '10.11.12.13'
    }

    New-PoshBotCardResponse -Title "VM [$Name] Created" -Text ($r | Format-List -Property * | Out-String)
}

function New-CNAME {
    <#
    .SYNOPSIS
        Creates a new CNAME DNS record
    .EXAMPLE
        !new-cname --name server01 --hostname randomname.mydomain.tld
    #>
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [parameter(Mandatory = $true, Position = 0)]
        [string]$Hostname
    )

    return "OK. CNAME [$Name] -> [$Hostname] created."
}

function Invoke-DeployMyApp {
    <#
    .SYNOPSIS
        Deploys MyApp to an environment
    .EXAMPLE
        !deploy-myapp --environment prod
    #>
    [PoshBot.BotCommand(
        CommandName = 'Deploy-MyApp'
    )]
    [cmdletbinding()]
    param(
        [validateSet('prod', 'staging', 'dev')]
        [string]$Environment = 'dev'
    )

    'Solving for (x)............[OK]'
    'Compiling compilers........[OK]'
    'Inverting matrices.........[OK]'
    'Scheduling hipsters........[OK]'
    'Finding Nemo...............[OK]'
    'Calculating Pi.............[OK]'
    'Reticulating splines.......[OK]'
    "Ok Boss. Deployment to [$Environment] underway. Detailed status is here https://deploy.mydomain.tld/id=234593"
}

function Get-CommandContext {
    [cmdletbinding()]
    param()

    New-PoshBotTextResponse -Text ($global:PoshBotContext | ConvertTo-Json) -AsCode
}

function Get-ADUserViaSlack {
    <#
    .SYNOPSIS
        Gets an AD user
    .EXAMPLE
        !get-aduser --name joe
    #>
    [PoshBot.BotCommand(
        CommandName = 'Get-ADUser',
        Aliases = ('gu', 'queryad')
    )]
    [cmdletbinding()]
    param(
        [string]$Name
    )

    $o = [pscustomobject]@{
        Name = $Name
        DisplayName = 'Joe User'
    }
    write-output ($o | Format-List | Out-String)
}

function Get-MultipleThings {
    <#
    .SYNOPSIS
        Accepts multple values for a parameter
    .EXAMPLE
        !get-multplethings --thing1 foo, bar --thing2 'asdf', 'qwerty'
    #>
    [cmdletbinding()]
    param(
        [string[]]$Thing1,
        [string[]]$Thing2
    )

    Write-Output "Thing1: $($Thing1 | Format-List | Out-String)"
    Write-Output "Thing2: $($Thing2 | Format-List | Out-String)"
}

function Remove-Stuff {
    <#
    .SYNOPSIS
        Test switch parameters
    .EXAMPLE
        !get-switches --force
    #>
    [cmdletbinding()]
    param(
        [parameter(Mandatory, position = 0)]
        [string[]]$Name,

        [switch]$Force
    )

    if (-not $Force) {
        New-PoshBotCardResponse -Type Warning -Text "Are you sure you want to remove [$($Name -join ',')]? Use the --Force if you do."
    } else {
        $msg = @()
        foreach ($item in $Name) {
            $msg += "Removed [$item]"
        }
        New-PoshBotCardResponse -Type Normal -Text ($msg | Format-List | Out-String)
    }
}

function Upload-Something {
    [cmdletbinding()]
    param(
        [string]$Title,

        [switch]$Private
    )

    $myObj = [pscustomobject]@{
        value1 = 'foo'
        value2 = 'bar'
    }

    $csv = Join-Path -Path $env:TEMP -ChildPath "$((New-Guid).ToString()).csv"
    $myObj | Export-Csv -Path $csv -NoTypeInformation

    $params = @{
        Path = $csv
        DM = $PSBoundParameters.ContainsKey('Private')
    }
    if ($PSBoundParameters.ContainsKey('Title')) {
        $params.Title = $Title
    }

    New-PoshBotTextResponse ($params.Values)

    New-PoshBotFileUpload @params
}

function Get-SecretPlan {
    [cmdletbinding()]
    param()

    (1..3) | Foreach-Object {
        $myObj = [pscustomobject]@{
            Title = "Secret moon base plan $_"
            Description = 'Plans for secret base on the dark side of the moon'
        }
        $csv = Join-Path -Path $env:TEMP -ChildPath "$((New-Guid).ToString()).csv"
        $myObj | Export-Csv -Path $csv -NoTypeInformation
        New-PoshBotFileUpload -Path $csv -Title "YourEyesOnly_$($_).csv"
    }
}

function Get-ProcessChart {
    <#
    .SYNOPSIS
        Get Excel file of process memory usage by company
    .EXAMPLE
        !get-processchart
    #>
    [cmdletbinding()]
    param()

    Import-Module ImportExcel -ErrorAction Stop

    $file = Join-Path -Path $env:TEMP -ChildPath "$((New-Guid).ToString()).xlsx"

    Get-Process |
        Where-Object {$_.company} |
        Sort-Object -Property PagedMemorySize -Descending |
        Select-Object -Property Company, PagedMemorySize, PeakPagedMemorySize|
        Export-Excel -Path $file `
            -AutoSize `
            -IncludePivotTable `
            -IncludePivotChart `
            -ChartType ColumnClustered `
            -PivotRows Company `
            -PivotData @{PagedMemorySize='sum'; PeakPagedMemorySize='sum'}

    New-PoshBotFileUpload -Path $file -Title 'ProcessMemoryUsageByCompany.xlsx'
}

function Regex-Test {
    <#
    .SYNOPSIS
        Test regex triggers and extracting matches from command string
    .EXAMPLE
        grafana cpu server01
    #>
    [PoshBot.BotCommand(
        CommandName = 'grafana',
        TriggerType = 'regex',
        Regex = '^grafana\s(cpu|disk)\s(.*)'
    )]
    [cmdletbinding()]
    param(
        [parameter(ValueFromRemainingArguments = $true)]
        [object[]]$Arguments
    )

    write-output $Arguments[0]
    write-output $Arguments[1]
    write-output $Arguments[2]
}

function Get-Version {
    Write-Output "I'm version $((Get-Module PoshBot.Demo).Version.ToString())"
}
