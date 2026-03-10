# How to Secure an Azure Key Vault

Azure Key Vault protects cryptographic keys, certificates, and secrets (such as connection strings and passwords). When storing sensitive and business-critical data, you must take deliberate steps to maximize the security of your vaults and the data stored in them. The guidance below follows the [Zero Trust principles](https://learn.microsoft.com/security/zero-trust/): **Verify explicitly**, **Use least privilege access**, and **Assume breach**.

> **Source:** [Secure your Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/secure-key-vault)

---

## 1. Vault Architecture

Getting the vault structure right is the foundation of Key Vault security. Grouping too many secrets into a single vault increases the **blast radius** of any breach.

| Recommendation | Rationale |
|----------------|-----------|
| **One vault per application, region, and environment** | Isolates blast radius; development, pre-production, and production secrets cannot cross-contaminate |
| **One vault per tenant in multi-tenant solutions** | Maintains data isolation between customers |
| **Do not use Key Vault as a general-purpose data store** | Key Vault is optimized for cryptographic material, not high-throughput configuration reads; use Azure App Configuration or Azure Storage for those scenarios |
| **Store certificates as Key Vault certificates** (not secrets) | Enables auto-rotation and lifecycle management via the Certificates API |

---

## 2. Identity and Access Management

Key Vault uses **Microsoft Entra ID** for all authentication. Access is split across two planes:

- **Control plane** — manages the vault itself (ARM operations: create, delete, configure)
- **Data plane** — manages keys, secrets, and certificates inside the vault

### 2.1 Use RBAC (not legacy access policies)

Azure RBAC is the recommended permission model. Legacy vault access policies have known security gaps and **do not support Privileged Identity Management (PIM)**.

Key built-in RBAC roles:

| Role | Scope | Use for |
|------|-------|---------|
| Key Vault Administrator | Vault | Full management (restrict tightly) |
| Key Vault Secrets Officer | Vault or object | Create/manage secrets |
| Key Vault Secrets User | Vault or object | Read secrets (applications) |
| Key Vault Crypto Officer | Vault | Create/manage keys |
| Key Vault Crypto User | Vault | Use keys for cryptographic operations |
| Key Vault Certificate Officer | Vault | Create/manage certificates |
| Key Vault Reader | Vault | Read vault metadata only |

> Enforce RBAC organization-wide: [Azure Key Vault should use RBAC permission model](https://learn.microsoft.com/azure/key-vault/general/azure-policy) (Azure Policy built-in)

### 2.2 Use managed identities for applications

Never store credentials in application code or configuration files. Assign a **system-assigned** or **user-assigned managed identity** to every Azure resource (App Service, VM, Azure Function, Container App, etc.) that needs Key Vault access, then grant that identity the appropriate RBAC role.

```bash
# Example: grant an App Service managed identity read access to secrets
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee-object-id <managed-identity-principal-id> \
  --scope /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<vault>
```

> Reference: [Azure Key Vault authentication](https://learn.microsoft.com/azure/key-vault/general/authentication)

### 2.3 Just-in-time (JIT) access for administrators

Use **Azure Privileged Identity Management (PIM)** to eliminate standing administrative access:

1. Assign the Key Vault Administrator role as an **eligible** assignment (not permanent).
2. Require **justification** and **MFA** for activation.
3. Set a maximum activation duration (e.g., 8 hours).
4. Require at least one **approver** for activation.
5. Conduct regular **access reviews** to revoke unnecessary eligibility.

> Reference: [PIM overview](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure)

### 2.4 Enforce least privilege

- Grant only the permissions required for each role (read vs. manage vs. administer).
- Separate key management roles (who creates/rotates keys) from cryptographic operation roles (who encrypts/decrypts with keys).
- Enable **Microsoft Entra Conditional Access** to restrict access by location, device compliance, or risk level.

---

## 3. Network Security

Reduce the network attack surface by routing all Key Vault traffic through private, controlled paths.

### Option A — Private Endpoints (most restrictive, recommended for production)

Deploy **Azure Private Link** to create a private IP endpoint for Key Vault inside your VNet. This completely removes Key Vault from the public internet.

```bash
az network private-endpoint create \
  --name kv-private-endpoint \
  --resource-group <rg> \
  --vnet-name <vnet> --subnet <subnet> \
  --private-connection-resource-id /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<vault> \
  --group-id vault \
  --connection-name kv-connection
```

Pair with a **Private DNS Zone** (`privatelink.vaultcore.azure.net`) to override public DNS resolution.

> Reference: [Integrate Key Vault with Azure Private Link](https://learn.microsoft.com/azure/key-vault/general/private-link-service)

### Option B — Key Vault Firewall with selected networks

If Private Link is not feasible, restrict access to specific virtual networks and/or public IP ranges:

```bash
az keyvault network-rule add \
  --name <vault> \
  --resource-group <rg> \
  --ip-address <cidr>
```

Enable **"Allow trusted Microsoft services to bypass this firewall"** only when needed (e.g., for Azure Backup, Azure Policy, or Azure Monitor).

### Option C — Network Security Perimeter

Use **Azure Network Security Perimeter** for a logical boundary that spans multiple PaaS resources. Note that `publicNetworkAccess: SecuredByPerimeter` **overrides** the trusted Microsoft services bypass.

> Reference: [Configure network security for Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/network-security)

### Summary: network options

| Option | Public access | VNet required | Recommended for |
|--------|--------------|---------------|-----------------|
| Private Endpoint | Disabled | Yes | Production workloads |
| Firewall + VNet rules | Restricted | Yes | Hybrid/legacy scenarios |
| Network Security Perimeter | Restricted | No | Cross-PaaS isolation |
| No restriction | Enabled | No | Dev/test only |

---

## 4. Data Protection

### 4.1 Enable soft delete

Soft delete acts as a recycle bin: deleted vault objects are retained for a configurable period (7–90 days, default 90 days) and can be recovered.

> ⚠️ Once enabled, soft delete **cannot be disabled**.

```bash
az keyvault update \
  --name <vault> \
  --resource-group <rg> \
  --enable-soft-delete true
```

### 4.2 Enable purge protection

Purge protection prevents permanent deletion of the vault or its objects until the retention period elapses. This protects against malicious insiders with deletion rights.

> ⚠️ Once enabled, purge protection **cannot be disabled**, and no role (including Microsoft) can override it.

```bash
az keyvault update \
  --name <vault> \
  --resource-group <rg> \
  --enable-purge-protection true
```

> Reference: [Soft-delete and purge protection](https://learn.microsoft.com/azure/key-vault/general/key-vault-recovery)

### 4.3 Implement automatic key and secret rotation

Configure automatic rotation to minimize the window of exposure from a compromised cryptographic asset:

- **Keys**: Use the [key rotation policy](https://learn.microsoft.com/azure/key-vault/keys/how-to-configure-key-rotation) to rotate on a schedule or near expiry.
- **Secrets**: Automate rotation using [Azure Functions or Event Grid triggers](https://learn.microsoft.com/azure/key-vault/secrets/tutorial-rotation).
- **Certificates**: Configure [automatic renewal](https://learn.microsoft.com/azure/key-vault/certificates/tutorial-rotate-certificates) via a connected Certificate Authority.

### 4.4 Use HSM-backed keys for high-sensitivity workloads

For keys that protect highly sensitive data:

- **Key Vault Premium** tier provides HSM-protected keys backed by FIPS 140-2 Level 2 HSMs.
- **Azure Key Vault Managed HSM** provides dedicated single-tenant FIPS 140-2 Level 3 HSMs with local RBAC.

---

## 5. Logging and Threat Detection

### 5.1 Enable audit logging

Key Vault diagnostic logs capture every operation (who accessed which secret, when, from where). Send logs to Log Analytics, Azure Storage, or Event Hubs.

```bash
az monitor diagnostic-settings create \
  --name kv-diagnostics \
  --resource /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<vault> \
  --logs '[{"category":"AuditEvent","enabled":true}]' \
  --workspace <log-analytics-workspace-id>
```

> Reference: [Key Vault logging](https://learn.microsoft.com/azure/key-vault/general/logging)

### 5.2 Enable Microsoft Defender for Key Vault

Microsoft Defender for Key Vault provides threat intelligence and anomaly detection, alerting on suspicious patterns such as:

- Access from unusual locations
- High-volume secret enumeration
- Access by terminated accounts

```bash
az security pricing create \
  --name KeyVaults \
  --tier Standard
```

> Reference: [Microsoft Defender for Key Vault](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-key-vault-introduction)

### 5.3 Set up log alerts

Create alerts for high-priority events:

| Event | Suggested alert condition |
|-------|--------------------------|
| Repeated authentication failures | >5 failures in 5 minutes from same IP |
| Secret deletion | Any delete operation in production vault |
| Policy/permission changes | Any control-plane modification |
| Access from unknown IPs | Entra ID sign-in risk policy |

> Reference: [Monitoring and alerting for Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/alert)

### 5.4 Integrate with Event Grid

Subscribe to Key Vault events via **Azure Event Grid** to trigger automated responses (e.g., rotate a secret immediately after an anomalous access event).

> Reference: [Monitoring Key Vault with Azure Event Grid](https://learn.microsoft.com/azure/key-vault/general/event-grid-overview)

---

## 6. Compliance and Governance

### 6.1 Enforce configuration with Azure Policy

Use built-in Azure Policy definitions to audit and block non-compliant Key Vault configurations at scale:

| Policy | Effect |
|--------|--------|
| Azure Key Vault should use RBAC permission model | Audit / Deny |
| Key Vault should have soft delete enabled | Audit / Deny |
| Key Vault should have purge protection enabled | Audit / Deny |
| Key Vault should restrict public network access | Audit / Deny |
| Key Vault keys should have an expiration date | Audit / Deny |
| Key Vault secrets should have an expiration date | Audit / Deny |

> Reference: [Integrate Azure Key Vault with Azure Policy](https://learn.microsoft.com/azure/key-vault/general/azure-policy)

### 6.2 TLS enforcement

Key Vault supports TLS 1.2 and 1.3. Ensure clients are configured to use TLS 1.2 minimum. Monitor the TLS version used via Key Vault logs (Kusto query on `AzureDiagnostics`).

---

## 7. Backup and Recovery

| Practice | Detail |
|----------|--------|
| **Use native Key Vault backup** | Back up individual secrets, keys, and certificates using the Key Vault backup API |
| **Back up objects that cannot be recreated** | Encryption keys protecting data at rest are irreplaceable — backup is critical |
| **Test restoration regularly** | Validate that backups can be restored before an incident occurs |
| **Cross-region redundancy** | Key Vault automatically replicates data to a paired region; verify your region pair meets compliance requirements |

> Reference: [Azure Key Vault backup](https://learn.microsoft.com/azure/key-vault/general/backup)

---

## 8. Well-Architected Framework Trade-offs

| WAF Pillar | Impact and mitigations |
|------------|------------------------|
| **Security** ✅ | Private endpoints, RBAC, managed identities, and Defender for Key Vault address the core threat surface |
| **Reliability** | Soft delete + purge protection prevent data loss; Key Vault auto-replicates to paired region. Monitor with health alerts |
| **Cost Optimization** | Premium SKU (HSM-backed keys) and Managed HSM carry higher costs — use Standard tier for secrets/certs that don't require HSM; reserve HSM for regulated key material |
| **Operational Excellence** | Automated rotation reduces manual toil and human error; Azure Policy surfaces drift early; logs in Log Analytics enable unified observability |
| **Performance Efficiency** | Cache secrets in application memory (with TTL) to reduce vault call frequency; use Key Vault references in App Service / Azure Functions to avoid inline secret management code |

---

## 9. Security Checklist

Use this checklist for each Key Vault deployment:

### Architecture
- [ ] Separate vault per application, per environment (dev / preprod / prod)
- [ ] Separate vault per tenant in multi-tenant solutions
- [ ] No general-purpose data or customer content stored in Key Vault

### Identity and access
- [ ] RBAC permission model enabled (legacy access policies disabled)
- [ ] Managed identities used for all application access (no stored credentials)
- [ ] JIT (PIM) assigned for all administrative roles
- [ ] MFA and approval required for privileged role activation
- [ ] Least-privilege roles assigned (Secrets User, not Administrator)
- [ ] Microsoft Entra Conditional Access policies applied to Key Vault authentication

### Network
- [ ] Private endpoint deployed and public access disabled
- [ ] Private DNS zone configured for `privatelink.vaultcore.azure.net`
- [ ] Firewall rules in place if public access is required

### Data protection
- [ ] Soft delete enabled (retention ≥ 90 days for production)
- [ ] Purge protection enabled on all production vaults
- [ ] Automatic rotation configured for keys, secrets, and certificates
- [ ] Expiration dates set on all keys and secrets

### Logging and monitoring
- [ ] Diagnostic logs (AuditEvent) sent to Log Analytics
- [ ] Microsoft Defender for Key Vault enabled
- [ ] Alerts configured for deletion, access failures, and policy changes

### Compliance
- [ ] Azure Policy assigned to enforce RBAC, soft delete, purge protection, and network restrictions
- [ ] Regular access reviews scheduled via PIM

### Backup
- [ ] Key Vault backup configured for all vaults containing irreplaceable key material
- [ ] Restore procedure tested

---

## References

| Resource | URL |
|----------|-----|
| Secure your Azure Key Vault | https://learn.microsoft.com/azure/key-vault/general/secure-key-vault |
| Azure Key Vault authentication | https://learn.microsoft.com/azure/key-vault/general/authentication |
| Azure RBAC for Key Vault | https://learn.microsoft.com/azure/key-vault/general/rbac-guide |
| Configure network security | https://learn.microsoft.com/azure/key-vault/general/network-security |
| Private Link integration | https://learn.microsoft.com/azure/key-vault/general/private-link-service |
| Soft delete and purge protection | https://learn.microsoft.com/azure/key-vault/general/key-vault-recovery |
| Key rotation | https://learn.microsoft.com/azure/key-vault/keys/how-to-configure-key-rotation |
| Key Vault logging | https://learn.microsoft.com/azure/key-vault/general/logging |
| Defender for Key Vault | https://learn.microsoft.com/azure/defender-for-cloud/defender-for-key-vault-introduction |
| Azure Policy for Key Vault | https://learn.microsoft.com/azure/key-vault/general/azure-policy |
| Key Vault backup | https://learn.microsoft.com/azure/key-vault/general/backup |
| Privileged Identity Management | https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure |
| Well-Architected Framework — Security | https://learn.microsoft.com/azure/well-architected/security/ |
| Multitenancy and Azure Key Vault | https://learn.microsoft.com/azure/architecture/guide/multitenant/service/key-vault |
