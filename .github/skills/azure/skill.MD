---
name: azure
description: "Use when creating, revising, reviewing, or comparing Azure architecture documents. Trigger for Azure architecture, Azure landing zone, hub-spoke, private endpoint, App Service, Azure Functions, AKS, Application Gateway, Key Vault, PostgreSQL, networking, and security-by-default design requests."
---

## Purpose

Use this skill for Azure-specific architecture work in this repository.
This skill is for drafting or improving architecture documents, not for generating Azure code, CLI scripts, Terraform, or CI/CD pipelines unless the user explicitly asks for those artifacts.
Use the microsoft-docs skill and tools and Azure best practices as primary references when designing or reviewing Azure architectures.

## Use this skill when

- The user asks for an Azure architecture or solution design.
- The user mentions Azure services such as App Service, Azure Functions, AKS, Application Gateway, Key Vault, PostgreSQL, Front Door, Redis, Service Bus, or Azure Monitor.
- The user asks for a landing-zone-aligned design, hub-spoke networking, private connectivity, or Azure security guidance.
- The user wants an existing architecture document reviewed or rewritten for Azure best practices.

## Default Azure assumptions

Unless the user says otherwise, assume:

- Prefer private endpoints and private links instead of subnet delegation.
- Private endpoints and private links are better and more secure than subnet delegation when both options are available.
- The workload is deployed into an enterprise Azure landing zone.
- Networking follows a hub-spoke pattern.
- All outbound connectivity routes through the hub.
- Connectivity from other workloads also follows the hub-spoke pattern.
- Public endpoints are disallowed unless they are explicitly required.
- Secrets are stored in Azure Key Vault.
- The design should align with the Azure Well-Architected Framework and Cloud Adoption Framework.

## Mandatory design rules

- Prefer managed Azure services over self-managed infrastructure when both satisfy the requirement.
- Keep data services private by default.
- Use private endpoints, delegated subnets, service-specific subnet requirements, and private DNS where appropriate. PREFER PRIVATE ENDPOINTS OVER SUBNET DELEGATION.
- If internet access is required, terminate inbound traffic at Azure Application Gateway in the spoke unless the user explicitly asks for a different public edge.
- Call out service limitations, routing implications, and operational dependencies when they materially affect the design.
- For each major design decision, include rationale, trade-offs, and at least one alternative considered.

## Required output shape

When drafting an Azure architecture document, include all of the following sections:

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

## Azure architecture workflow

1. Identify the workload type, traffic pattern, data stores, integration points, and constraints.
2. State any assumptions needed to complete the design.
3. Pick the smallest Azure service set that satisfies the requirements.
4. Define the network exposure model first: public ingress, private application paths, private data paths, and hub-routed egress.
5. Explain why each core Azure service is used.
6. Document key trade-offs, rejected alternatives, and operational implications.
7. End with concrete security considerations and future evolution paths.

## Diagram rules

- Use ASCII diagrams only.
- Do not use Mermaid or any other diagramming syntax.
- Show traffic direction and trust boundaries.
- Keep the diagram small enough to read in a Markdown file.

## Do not include by default

Do not expand into these areas unless the user explicitly asks:

- Terraform, Bicep, ARM, Ansible, or GitHub Actions
- CI/CD pipelines
- Detailed IAM or Entra ID design
- Governance frameworks or policy implementation
- Cost analysis or optimization exercises

## Review checklist

Before finalizing an Azure architecture document, verify that:

- Only explicitly required components are public.
- Outbound traffic is hub-routed.
- Secrets are vaulted.
- Private name resolution is covered where needed.
- Monitoring and operational visibility are addressed.
- The document includes concrete Azure service choices, not generic placeholders.

## Reference sources

- Azure Well-Architected Framework: https://learn.microsoft.com/en-us/azure/well-architected/
- Cloud Adoption Framework: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/

## Public best practices

When an Azure architecture document needs public sourced best practices:

- Use the public-research skill for the non-vendor research workflow.
- Use the brave-search-mcp-server to research each major Azure component separately.
- Keep public-sourced recommendations distinct from Microsoft guidance in the final document.

