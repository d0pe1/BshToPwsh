# Active Subtasks

### ***Example:***
---
- uuid: < unique name or UUID >
  parent: <Parent Task/Milestone UUID>
  description: Describe the task and how it plugs into other tasks
  why: what should function if this is done?
  depends_on: [Blocker Task UUID]
  status: [x]
---

### ***Agent Prio Tasks:***
- uuid: a16b76ee-14b4-4dbc-b351-9c13f35e6317
  parent: d358226d-c11e-4dc4-a700-4657916e3658
  description: Write bootstrap script to install PowerShell, Cloudflared and Git
  why: Ensure all required packages are available
  depends_on: []
  priority: 1
  status: []
---
- uuid: 5312e7de-316d-4424-8d35-a5b1a10fe0d5
  parent: d358226d-c11e-4dc4-a700-4657916e3658
  description: Clone and register agent_suite utility repository
  why: Provide additional helper tools for agents
  depends_on: [a16b76ee-14b4-4dbc-b351-9c13f35e6317]
  priority: 1
  status: []
---
- uuid: 7cec4d60-20eb-4099-aa9d-0d673def22a5
  parent: 3007c5ed-3db3-4b87-a16e-f07ac23e65ef
  description: Launch forward-only Cloudflare tunnels using credentials
  why: Open secure communication channels to Windows hosts
  depends_on: [5312e7de-316d-4424-8d35-a5b1a10fe0d5]
  priority: 1
  status: []
---
- uuid: c89cc60d-6f6b-46bb-94d7-db15d60a4779
  parent: 3007c5ed-3db3-4b87-a16e-f07ac23e65ef
  description: Establish persistent PowerShell sessions to remote targets
  why: Maintain active connections for command execution
  depends_on: [7cec4d60-20eb-4099-aa9d-0d673def22a5]
  priority: 1
  status: []
---
- uuid: b7ae2b8c-fb9a-4bf9-b871-4d97b7eddbcf
  parent: 49fbdceb-36e6-43e0-b4f9-2a153ba5d50d
  description: Implement exec_remote.sh to run commands and return JSON
  why: Allow agents to execute PowerShell remotely
  depends_on: [c89cc60d-6f6b-46bb-94d7-db15d60a4779]
  priority: 2
  status: []
---
- uuid: bb567b8e-5dc6-4058-8cda-92e2c70d8aad
  parent: 49fbdceb-36e6-43e0-b4f9-2a153ba5d50d
  description: Add output normalization and object serialization
  why: Provide consistent stdout/stderr semantics
  depends_on: [b7ae2b8c-fb9a-4bf9-b871-4d97b7eddbcf]
  priority: 2
  status: []
---
- uuid: 773dca6b-e5a1-4b6a-9ae0-799d29db2830
  parent: f4e859b6-267c-4e9e-9116-cae33f5e6562
  description: Create send_file.sh for chunked file uploads
  why: Transfer files from Linux to Windows reliably
  depends_on: [bb567b8e-5dc6-4058-8cda-92e2c70d8aad]
  priority: 2
  status: []
---
- uuid: 66d30233-56ef-4cf5-b355-0c286db5d9a3
  parent: f4e859b6-267c-4e9e-9116-cae33f5e6562
  description: Create get_file.sh to retrieve remote files
  why: Fetch files from Windows hosts
  depends_on: [773dca6b-e5a1-4b6a-9ae0-799d29db2830]
  priority: 2
  status: []
---
- uuid: 0741a646-e5bf-4b9f-a326-a1b4a536a651
  parent: f4e859b6-267c-4e9e-9116-cae33f5e6562
  description: Implement sync_dir.sh for directory mirroring
  why: Keep directories synchronized across hosts
  depends_on: [66d30233-56ef-4cf5-b355-0c286db5d9a3]
  priority: 2
  status: []
---
- uuid: b0dbc675-0b7a-4268-88f8-a96adcda65aa
  parent: 28a04f9c-de1c-44fd-9071-372f998d4d7e
  description: Build watchdog to reconnect tunnels and sessions
  why: Ensure resilience if connections drop
  depends_on: [0741a646-e5bf-4b9f-a326-a1b4a536a651]
  priority: 3
  status: []
---
- uuid: 120f8edd-4a1a-4d60-a3c0-a0faa48c5de2
  parent: 28a04f9c-de1c-44fd-9071-372f998d4d7e
  description: Log job status to /workspace/logs with timestamps
  why: Provide audit trail for agent actions
  depends_on: [b0dbc675-0b7a-4268-88f8-a96adcda65aa]
  priority: 3
  status: []
---
- uuid: 60efded1-8ac7-4b1f-88df-a61b590bcbd0
  parent: 28a04f9c-de1c-44fd-9071-372f998d4d7e
  description: Expose health endpoint for session checks
  why: Allow agents to query status of tunnels and sessions
  depends_on: [120f8edd-4a1a-4d60-a3c0-a0faa48c5de2]
  priority: 3
  status: []
---
- uuid: 24c69a60-b31e-4dd8-848b-d5415138e6f4
  parent: 136085ab-8611-4003-bb9a-b12927505c67
  description: Add target tagging system for multiple hosts
  why: Identify and manage sessions by tag
  depends_on: [60efded1-8ac7-4b1f-88df-a61b590bcbd0]
  priority: 3
  status: []
---
- uuid: 99fc3a91-d367-4e0a-8362-526b080f1d5f
  parent: 136085ab-8611-4003-bb9a-b12927505c67
  description: Enable management of multiple PowerShell sessions
  why: Allow concurrent orchestration of several targets
  depends_on: [24c69a60-b31e-4dd8-848b-d5415138e6f4]
  priority: 3
  status: []
---
- uuid: b5512ff0-f7fd-48cf-912c-b6fda9e15f0a
  parent: 3612f089-abdc-49f1-877d-1ee46c146d59
  description: Update README with BshToPwsh capabilities
  why: Document usage for agents and humans
  depends_on: [99fc3a91-d367-4e0a-8362-526b080f1d5f]
  priority: 4
  status: []
---
- uuid: 63675cf5-30d6-4891-a12a-61042475ad85
  parent: 3612f089-abdc-49f1-877d-1ee46c146d59
  description: Prototype auto-diagnosis for failed jobs using ChatGPT API
  why: Optionally retry failed tasks with AI assistance
  depends_on: [b5512ff0-f7fd-48cf-912c-b6fda9e15f0a]
  priority: 4
  status: []
---
