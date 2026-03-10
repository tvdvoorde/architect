# Design Guidance

> For behavioral rules (context gathering, decision clarity, quality attributes), see SKILL.md.

Service selection and architecture design for Azure workloads, grounded in the Azure Architecture Center.

## Service selection approach

When helping a user choose Azure services, follow this methodology:

### 1. Identify the workload category

| Category | Key question | Common services |
|----------|-------------|-----------------|
| Compute | Where does the code run? | App Service, Container Apps, AKS, Functions, VMs, Spring Apps, Static Web Apps |
| Data | How is data stored and queried? | SQL Database, Cosmos DB, PostgreSQL, MySQL, Storage, Redis Cache, Data Explorer |
| Messaging | How do components communicate? | Service Bus, Event Grid, Event Hubs, Queue Storage, SignalR |
| Networking | How is traffic routed and secured? | Front Door, Application Gateway, Load Balancer, Azure Firewall, Traffic Manager, VNet, Private Link, DNS |
| Identity | How are users and services authenticated? | Entra ID, Managed Identity, Key Vault, App Registration |
| AI & Analytics | How is data analyzed or intelligence added? | AI Foundry, OpenAI Service, Cognitive Services, Synapse, Fabric, Databricks |
| Integration | How do systems connect? | API Management, Logic Apps, Data Factory, Service Bus |

### 2. Apply the decision framework

For each category, use these decision factors (in priority order):

1. **Requirements fit** — Does the service handle the workload's functional needs?
2. **Operational model** — Does it match the team's desired level of control vs. management? (PaaS vs. IaaS, serverless vs. always-on)
3. **Scale characteristics** — Does the scaling model fit traffic patterns? (bursty vs. steady, scale-to-zero vs. always-warm)
4. **Integration** — Does it integrate well with other services already chosen or in use?
5. **Constraints** — Compliance, data residency, network isolation, team skills, budget

### 3. Use Architecture Center decision trees

Microsoft publishes technology choice guides. Search MCP for the relevant one:

| Decision | MCP search query |
|----------|-----------------|
| Compute | `"choose an Azure compute service"` |
| Data store | `"choose a data store"` or `"review of Azure data store options"` |
| Messaging | `"choose between Azure messaging services"` |
| Load balancing | `"choose a load-balancing solution"` |
| AI/ML | `"choose an Azure AI services technology"` |
| Integration | `"choose an Azure integration technology"` |

Always fetch the decision tree page via MCP for current service comparisons before finalizing a recommendation.

## Architecture composition

When designing a full architecture (not just picking one service):

### Reference architectures

Search the Azure Architecture Center for reference architectures matching the workload. These provide validated, end-to-end designs:

- `microsoft_docs_search` with `"reference architecture [workload type]"` (e.g., `"reference architecture web application"`, `"reference architecture IoT"`)
- Fetch the reference architecture page and use it as a starting point
- Adapt it to the user's specific requirements and constraints

### Data flow

For multi-service architectures, describe the data flow explicitly:

1. Entry point — how requests/data enter the system
2. Processing — how data is transformed or business logic applied
3. Storage — where state lives
4. Output — how results are delivered to users or downstream systems

### Cross-cutting concerns

Every architecture needs these addressed:

| Concern | What to cover |
|---------|--------------|
| Identity & access | Authentication method, authorization model, managed identity for service-to-service |
| Networking | VNet integration, private endpoints, NSGs, DNS, hub-spoke if applicable |
| Observability | Application Insights, Azure Monitor, Log Analytics, alerts |
| Deployment | CI/CD pipeline, IaC approach, environment strategy (dev/staging/prod) |
| Disaster recovery | RTO/RPO targets, backup strategy, failover approach |
| Governance | Resource naming, tagging, Azure Policy, cost management |

### Boundary-spanning implications

When the architecture places components across different boundaries (on-prem and Azure, multiple regions, multiple subscriptions, different networks), actively search MCP for implications specific to the services and boundaries involved. Common concerns include connectivity, DNS resolution, latency, authentication across boundaries, and reliability of the links between them.

Do not attempt to enumerate these from memory — the implications are service-specific and evolve. Let Learn be the source of truth.

MCP search: `"[service] VNet integration"`, `"[service] hybrid connectivity"`, `"[service] on-premises"`, `"[service] multi-region"`, `"migrate [workload type] to Azure considerations"`

## FinOps and cost awareness

When discussing service selection, proactively note cost implications:

- **Consumption vs. provisioned** — serverless (Functions, Container Apps) vs. always-on (App Service, AKS)
- **Tier selection** — Basic/Standard/Premium trade-offs for the specific service
- **Reserved capacity** — when steady-state workloads justify 1-year or 3-year reservations
- **Right-sizing** — start small, scale up based on observed metrics
- Direct users to the Azure Pricing Calculator for specific estimates

## Azure Verified Modules (AVM)

When users ask about implementation after architecture decisions are made:

- Point to AVM as pre-built, WAF-aligned Bicep/Terraform modules
- Search MCP: `"Azure Verified Modules"` for the catalog
- Note: this skill does not generate IaC — AVM is the recommended path for deployment artifacts

## Live documentation

| Topic | MCP search query |
|-------|-----------------|
| Architecture Center browse | `"Azure Architecture Center"` |
| Solution ideas | `"Azure solution ideas [domain]"` (e.g., `"Azure solution ideas retail"`) |
| Technology choices | `"choose an Azure [category] service"` (e.g., compute, data store, messaging, load balancing) |
| Reference architectures | `"Azure reference architecture [workload]"` (e.g., `"Azure reference architecture web application"`) |
| Service comparison | `"Azure [service A] vs [service B] comparison"` |
| Service limits | `"Azure [service] limits quotas"` |
| Pricing tiers | `"Azure [service] pricing tiers comparison"` |
| AVM modules | `"Azure Verified Module bicep [resource type]"` or `"AVM terraform [resource type]"` |
