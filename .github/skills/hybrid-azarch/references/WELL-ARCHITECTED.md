# Well-Architected Framework

> For behavioral rules (context gathering, decision clarity, quality attributes), see SKILL.md.

Methodology for conducting Well-Architected reviews and pillar-specific assessments of Azure workloads.

## When to use

- User requests a WAF review or assessment of an existing or proposed architecture
- User asks about a specific pillar (reliability, security, cost, operations, performance)
- User wants to understand trade-offs between quality attributes

## Review approach

### Standalone WAF review

When the user asks for a full Well-Architected review:

1. **Understand the workload** — Gather architecture context per SKILL.md BR-1 (services in use, topology, traffic patterns, SLA requirements)
2. **Assess each pillar** — Work through all five pillars systematically; do not skip pillars even if the user only mentioned one concern
3. **Identify findings** — For each pillar, note risks, gaps, and strengths
4. **Recommend remediation** — Specific, actionable steps for each finding
5. **Surface trade-offs** — Where fixing one pillar degrades another, make the trade-off explicit

### Pillar-specific deep dive

When the user asks about one pillar, go deeper on that pillar but briefly note cross-pillar implications.

## Pillar assessment guides

### Reliability

Key questions to assess:

- Is the workload deployed across multiple availability zones? Multiple regions?
- What are the defined RTO (Recovery Time Objective) and RPO (Recovery Point Objective)?
- Is there automated failover for critical components?
- Are dependencies identified and their failure modes understood?
- Is data replicated (LRS vs. ZRS vs. GRS vs. GZRS)?
- Are deployment slots or blue-green deployments used to reduce deployment risk?
- Is there health monitoring with automated recovery?

Common findings and remediation:

| Finding | Risk | Remediation |
|---------|------|-------------|
| Single instance, no zone redundancy | Full outage on zone failure | Enable availability zones, scale to 2+ instances |
| LRS storage only | Data loss on datacenter failure | Upgrade to ZRS or GRS based on RPO |
| No failover strategy | Extended downtime on region failure | Implement active-passive or active-active multi-region |
| No health probes | Silent degradation | Configure health endpoints and auto-restart rules |
| Monolithic deployment | All-or-nothing updates | Use deployment slots, canary releases |

MCP search: `"Azure Well-Architected reliability"`, `"reliability design principles Azure"`

### Security

Key questions to assess:

- Is Entra ID used for user and service authentication?
- Are managed identities used for service-to-service communication (no stored credentials)?
- Is network traffic restricted (VNet, private endpoints, NSGs, WAF)?
- Is data encrypted at rest and in transit?
- Are secrets stored in Key Vault (not in config or code)?
- Is threat detection enabled (Defender for Cloud)?
- Are RBAC roles scoped to least privilege?

Common findings and remediation:

| Finding | Risk | Remediation |
|---------|------|-------------|
| Public endpoints with no network restrictions | Attack surface exposure | Enable private endpoints or VNet integration + NSGs |
| Connection strings in app settings | Credential leakage | Move to Key Vault references or managed identity |
| No managed identity | Credential management burden | Enable system-assigned managed identity per service |
| No threat detection | Blind to active attacks | Enable Microsoft Defender for Cloud |
| Over-permissive RBAC | Lateral movement risk | Audit and scope to least privilege, use PIM for elevated access |

MCP search: `"Azure Well-Architected security"`, `"Azure security baseline [service name]"`

### Cost Optimization

Key questions to assess:

- Are SKU tiers appropriate for the workload's actual usage?
- Is autoscaling configured (not permanently over-provisioned)?
- Are dev/test environments scaled down or shut off when not in use?
- Are reserved instances or savings plans used for steady-state workloads?
- Is there cost monitoring and alerting in place?
- Are there orphaned resources (unused disks, IPs, stopped VMs still incurring charges)?

Common findings and remediation:

| Finding | Risk | Remediation |
|---------|------|-------------|
| Premium tier for low-traffic workload | Unnecessary spend | Evaluate Standard or Basic tier; benchmark to confirm |
| No autoscaling | Over-provisioning during off-peak | Configure autoscale rules based on metrics |
| Dev environments always on | Wasted spend | Implement schedules or use Dev/Test pricing |
| No cost alerts | Budget overruns go unnoticed | Set up Azure Cost Management budgets and alerts |
| No reserved instances for steady workloads | Paying on-demand premium | Evaluate 1-year or 3-year reservations |

MCP search: `"Azure Well-Architected cost optimization"`, `"Azure cost management best practices"`

### Operational Excellence

Key questions to assess:

- Is infrastructure defined as code (Bicep, Terraform)?
- Is there a CI/CD pipeline with automated testing and deployment?
- Is observability in place (Application Insights, Log Analytics, dashboards)?
- Are alerts defined for key health and performance metrics?
- Is there a runbook or incident response process?
- Are environments consistent (dev mirrors prod in structure)?

Common findings and remediation:

| Finding | Risk | Remediation |
|---------|------|-------------|
| Manual deployments | Inconsistency, human error, slow recovery | Implement CI/CD pipeline with IaC |
| No centralized logging | Difficult troubleshooting | Enable Log Analytics workspace, configure diagnostic settings |
| No alerting | Issues detected by users, not operators | Define alerts for SLI/SLO metrics |
| No IaC | Environment drift, unrepeatable deployments | Adopt Bicep or Terraform; consider Azure Verified Modules |
| No incident process | Ad hoc response to outages | Define escalation paths, runbooks, post-incident reviews |

MCP search: `"Azure Well-Architected operational excellence"`, `"Azure Monitor best practices"`

### Performance Efficiency

Key questions to assess:

- Is the architecture designed to scale horizontally (scale out) rather than only vertically (scale up)?
- Is caching used where appropriate (Redis, CDN, application-level)?
- Are database queries optimized (indexing, query design, read replicas)?
- Is content delivered close to users (CDN, regional deployment)?
- Are async processing patterns used for long-running operations?
- Are performance baselines established and monitored?

Common findings and remediation:

| Finding | Risk | Remediation |
|---------|------|-------------|
| No caching layer | Repeated expensive operations | Add Redis Cache for hot data, CDN for static assets |
| Synchronous processing for batch work | Blocking and latency | Use queues and background processing (Service Bus, Functions) |
| Single-region deployment for global users | High latency for distant users | Add CDN, or deploy to additional regions with Front Door |
| No performance baselines | Cannot detect degradation | Establish SLIs, monitor P50/P95/P99 latency |
| Vertical scaling only | Hard ceiling, expensive | Redesign for horizontal scale where possible |

MCP search: `"Azure Well-Architected performance efficiency"`, `"Azure caching best practices"`

## Trade-off patterns

Common pillar conflicts and how to frame them:

| Trade-off | Example | How to frame |
|-----------|---------|-------------|
| Reliability ↔ Cost | Multi-region deployment | "Adding a secondary region improves availability from 99.9% to 99.99% but roughly doubles infrastructure cost" |
| Security ↔ Operational simplicity | Private endpoints everywhere | "Private endpoints eliminate public attack surface but add DNS complexity and may require jump boxes for debugging" |
| Performance ↔ Cost | Premium vs. Standard SKUs | "Premium tier reduces latency by X but costs 3× more — worth it for latency-sensitive workloads" |
| Reliability ↔ Performance | Synchronous replication | "Sync replication prevents data loss but adds write latency — async replication trades RPO for throughput" |

## Live documentation

| Topic | MCP search query |
|-------|-----------------|
| WAF overview | `"Azure Well-Architected Framework"` |
| Pillar deep dive | `"Well-Architected [pillar name] pillar"` (e.g., `"Well-Architected reliability pillar"`) |
| Service-specific WAF guide | `"Azure [service name] Well-Architected"` (e.g., `"Azure Kubernetes Service Well-Architected"`) |
| WAF assessment | `"Well-Architected review assessment"` |
| Pillar + service | `"WAF [pillar] [service name]"` (e.g., `"WAF security Azure App Service"`) |
| Security baseline | `"Azure security baseline [service name]"` |
| Reliability patterns | `"Azure [service] high availability options"` or `"availability zones Azure [service]"` |
| Cost optimization | `"WAF cost optimization [service name]"` or `"autoscale cost Azure [service]"` |
| Performance tuning | `"WAF performance efficiency [service name]"` or `"Azure Cache for Redis [scenario]"` |
| SLA reference | `"Azure [service] SLA"` |
