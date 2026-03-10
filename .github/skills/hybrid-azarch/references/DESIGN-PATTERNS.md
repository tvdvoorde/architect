# Cloud Design Patterns

> For behavioral rules (context gathering, decision clarity, quality attributes), see SKILL.md.

Cloud design patterns from the Azure Architecture Center catalog. Use these to address specific architectural challenges in Azure workloads.

## When to use

- User describes a specific architectural problem (cascading failures, data consistency, load handling)
- User asks about a pattern by name (circuit breaker, CQRS, saga)
- User wants to know how patterns compose together in a solution

## Pattern selection approach

1. **Identify the problem category** — What challenge is the user facing?
2. **Recommend applicable patterns** — Usually 1–3 patterns address a problem
3. **Explain composition** — Patterns rarely work alone; explain how they combine
4. **Note Azure implementation** — Which Azure services naturally implement or support the pattern

Always search MCP for the specific pattern page: `microsoft_docs_search` with `"[pattern name] cloud design pattern"`.

## Pattern catalog by problem category

### Reliability & resilience

| Pattern | Problem it solves | Azure implementation |
|---------|------------------|---------------------|
| Retry | Transient failures in service calls | Built into Azure SDKs; Polly (.NET), resilience4j (Java) |
| Circuit Breaker | Cascading failures when a dependency is down | Polly (.NET), custom middleware, or API Management policies |
| Bulkhead | One failing component consuming all resources | Separate App Service plans, container resource limits, thread pool isolation |
| Queue-Based Load Leveling | Traffic spikes overwhelming a service | Service Bus, Queue Storage, Event Hubs as buffer |
| Health Endpoint Monitoring | Detecting degraded services | Custom health endpoints + Azure Front Door / Load Balancer health probes |
| Compensating Transaction | Rolling back distributed operations | Custom logic or workflow orchestration (Durable Functions, Logic Apps) |
| Deployment Stamps | Scaling across independent units | Repeated infrastructure per region/tenant via IaC |

**Common composition:** Retry + Circuit Breaker + Bulkhead — the "resilience trinity" for service-to-service calls.

### Data management

| Pattern | Problem it solves | Azure implementation |
|---------|------------------|---------------------|
| CQRS | Read and write models have different needs | Separate read/write stores (e.g., SQL for writes, Cosmos DB or Redis for reads) |
| Event Sourcing | Need full audit trail or temporal queries | Event Hubs or Cosmos DB change feed as event store |
| Saga | Distributed transactions across services | Durable Functions orchestration, or choreography via Service Bus |
| Materialized View | Expensive queries on normalized data | Pre-computed views in Redis, Cosmos DB, or dedicated read database |
| Sharding | Single database cannot handle load/size | Cosmos DB partitioning, Azure SQL elastic pools, application-level sharding |
| Cache-Aside | Repeated reads of slow-changing data | Azure Redis Cache with application-managed cache logic |
| Valet Key | Secure direct access to storage | SAS tokens for Azure Blob Storage |

**Common composition:** CQRS + Event Sourcing + Materialized View — for systems needing different read/write optimization and full audit trail.

### Messaging & communication

| Pattern | Problem it solves | Azure implementation |
|---------|------------------|---------------------|
| Publisher-Subscriber | Decoupling event producers from consumers | Event Grid, Service Bus Topics |
| Competing Consumers | Scaling message processing | Service Bus Queues with multiple consumers |
| Priority Queue | Some messages need faster processing | Service Bus sessions or multiple queues with priority routing |
| Claim Check | Large messages exceeding broker limits | Store payload in Blob Storage, send reference via Service Bus |
| Choreography | Coordinating services without central orchestrator | Event Grid or Service Bus with event-driven consumers |
| Orchestrator | Coordinating complex multi-step workflows | Durable Functions, Logic Apps |
| Asynchronous Request-Reply | Long-running operations in request/response APIs | Return 202 Accepted + status endpoint; Durable Functions HTTP APIs |

**Common composition:** Publisher-Subscriber + Competing Consumers + Queue-Based Load Leveling — for scalable event-driven architectures.

### API & gateway

| Pattern | Problem it solves | Azure implementation |
|---------|------------------|---------------------|
| Gateway Aggregation | Client needs data from multiple services | API Management policies, Azure Functions as BFF |
| Gateway Routing | Single entry point routing to backend services | API Management, Azure Front Door, Application Gateway |
| Gateway Offloading | Cross-cutting concerns (auth, TLS, rate limiting) | API Management, Application Gateway with WAF |
| Backends for Frontends (BFF) | Different clients need different API shapes | Separate API layer per client type (web, mobile, IoT) |
| Strangler Fig | Incrementally migrating from legacy to modern | API Management or Front Door routing traffic between old and new |
| Anti-Corruption Layer | Isolating modern system from legacy interfaces | Adapter service translating between systems |

**Common composition:** Gateway Routing + Gateway Offloading + BFF — for API-first architectures with multiple client types.

### Scalability & performance

| Pattern | Problem it solves | Azure implementation |
|---------|------------------|---------------------|
| Throttling | Protecting services from overload | API Management rate limiting, application-level throttling |
| Static Content Hosting | Offloading static assets from compute | Azure Blob Storage + CDN |
| Geode | Deploying to multiple regions with local data | Cosmos DB multi-region writes + regional compute |
| Index Table | Optimizing queries over non-primary keys | Secondary indexes in Cosmos DB, dedicated lookup tables |

## Pattern composition rules

When recommending patterns:

1. **Start with the core problem** — recommend the primary pattern first
2. **Layer supporting patterns** — add patterns that address secondary concerns the primary introduces
3. **Avoid over-patterning** — not every system needs CQRS + Event Sourcing; match complexity to actual need
4. **Consider team capability** — some patterns (saga, event sourcing) require significant implementation effort; ensure the team is ready

## When NOT to use a pattern

Every pattern page in the Architecture Center includes a "When not to use" section. Always check this via MCP. Common reasons to skip a pattern:

- **Simplicity suffices** — If a direct call works fine, don't add a queue just for the pattern
- **Low scale** — Patterns like sharding and CQRS add complexity that only pays off at scale
- **Team readiness** — Event sourcing requires a mindset shift; don't adopt it mid-crisis
- **Operational cost** — Each pattern adds services to monitor and maintain

## Live documentation

| Topic | MCP search query |
|-------|-----------------|
| Full pattern catalog | `"cloud design patterns Azure"` |
| Specific pattern | `"[pattern name] cloud design pattern Azure"` (e.g., `"Circuit Breaker cloud design pattern Azure"`) |
| Pattern categories | `"Azure Architecture Center design patterns catalog"` |
| Reliability patterns | `"reliability patterns Azure architecture"` |
| Data patterns | `"data management patterns cloud"` |
| Messaging patterns | `"messaging patterns Azure architecture"` or `"asynchronous messaging Azure"` |
| API gateway patterns | `"API gateway pattern Azure"` or `"backends for frontends pattern Azure"` |
| Pattern implementation | `"[pattern name] implementation Azure [service]"` (e.g., `"retry implementation Azure SDK"`) |
