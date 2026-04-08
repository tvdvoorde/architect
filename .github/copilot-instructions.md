# Copilot Instructions for `architect`

## Purpose

This repository is for drafting architecture documents, not for writing application code.
When working in this repository, optimize for clear architecture decisions, explicit assumptions, and implementation-ready structure.

## Default behavior

- Treat requests as architecture-design work unless the user explicitly asks for something else.
- Produce architecture documents in Markdown or PowerPoint
- If the request is underspecified, make reasonable assumptions and list them explicitly instead of blocking.
- Keep the design opinionated and concrete. Do not answer with generic cloud advice.
- Prefer managed services unless there is a clear reason not to.

## Required sections

Every architecture document must include these sections with these exact headings:

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

## Best practices

For each needed component, perform seperate research with the to find the vendor-recommended best practices and public-sourced best practices for that component and include them in the 

Make sure to search the public internet for each component separately to find public best practices and include them in the Public sourced best practices section. Do not rely solely on vendor documentation for best practices.

When public best practices or public sourced best practices are required, invoke the `public-research` skill and use that skill for the public research workflow.

When official vendor best practices are required, prefer vendor documentation and the relevant vendor-focused skill.

## Architecture rules

- Default to a landing-zone deployment model with hub-spoke networking.
- Assume all outbound connectivity goes through the hub.
- Assume connectivity from other workloads also follows the hub-spoke design.
- Do not give public endpoints to cloud resources unless public exposure is explicitly required.
- If public internet access is required, route inbound traffic through the platform-approved edge in the spoke.
- Store secrets in a secure vault.
- Prefer private endpoints, private DNS, and segmented subnets where supported.
- State major trade-offs and at least one rejected alternative for key design decisions.

## Diagrams

- Only use ASCII art diagrams.
- Do not use Mermaid, PlantUML, SVG, draw.io, or image references.
- Keep diagrams simple and focused on traffic flow and main components.

## Document quality bar

- Explain why each major service or component is chosen.
- Separate requirements from decisions.
- Distinguish in-scope design from future enhancements.
- Avoid placeholders such as "TBD", "etc.", or "best practices apply" without specifics.
- Do not include code, IaC, or deployment pipelines unless the user explicitly asks for them.

## Out of scope by default

Do not include detailed guidance for these topics unless the user explicitly asks:

- Automation such as Terraform, Ansible, or GitHub Actions
- CI/CD pipelines
- Identity and access management, such as Azure AD, Entra ID, or AWS IAM
- Governance, such as Azure Policy or AWS Control Tower
- Cost management and optimization

## Preferred response structure for architecture requests

When drafting or revising an architecture document, use this working approach:

1. Identify the workload, users, constraints, and assumptions.
2. Choose the core platform components and network pattern.
3. Explain the key design decisions with trade-offs.
4. List the concrete components required to implement the design.
5. Close with security considerations, best practices, future work, and an ASCII diagram.
