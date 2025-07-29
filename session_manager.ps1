# Establish persistent PowerShell sessions to remote targets
# Task UUID: c89cc60d-6f6b-46bb-94d7-db15d60a4779
param(
    [string]$Target,
    [string]$CredentialFile = "$HOME/.config/bsh2pwsh/cred.xml"
)

if (-not (Test-Path $CredentialFile)) {
    throw "Credential file not found: $CredentialFile"
}

$cred = Import-Clixml -Path $CredentialFile

try {
    $session = New-PSSession -ComputerName $Target -Credential $cred
    Write-Host "Session established to $Target"
    $session | Export-Clixml -Path "$HOME/.config/bsh2pwsh/$Target.session"
} catch {
    Write-Error "Failed to establish session: $_"
    exit 1
}
