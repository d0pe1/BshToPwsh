# Establish persistent PowerShell sessions to remote targets with auto-recovery
# Task UUID: c89cc60d-6f6b-46bb-94d7-db15d60a4779 / bb044495-f26d-47d5-bc58-a30612fad872
param(
    [string]$Target,
    [string]$CredentialFile = "$HOME/.config/bsh2pwsh/cred.xml"
)

$logPath = "logs/sessions.log"
$sessionFile = "$HOME/.config/bsh2pwsh/$Target.session"

function Log($msg) {
    $timestamp = (Get-Date).ToString('o')
    "$timestamp $msg" | Out-File -FilePath $logPath -Append
}

if (-not (Test-Path $CredentialFile)) {
    throw "Credential file not found: $CredentialFile"
}

$cred = Import-Clixml -Path $CredentialFile
$session = $null

if (Test-Path $sessionFile) {
    try {
        $session = Import-Clixml -Path $sessionFile
        if (-not (Test-PSSession -Session $session)) {
            Remove-PSSession -Session $session -ErrorAction SilentlyContinue
            $session = $null
        }
    } catch {
        $session = $null
    }
}

if (-not $session) {
    try {
        $session = New-PSSession -ComputerName $Target -Credential $cred
        $session | Export-Clixml -Path $sessionFile
        Log "Re-established session to $Target"
    } catch {
        Log "Failed to establish session to $Target: $_"
        exit 1
    }
} else {
    Log "Session active to $Target"
}

# Heartbeat update
try {
    Invoke-Command -Session $session -ScriptBlock { 'pong' } | Out-Null
} catch {
    Log "Heartbeat failed for $Target"
}
