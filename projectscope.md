ProjectScope: Sage2Rust
Goal: Reimplement the SAGE engine (Command & Conquer: Generals, BFME) in a modular, memory-safe Rust architecture while maintaining full compatibility with original game data (INI configs, assets, mods). Enable a modern modding ecosystem where INI/config injections can be layered dynamically on top of the base game.

1. Scope
Sage2Rust is a function-by-function agent-driven reimplementation of the original SAGE engine. It will:

Replicate all engine functionality: parsing INIs, entity simulation, AI, physics, rendering, networking.

Run all original content unmodified: vanilla assets, configs, and mods load as they do in the legacy engine.

Abstract platform constraints: 64-bit native, multi-core capable, modern graphics APIs.

Enable dynamic mod packaging: mod packs can be layered at runtime by injecting their configs/assets into the base package (BFME/Generals-style).

Be modular and extendable: clean Rust crates for each system (ECS, physics, AI, rendering, scripting) and a runtime that can be reused for other SAGE-derived titles.

2. Why (Historical Context)
Engine rewrites like OpenRA, Thyme, ScummVM, OpenMW follow a consistent pattern:

Legacy engines are locked to outdated platforms (32-bit, DirectX9, single-threaded).

Original source is often unavailable or unmaintainable.

Modding scenes stagnate because the tools are fragile and configs can’t be layered cleanly.

The rewrite starts as a compatibility-first reimplementation, then evolves into a modernized engine with new capabilities.

This project follows the same model: match the original engine’s behavior 1:1, then add features.

3. Workflow: How These Projects Work
3.1 Agent-driven DAG migration
Ingest the legacy engine (source or decompiled): extract files, functions, and call graphs.

Build a dependency DAG:

Leaf utilities (string/memory/math) → port first.

Managers (entity, asset, AI) → port second.

High-level systems (renderer, networking) → port last.

Rewrite function-by-function:

Each task is defined in agent_tasks.md with dependencies.

Unit tests compare output against the legacy engine using the same INIs/assets.

3.2 Milestone progression
Milestone 1: Utility libraries + INI parser → ability to load configs.

Milestone 2: ECS architecture + entity manager → can spawn units.

Milestone 3: Simulation systems (AI, physics, pathfinding) → playable in headless mode.

Milestone 4: Renderer + UI → full playable state.

Milestone 5: Networking + scripting APIs → multiplayer + mod hooks.

3.3 Test harness
Legacy engine outputs serve as golden reference (e.g. replays, INI diffs, asset validation).

Every ported function/module must produce identical results before the agent marks it as complete.

4. Mod Pack & Runtime INI Injection Architecture
4.1 Goals
Mods shouldn’t need to fork the entire game.

Modders package only their changes (INI diffs, assets, Lua scripts).

At runtime, the engine dynamically merges base + expansions + mods into a single data graph.

4.2 Base → Package → Mod layers
Base Game Package: original assets/configs.

Expansion Packages: optional layers (e.g. BFME vs Generals)

Mod Packs: ad hoc INI/config injection + assets.

4.3 Injection Mechanism
INI parser supports layered merges:

Mod INI files override or extend values in the base configs.

Supports declarative "injection" markers, e.g.:

ini
Copy
Edit
[Unit Tank]
Health += 100
NewWeapon = NukeCannon
Assets (models, textures, sounds) loaded by virtual FS:

Priority order: mod > expansion > base.

No need to unpack or overwrite originals.

4.4 Runtime tooling
Engine exposes CLI tools:

css
Copy
Edit
sage2rust run --package bfme --mod my_epic_mod
sage2rust package --base bfme --mods mod1 mod2 --out Combined.pkg
Agents can dynamically assemble mod stacks for testing.

5. Deliverables
Crate-based engine:

arduino
Copy
Edit
sage_core/         (runtime, ECS scheduler)
sage_ini/          (INI parser, layered config system)
sage_assets/       (virtual FS, asset manager)
sage_ai/           (AI logic)
sage_physics/      (movement, collisions)
sage_render/       (renderer abstraction)
sage_scripting/    (modding APIs)
Agent integration:

agent_tasks.md: full DAG of functions to rewrite.

agent_prio.md: current critical-path tasks.

agent_dev_diary.md: migration logs, failures, and tests.

6. Key Clarifications
Compatibility-first: the engine must first be able to run unmodified Generals/BFME content perfectly.

No monolithic mods: modding support is layered and dynamic, allowing modular injection at runtime.

Agent autonomy: the rewrite is broken into isolated tasks with automated validation.

Future-proof: once baseline is reached, we can expand with 64-bit only features (bigger maps, more units, higher fidelity graphics).
