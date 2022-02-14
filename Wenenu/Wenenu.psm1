$authEndpoint = '/auth/token'
$scenarioEndpoint = '/manage/scenarios'
$timeZonesEndpoint = '/manage/timezones'

$ErrorActionPreference = "Stop"

function WriteCallError([System.Exception] $e, [String] $message) {
    try {
        throw $e
    } catch [System.Net.WebException] {
        if ($_.Exception.Response) {
            $result = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $responseBody = $reader.ReadToEnd()
            Write-Verbose $responseBody
        }
        Write-Error "$message, $_"
    } catch {
        Write-Error "$message, $_"
    }
}

function AuthenticateApiUser([String] $userId, [String] $secret, [String] $hostname) {

    $bodyObject = @{
        "grant_type" = "api";
        "username" = $userId;
        "password" = $secret;
    }

    $uri = "$hostname$authEndpoint"
    $body = ConvertTo-Json $bodyObject

    try {
        Write-Verbose "API user authentication attempt, POST $uri"
        $auth = Invoke-RestMethod `
            -Method 'POST' `
            -Uri $uri `
            -Body $body `
            -ContentType "application/json"
        return $auth;
    } catch {
        WriteCallError $_.Exception "Authentication failed"        
    }
}

function GetAuthHeders([String] $userId, [String] $secret, [String] $hostname) {
    $auth = AuthenticateApiUser $userId $secret $hostname
    if (!$auth) {
        return $null;
    }
    $headers = @{
        'Authorization' = "Bearer $($auth.access_token)"
    }
    return $headers;
}

function Get-WenenuScenario {
    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(Mandatory=$true)] [Alias('i')] [String] $id,
        [Parameter(Mandatory=$true)] [Alias('u')] [String] $userId,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [Alias('s')] [String] $secret,
        [Parameter()] [Alias('h')] [String] $hostname = 'https://wenenu.com'
    )

    $authHeaders = GetAuthHeders $userId $secret $hostname

    $uri = "$hostname$scenarioEndpoint/$id"

    try {
        Write-Verbose "Getting scenario, GET $uri"
        $scenario = Invoke-RestMethod `
            -Method 'GET' `
            -Headers $authHeaders `
            -Uri $uri
        return $scenario
    } catch {
        WriteCallError $_.Exception "Could not get scenario"
    }
}

function Get-WenenuScenarioConfig {
    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(Mandatory=$true)] [Alias('i')] [String] $id,
        [Parameter(Mandatory=$true)] [Alias('u')] [String] $userId,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [Alias('s')] [String] $secret,
        [Parameter()] [Alias('h')] [String] $hostname = 'https://wenenu.com'
    )

    $authHeaders = GetAuthHeders $userId $secret $hostname

    $uri = "$hostname$scenarioEndpoint/$id/config"

    try {
        Write-Verbose "Getting scenario configuration, GET $uri"
        $scenarioConfig = Invoke-RestMethod `
            -Method 'GET' `
            -Headers $authHeaders `
            -Uri $uri
        return ConvertTo-Json -Depth 10 $scenarioConfig
    } catch {
        WriteCallError $_.Exception "Could not get scenario configuration"
    }
}

function New-WenenuScenario {
    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(Mandatory=$true)] [Alias('n')] [String] $name,
        [Parameter(Mandatory=$true)] [Alias('rtz')] [String] $reportTimeZone,
        [Parameter(Mandatory=$true)] [Alias('u')] [String] $userId,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [Alias('s')] [String] $secret,
        [Parameter()] [Alias('h')] [String] $hostname = 'https://wenenu.com'
    )

    $authHeaders = GetAuthHeders $userId $secret $hostname

    $bodyObject = @{
        "name" = $name;
        "reportTimeZone" = $reportTimeZone;
    }

    $uri = "$hostname$scenarioEndpoint"
    $body = ConvertTo-Json $bodyObject

    try {
        Write-Verbose "Creating new scenario, POST $uri"
        $scenario = Invoke-RestMethod `
            -Method 'POST' `
            -Headers $authHeaders `
            -Uri $uri `
            -Body $body `
            -ContentType "application/json"
        return $scenario
    } catch {
        WriteCallError $_.Exception "Could not create scenario"
    }
}

function Set-WenenuScenarioConfig {
    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter()] [Alias('c')] [String] $config,
        [Parameter()] [Alias('cf')] [String] $configFile,
        [Parameter(Mandatory=$true)] [Alias('i')] [String] $id,
        [Parameter(Mandatory=$true)] [Alias('u')] [String] $userId,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [Alias('s')] [String] $secret,
        [Parameter()] [Alias('h')] [String] $hostname = 'https://wenenu.com'
    )
    if ($configFile) {
        $body = Get-Content $configFile -Raw
    } elseif ($config) {
        $body = $config
    } else {
        Write-Error "Paramter config or configFile is mandatory. If both are set, configFile has priority."
    }

    $authHeaders = GetAuthHeders $userId $secret $hostname

    $uri = "$hostname$scenarioEndpoint/$id/config"

    try {
        Write-Verbose "Setting scenario configuration, PUT $uri"
        Invoke-RestMethod `
            -Method 'PUT' `
            -Headers $authHeaders `
            -Uri $uri `
            -Body $body `
            -ContentType "application/json"
    } catch {
        WriteCallError $_.Exception "Could not set scenario configuration"
    }
}

function Get-WenenuTimeZones {
    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(Mandatory=$true)] [Alias('u')] [String] $userId,
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [Alias('s')] [String] $secret,
        [Parameter()] [Alias('h')] [String] $hostname = 'https://wenenu.com'
    )

    $authHeaders = GetAuthHeders $userId $secret $hostname

    $uri = "$hostname$timeZonesEndpoint"

    try {
        Write-Verbose "Getting time zones, GET $uri"
        $timeZones = Invoke-RestMethod `
            -Method 'GET' `
            -Headers $authHeaders `
            -Uri $uri
        return ConvertTo-Json -Depth 10 $timeZones.result
    } catch {
        WriteCallError $_.Exception "Could not get time zones"
    }
}