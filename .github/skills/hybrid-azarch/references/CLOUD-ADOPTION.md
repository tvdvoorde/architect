# Cloud Adoption Framework

> For behavioral rules (context gathering, decision clarity, quality attributes), see SKILL.md.

Guidance for cloud adoption journeys on Azure, covering strategy through operations. Based on the Microsoft Cloud Adoption Framework (CAF).

## When to use

- User is planning a migration to Azure (or within Azure)
- User asks about landing zones, subscription topology, or governance baseline
- User asks about cloud strategy, business cases, or adoption planning
- User asks about managing and governing Azure environments at scale

## CAF phases overview

| Phase | Purpose | Key outputs |
|-------|---------|------------|
| Strategy | Define business motivations and expected outcomes | Business case, motivations, outcomes |
| Plan | Assess workloads and define adoption roadmap | Digital estate assessment, migration waves, skills plan |
| Ready | Prepare Azure environment (landing zones) | Landing zone deployed, identity/networking/governance ready |
| Adopt | Migrate or innovate workloads | Workloads running on Azure |
| Govern | Establish and enforce guardrails | Policies, compliance, cost management |
| Secure | Protect workloads and data | Security baseline, threat protection, access controls |
| Manage | Operate and optimize | Monitoring, backup, incident response, optimization |

Do not jump to "Ready" or "Adopt" without first understanding "Strategy" and "Plan" — users who skip strategy often make expensive rearchitecture decisions later.

## Strategy

Help the user articulate:

- **Motivations** — Why move to the cloud? (Cost reduction, agility, scaling, compliance, innovation, datacenter exit)
- **Business outcomes** — What measurable results are expected? (Reduce hosting cost by X%, enable Y new market, achieve Z availability)
- **Business case** — Cost comparison: current on-prem total cost of ownership vs. projected Azure cost

Questions to ask:
- What is the primary driver for cloud adoption?
- Are there hard deadlines (e.g., datacenter lease expiration)?
- Who are the stakeholders and what outcomes matter to them?

MCP search: `"Cloud Adoption Framework strategy"`, `"cloud migration business case Azure"`

## Plan

Help the user assess and prioritize:

### Digital estate assessment

- Inventory existing workloads (applications, databases, infrastructure)
- Classify by migration strategy (see Adopt section)
- Identify dependencies between workloads

### Migration waves

- Group workloads into waves based on dependency, complexity, and business priority
- Start with low-risk, well-understood workloads to build team skills
- Plan high-complexity workloads for later waves after team has experience

### Skills readiness

- Identify skill gaps: Azure fundamentals, IaC, networking, security, monitoring
- Plan training paths (Microsoft Learn, certifications, hands-on labs)

MCP search: `"Cloud Adoption Framework plan"`, `"Azure migration assessment"`, `"Azure Migrate"`

## Ready — Landing zones

The most common deep-dive topic. A landing zone is the foundational Azure environment.

### What a landing zone includes

| Component | Purpose |
|-----------|---------|
| Management groups | Organizational hierarchy for policy and access |
| Subscriptions | Workload isolation boundaries |
| Identity (Entra ID) | Authentication, RBAC, PIM |
| Networking | Hub-spoke or Virtual WAN topology, DNS, connectivity to on-premises |
| Governance | Azure Policy, naming conventions, tagging strategy |
| Monitoring | Log Analytics, Azure Monitor, diagnostic settings |
| Security | Microsoft Defender for Cloud, Network Security Groups, WAF |

### Landing zone approaches

| Approach | When to use |
|----------|------------|
| Start small (Azure landing zone accelerator) | First Azure deployment, small team, want to start quickly and iterate |
| Enterprise-scale (CAF enterprise landing zone) | Large organization, multiple teams, need strong governance from day one |
| Custom | Specific regulatory or architectural requirements not met by standard patterns |

### Subscription topology

- **Single subscription** — only for very small or proof-of-concept workloads
- **Application-level subscriptions** — one subscription per workload/application (recommended for most)
- **Environment-level subscriptions** — separate subscriptions for dev/staging/prod per workload
- **Platform + workload separation** — platform team manages shared services (connectivity, identity, management); workload teams get their own subscriptions under guardrails

MCP search: `"Azure landing zone"`, `"CAF ready"`, `"Azure landing zone accelerator"`, `"enterprise-scale landing zone"`

## Adopt — Migration strategies

The five R's (migration strategies) in order of increasing transformation:

| Strategy | Description | When to use |
|----------|-------------|------------|
| Rehost (Lift & shift) | Move as-is to Azure VMs | Quick wins, datacenter exit, minimal app changes |
| Replatform | Minor adjustments to leverage PaaS (e.g., SQL Server → Azure SQL) | Easy PaaS gains without major refactoring |
| Refactor | Modify application code to fit PaaS services | When PaaS benefits justify code changes |
| Rearchitect | Redesign the application for cloud-native patterns | When the existing architecture blocks cloud benefits |
| Rebuild | Build new from scratch on Azure | When legacy app is unsalvageable or requirements have changed fundamentally |

**Also consider:**
- **Replace** — Switch to a SaaS solution (e.g., on-prem CRM → Dynamics 365)
- **Retain** — Keep on-premises (not everything needs to move)

### Migration tooling

- **Azure Migrate** — Assessment, server migration, database migration
- **Azure Database Migration Service** — Database-specific migrations
- **Azure Site Recovery** — VM replication for lift-and-shift

MCP search: `"Cloud Adoption Framework migrate"`, `"Azure migration strategies"`, `"Azure Migrate tool"`

## Govern

Governance at scale covers:

| Area | Mechanism |
|------|-----------|
| Policy enforcement | Azure Policy (built-in and custom policies) |
| Cost management | Azure Cost Management, budgets, alerts, tagging for cost allocation |
| Compliance | Regulatory compliance dashboard, audit logging |
| Resource consistency | Naming conventions, tagging strategy, resource locks |
| Identity governance | PIM (Privileged Identity Management), access reviews |

MCP search: `"Cloud Adoption Framework govern"`, `"Azure Policy best practices"`, `"Azure governance"`, `"Azure management group structure"`

## Secure

Security across the adoption journey:

- **Identity** — Entra ID, conditional access, MFA, PIM
- **Network** — Network segmentation, private endpoints, NSGs, Azure Firewall, DDoS protection
- **Data** — Encryption at rest and in transit, data classification, purview
- **Workload** — Application security, secret management (Key Vault), vulnerability scanning
- **Operations** — Microsoft Defender for Cloud, Sentinel (SIEM), incident response

MCP search: `"Cloud Adoption Framework secure"`, `"Azure security best practices"`, `"Microsoft Defender for Cloud"`

## Manage

Operational management post-migration:

- **Monitoring** — Azure Monitor, Application Insights, Log Analytics, workbooks, dashboards
- **Backup & recovery** — Azure Backup, disaster recovery strategy, RTO/RPO validation
- **Patch management** — Azure Update Manager, maintenance windows
- **Incident response** — Alert rules, action groups, escalation procedures, post-incident reviews
- **Optimization** — Azure Advisor recommendations, right-sizing, unused resource cleanup

MCP search: `"Cloud Adoption Framework manage"`, `"Azure operational best practices"`, `"Azure Monitor"`

## Live documentation

| Topic | MCP search query |
|-------|-----------------|
| CAF overview | `"Cloud Adoption Framework overview"` |
| CAF phase | `"Cloud Adoption Framework [phase]"` (e.g., `"Cloud Adoption Framework ready"`) |
| Landing zones | `"Azure landing zone architecture"` or `"Azure landing zone accelerator"` |
| Enterprise-scale | `"enterprise-scale landing zone architecture"` |
| Subscription topology | `"Azure subscription organization CAF"` |
| Hub-spoke networking | `"hub-spoke network topology Azure"` or `"Azure Virtual WAN vs hub-spoke"` |
| Migration guide | `"Azure migration guide"` or `"Azure Migrate assessment"` |
| Migration strategies | `"CAF migration strategy rehost replatform refactor"` |
| Governance | `"CAF governance benchmark"` or `"Azure Policy best practices"` |
| Management groups | `"management group hierarchy Azure"` |
| Security baseline | `"CAF secure zero trust Azure"` or `"Microsoft Defender for Cloud recommendations"` |
