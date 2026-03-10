# hybrid-azarch — Azure Architecture Skill (Best-of-All)

A hybrid agent skill providing Azure architecture advisory guidance, combining the strongest elements from all variants. Built using the [agentskills.io](https://agentskills.io/) format.

## Architecture

**Hybrid pattern**: rich hub SKILL.md handles behavioral rules, dialogue patterns, MCP usage, troubleshooting, and routing; 4 reference files provide deep content loaded on demand.

```
hybrid-azarch/
├── SKILL.md                              ← Hub: behavior, dialogue patterns, decision tree, MCP usage, scope
└── references/
    ├── DESIGN-GUIDANCE.md                ← Service selection, reference architectures
    ├── WELL-ARCHITECTED.md               ← WAF review methodology, 5-pillar assessment
    ├── CLOUD-ADOPTION.md                 ← CAF phases, landing zones, migration strategies
    └── DESIGN-PATTERNS.md                ← Pattern catalog, composition, Azure implementation
```

## Base and enhancements

**Base:** ghcpcli-azarch (strongest requirement coverage, modular references, decision tree routing)

**Enhancements incorporated:**
1. **MCP query templates** (from claude) — template-slot patterns in hub + expanded Live documentation tables in each reference file
2. **Response structure guidance** (from m365) — lightweight structural checklists per interaction type
3. **Dialogue patterns** (from m365) — 4 interaction protocols mapping question types to execution sequences
4. **MCP fallback protocol** (from m365) — 3-step fallback when MCP is unavailable
5. **`generated_at` metadata** (from docs2skills-foundry) — date stamp in frontmatter
6. **"Load only when needed" instruction** (from hybrid-foundry) — explicit guidance to not load all references
7. **Key Resources URL table** (from hybrid-foundry) — canonical URLs for quick reference
8. **Troubleshooting table** (from hybrid-skills-creator evaluation) — symptom → resolution for common agent missteps

## Key design decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Monolith vs. modular | Hybrid (hub + references) | Domain is large (~5 areas); modular saves tokens on activation while keeping depth available on demand |
| Behavioral rules location | All in hub | Context-gathering, decision clarity, and quality attributes are cross-cutting — every response needs them regardless of topic |
| Service catalogs in references | Yes, as routing aids | Agent needs to know *what to search for* via MCP; catalogs are scaffolds, not authoritative sources |
| MCP-first approach | Golden rule in hub | Ensures currency; skill contains procedures not cached facts |
| MCP query templates | Distributed across hub + references | In-context where relevant (not a monolithic query file), loaded only when the topic is active |
| Output format | Structural checklists, not rigid YAML | Ensures completeness without constraining the agent's natural formatting |
| Dialogue patterns | 4 protocols in hub | Maps common interaction types to specific execution sequences for consistency |
| Audience model | Infer hat from question | Users wear multiple hats; fixed personas don't fit agent conversations |

## Requirements coverage

All 14 requirements (BR-1–3, FR-1–6, NFR-1–5) from `requirements.md` are addressed. Validated against all 18 test scenarios in `test-scenarios.md` — 64/64 checks pass.

## How to use

Install as an agent skill in a GitHub Copilot-compatible environment. The skill requires access to the [Microsoft Learn MCP server](https://learn.microsoft.com/api/mcp) for documentation retrieval (`allowed-tools` in frontmatter).

The skill is **advisory only** — it does not generate deployment artifacts, run CLI commands, or access Azure subscriptions.

See `requirements.md` and `test-scenarios.md` in the repo root for the shared spec.
