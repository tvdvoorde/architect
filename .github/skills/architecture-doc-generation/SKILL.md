---
name: architecture-doc-generation
description: "Use when creating, drafting, revising, rewriting, or reviewing architecture documents in Markdown for this repository. Trigger for requests such as architecture document, solution design, target architecture, architecture proposal, architecture draft, design doc, technical design document, write a markdown architecture, create an architecture markdown, rewrite this architecture, or generate an implementation-ready architecture document."
---

## Purpose

Use this skill when the user wants an architecture document produced or revised in this repository.
This skill is for Markdown document generation, not for application code generation.
Prefer concrete, implementation-ready architecture decisions over generic guidance.

## Use this skill when

- The user asks to create an architecture document.
- The user asks to draft a solution design or target architecture.
- The user asks to rewrite, improve, or review an existing architecture Markdown file.
- The user asks for a design document, technical design document, or architecture proposal.
- The user asks for architecture output in Markdown.

## Default behavior

- Produce a Markdown document as the primary output.
- Treat the task as architecture-design work unless the user explicitly asks for something else.
- Make reasonable assumptions when requirements are underspecified and list them explicitly.
- Prefer managed services unless there is a clear reason not to.
- Keep the design opinionated and concrete.

## Mandatory output rules

- Create or revise Markdown in the repository root unless the user explicitly asks for a different location.
- Do not create application source code, IaC, or pipelines unless the user explicitly asks for them.
- Use ASCII diagrams only.
- Do not use Mermaid, PlantUML, SVG, draw.io, or linked images.
- Separate requirements from decisions.
- State major trade-offs and include at least one rejected alternative for key design decisions.
- Avoid placeholders such as TBD, etc., or generic statements like best practices apply.

## Required section headings

Every architecture document must include these exact headings:

1. Overview
2. Problem statement
3. Non functional requirements
4. Design principles
5. Design decisions
6. List of the needed components
7. Vendor recommended best practices
8. Public sourced best practices
9. Security considerations
10. Future work

## Repository design defaults

Unless the user says otherwise, assume:

- A landing-zone deployment model.
- Hub-spoke networking.
- All outbound connectivity goes through the hub.
- Connectivity from other workloads also follows the hub-spoke model.
- Public endpoints are disallowed unless public exposure is explicitly required.
- If public internet access is required, inbound traffic goes through the approved edge in the spoke.
- Secrets are stored in a secure vault.
- Private endpoints, private DNS, and segmented subnets are preferred where supported.

## Architecture workflow

1. Identify the workload, users, constraints, and assumptions.
2. Define the network exposure model first.
3. Choose the smallest service set that satisfies the requirements.
4. Explain why each major component is selected.
5. Document key trade-offs, operational implications, and rejected alternatives.
6. End with security considerations, future work, and an ASCII diagram.

## Out of scope by default

Do not include these topics unless the user explicitly asks:

- Terraform, Bicep, ARM, Ansible, or other automation
- CI/CD pipelines
- Detailed IAM or identity design
- Governance implementation details
- Cost optimization analysis

## Source guidance

- Use vendor documentation and reputable public sources when they materially improve the design.
- When public best practices or public sourced best practices are needed, use the public-research skill and its brave-search-mcp-server workflow.
- For Microsoft technologies, prefer the microsoft-docs skill and official learn.microsoft.com sources.
- For Azure-specific architecture requests, also use the azure skill.

## Best-practices workflow

For each major component in the architecture:

1. Use vendor documentation for Vendor recommended best practices.
2. Use the public-research skill for Public sourced best practices.
3. Keep the recommendations separate in the final document.

## Review checklist

Before finalizing, verify that:

- The output is Markdown.
- The file location is the repository root unless explicitly overridden.
- All required headings are present exactly as written.
- The design is concrete and implementation-ready.
- The public exposure model is explicit.
- Security considerations are specific to the chosen design.
- The diagram is ASCII only.