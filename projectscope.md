BshToPwsh
The Debian-side Agent Bootstrap & Tunnel Suite for Remote PowerShell

Goal
BshToPwsh is a Debian-based bootstrap system that establishes secure, persistent PowerShell remoting sessions into Windows targets via Cloudflare forward-only tunnels. It equips the Linux environment with a complete toolset for remote orchestration (file transfer, script execution, job queues) so that any agent (Codex, self-planner, etc.) can interact with the Windows target as if it were running native PowerShell locally, even though it’s operating over a hidden Cloudflare tunnel.

Scope & Features
Environment Bootstrap (Debian Side)

Runs as a Codex environment setup script or standalone bootstrap.

Installs dependencies: PowerShell Core, Cloudflared, Git.

Clones & registers the agent_suite utility repo.

Launches forward-only Cloudflare tunnels using pre-provisioned credentials (no inbound ports).

Opens persistent PowerShell sessions to Windows targets and keeps them alive.

Agent-Friendly Remote Execution

Executes PowerShell commands/scripts on the remote host using Invoke-Command and New-PSSession.

Normalizes output so agents on Debian side see results just like native Windows PowerShell:

stdout (human-readable output)

stderr (error messages)

exit codes

supports object serialization for structured data

Returns results in clean JSON for agentic frameworks:

json
Copy
Edit
{
  "exitCode": 0,
  "stdout": "Service started",
  "stderr": "",
  "psObjects": [
    { "Name": "Spooler", "Status": "Running" }
  ]
}
Agents can chain commands, check results, and iterate without needing Windows-specific hacks.

File Transfer & Sync

send_file.sh: Chunked Base64 file push (Linux → Windows) with hash verification.

get_file.sh: Remote file retrieval (Windows → Linux).

sync_dir.sh: Rsync-style directory mirroring over the PS session.

Resilience & Observability

Watchdog monitors tunnels and PS sessions; reconnects automatically if disconnected.

Logs all jobs with timestamps and status to /workspace/logs.

Health endpoint so agents can check “are all sessions alive?”.

Multi-Host & Multi-Session Support

Maintains sessions to multiple Windows targets, accessible by tag:

bash
Copy
Edit
exec_remote.sh --target qa1 "Get-Service"
Agentic Integration

Appends capabilities to README.md so Codex/self-planners immediately know what the environment can do.

Provides agent_tasks.md and agent_prio.md for iterative planning.

Optional: failed jobs can trigger ChatGPT API queries for auto-diagnosis and retries.

Key Clarifications
Debian-Side Only: Windows only needs minimal PSRemoting and Cloudflare tunnel config; all intelligence lives on the Debian side.

Natural PowerShell Experience: The agent’s interface behaves like a Windows PS console, but it’s actually running over secure, one-way Cloudflare tunnels.

Terminal Output & Object Handling: Because PSRemoting normally returns objects, BshToPwsh includes adapters so the agent sees the same stdout/stderr semantics it expects from a native terminal, with structured objects optionally returned for programmatic use.

