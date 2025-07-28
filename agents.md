# **Agent Operating Protocol**

This file defines the roles and rules for all agents working in this repository. Every agent must read and understand these instructions before performing any task. Violations or deviations will **immediately halt the build**.

---

## **Roles**

### **PlannerAgent**

The PlannerAgent is responsible for **initial planning**, DAG creation, and final review.  

---

### **Core Responsibilities**
1. Reads `projectscope.md` and generates a **dependency graph (DAG)** of all required work.  
2. Records:
   - **Milestones** in `agent_tasks.md`
   - **Atomic subtasks** in `agent_prio.md`  

---

### **Task Entry Requirements**
Every milestone and subtask entry must include:  
- **UUID v4** (8-4-4-4-12 format – mandatory, unique across repository)  
- **Description** (what must be done)  
- **Context / Why** (reason for existence in project scope)  
- **depends_on** list (**UUIDs only**)  
- **Priority** (integer, 1 = highest priority)  

> ⚠️ PlannerAgent must **validate UUID uniqueness** and ensure all `depends_on` references resolve before committing.

---

### **State File & Artifact Management**
- Updates **`manifest.json`** with:  
  - Related task UUID  
  - Full file path(s)  
  - SHA256 hash of artifact at commit  
- Produces `taskmap.svg` – a Gantt-style overlay of the DAG for human + agent visibility.  
- **Commits all updated state files** (`agent_tasks.md`, `agent_prio.md`, `manifest.json`) before ExecutorAgents may start.  

---

### **README.md Generation**
- Once planning is complete and tasks are locked into the state files, **PlannerAgent overwrites `README.md`** with a clear, concise, human-focused project description:
  - Repository scope and goals  
  - High-level feature map  
  - Current project status  
  - Links to relevant state files  

This ensures that **humans understand the repo as easily as agents do**.  

---

### **Handoff & Continuous Loop**

PlannerAgent now operates in a **continuous loop** with ExecutorAgent until all tasks and milestones are complete:

1. After each planning or re-planning phase, **PlannerAgent immediately triggers ExecutorAgent**.  
2. PlannerAgent waits until ExecutorAgent either:
   - Completes a milestone, or  
   - Cannot proceed further (all remaining tasks `[u]` or `[a]`).  
3. If a milestone completes, MetaStateCheckerAgent is triggered (see below).  
   - If MetaStateCheckerAgent reports no issues, PlannerAgent checks for remaining tasks and loops ExecutorAgent again.  
   - If issues are found, PlannerAgent re-plans before looping again.  

> **No idle waiting:** As long as tasks remain and MetaStateChecker passes, PlannerAgent and ExecutorAgent continue looping.

---

### **ExecutorAgent**

The ExecutorAgent is responsible for **implementing tasks**, integrating work, and maintaining logs.  

---

### **Core Responsibilities**
1. Pulls **only unblocked tasks** from `agent_prio.md` using the associated UUID and context.  
   - *Unblocked = all `depends_on` tasks are marked `[x]` complete, and PlannerAgent has marked milestone as unblocked.*
2. Implements the assigned task(s), updates all relevant files, and logs all work in `DevDiary.md`.

---

### **Task Execution Loop**
ExecutorAgent operates in a **drain loop**:  
1. Iterates through as many `[ ]` unblocked tasks as possible, in priority order.
2. Updates task status:
   - `[ ]` → `[~]` when started
   - `[~]` → `[x]` when fully integrated and tested
   - `[ ]` → `[a]` if subtasks are required (forces re-plan)
   - `[ ]` → `[u]` if blocked (requires user input)
3. Stops only when:
   - All remaining tasks are `[x]` complete, **or**  
   - Every remaining task is `[a]` or `[u]` (requires PlannerAgent), **or**  
   - A milestone completes (triggers MetaStateCheckerAgent).

> ⚠️ ExecutorAgent never partially commits—**each task must be fully integrated and tested before it can be marked `[x]`**.

---

### **GitHub Push & Branch Policy**

- **ExecutorAgent**:
  - Must push commits mid-task to **a feature branch**, not directly to `main`:  
    `feature/<UUID>-<short-desc>`  
  - Must include the **task UUID** in the commit message.  
  - Must update `manifest.json` and `DevDiary.md` with each commit.  
  - Must request MetaStateCheckerAgent validation before a merge is attempted.

- **MetaStateCheckerAgent**:
  - Validates the feature branch (DAG integrity, tests, hashes, manifests).  
  - If **passes**, it merges the branch into `main`.  
  - If **fails**, flags `[u]` or `[a]` and cancels the merge request.

- **PlannerAgent**:
  - Handles any required re-planning based on MetaStateChecker flags.

---

### **Escalation & Blockers**
- If context is missing or a task cannot proceed:
  - Mark `[u]` (requires user input) or `[a]` (requires additional planning)
  - Document the blocker and context clearly in `DevDiary.md`
- ExecutorAgent stops and hands control back to PlannerAgent when blocked.

---

### **MetaStateCheckerAgent**

The MetaStateCheckerAgent is responsible for **auditing the project’s true state vs. the declared state**.  
It ensures that the DAG, state files, and source artifacts accurately reflect reality – every task, scope, artifact, and log must be consistent and fully traceable.

---

### **Core Responsibilities**
1. **Reconcile all state files with the actual repository state:**
   - `agent_tasks.md` (milestones)
   - `agent_prio.md` (atomic tasks)
   - `manifest.json` (artifact registry)
   - `state.md` (last known graph hash, active agents)
   - `metrics.md` (task counts, bottlenecks)
   - `DevDiary.md` (blockers and resolutions)
2. Perform **full semantic integrity checks**:
   - Do all `depends_on` UUIDs resolve? Are there any dangling or circular dependencies?  
   - Do milestone completions in `agent_tasks.md` match the subtasks marked `[x]` in `agent_prio.md`?  
   - Does every file listed in `manifest.json` **exist** and match its SHA256 hash?  
   - Do completed tasks have traceable evidence: updated artifacts, DevDiary log entry, and manifest registration?  
   - Is the DAG truly complete (no orphaned tasks or untracked work)?  
   - Are all status markers (`[ ]`, `[~]`, `[x]`, `[a]`, `[u]`) logical and consistent?  
   - Does the current implementation still align with `projectscope.md`?  

---

### **Traceability Requirement**
For every task and artifact, MetaStateChecker must be able to follow a **closed trace chain**:
```
projectscope.md → agent_tasks.md → agent_prio.md → artifact in repo → manifest.json → DevDiary.md log
```
If this chain breaks at any point, the task is flagged.

---

### **Failure & Escalation Behavior**
- Flags any inconsistency or missing traceability by:
  - Setting task status to `[u]` (user input required) or `[a]` (needs re-planning)
  - Documenting exact findings in `DevDiary.md`
- Triggers **STOP BUILD mode** if:
  - DAG integrity is broken (dangling references, cycles, or duplicates)
  - Milestones appear falsely marked `[x]` (no evidence chain)
  - Source files or artifacts are missing or unregistered
  - Manifest hashes mismatch actual artifacts  
- In STOP BUILD mode:
  - ExecutorAgents must halt immediately.
  - PlannerAgent must resolve the issues before work resumes.

---

### **Timing**
- Runs automatically after each **milestone** is completed.  
- Must also run at **project closure**, ensuring final audit passes before repository is marked complete.  
- If MetaStateCheckerAgent passes audit and tasks remain: PlannerAgent loops ExecutorAgent again.

---

### **Authority**
MetaStateCheckerAgent **cannot modify tasks beyond applying escalation flags**, but its findings are final.  
Only PlannerAgent can re-plan and resolve inconsistencies flagged by MetaStateChecker.

---

## **Escalation Markers**
- `[ ]` – Task ready to work
- `[~]` – Work started / partial / in testing
- `[x]` – Task completed, integrated, and tested
- `[a]` – Task requires additional subtasks or re-planning
- `[u]` – Task blocked; user input or external clarification required  

> **Rule:** Any status change must be logged in `DevDiary.md` with:
> - UUID
> - Timestamp
> - Reason for change

---

## **Frozen Example Blocks**
- All state files (`agent_tasks.md` and `agent_prio.md`) contain a top **Example** block.
- These blocks are **read-only** and may **never be modified or removed**.  
- Codex agents must follow the format exactly:
  ```markdown
  # Example
  - uuid: 1f29d3e0-3b9d-44af-a6d2-bc4c2a8b8d8c
    description: Describe the milestone or task
    why: Context
    depends_on: [uuid]
    priority: 1
    status: []
  ```

---

## **Programmatic Checks**
- All commits must pass **tests and lint checks**.
- Tasks cannot be marked `[x]` if any test fails.  
- If tests are missing:
  - ExecutorAgent must create a stub test before completion.
- Final parity check =  
  - Full run of all tests  
  - MetaStateChecker audit  
  - Manifest hash verification  
- **No skipping allowed.**

---

## **Manifest Requirements**
- Every artifact (script, module, doc) must be recorded in `manifest.json` with:
  - Task UUID
  - File path
  - SHA256 hash at commit
- PlannerAgent and ExecutorAgent must update `manifest.json` **before** marking `[x]`.

---

## **DevDiary Logging**
- All blockers, escalations, and major commits must include:
  - Task UUID
  - Timestamp
  - Summary of action/problem
  - Justification for any deviations from the task lifecycle

---

## **Halt Conditions**
- DAG integrity broken (dangling `depends_on`, duplicate UUIDs, cyclic references)
- Manifest out of sync or missing hashes
- Frozen Example blocks modified
- Invalid status or lifecycle transition without explanation
- Tests failing or missing  
- Any **STOP BUILD** triggered by MetaStateChecker must be resolved by PlannerAgent before work resumes.

---

### **Summary: Zero Tolerance**
This protocol **removes all ambiguity**. Any task or commit that violates these rules:
1. Will be flagged by MetaStateChecker and marked `[u]` or `[a]`.  
2. ExecutorAgent must halt work immediately.
3. PlannerAgent must resolve the issue through re-planning or escalation before any further commits.

> **Looping:** If MetaStateChecker passes and tasks remain, PlannerAgent and ExecutorAgent continue their loop without stopping until all tasks are `[x]` and the final audit passes.
