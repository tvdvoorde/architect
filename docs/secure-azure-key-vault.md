# How to Secure an Azure Key Vault

Azure Key Vault protects cryptographic keys, certificates, and secrets in the cloud. This guide covers security best practices aligned with Zero Trust principles: **Verify explicitly**, **Use least privilege access**, and **Assume breach**.

For the official Microsoft reference, see [Secure your Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/security-features).

---

## 1. Service-Specific Architecture

### Key Vault Design

- **Use one Key Vault per application, region, and environment.** Create separate vaults for development, preproduction, and production to reduce the blast radius of a security event.
- **Use one Key Vault per tenant in multitenant solutions.** For SaaS solutions, a separate vault per tenant ensures data isolation. See [Multitenancy and Azure Key Vault](https://learn.microsoft.com/azure/architecture/guide/multitenant/service/key-vault).

### Object Storage Guidelines

- **Do not use Key Vault as a general-purpose data store.** Use [Azure Storage](https://learn.microsoft.com/azure/storage/common/storage-introduction) or [Cosmos DB](https://learn.microsoft.com/azure/cosmos-db/introduction) for application configurations and customer content.
- **Do not store certificates as secrets.** Store certificates as Key Vault certificates and configure them for autorotation. See [Azure Key Vault Certificates](https://learn.microsoft.com/azure/key-vault/certificates/about-certificates).

---

## 2. Network Security

Reducing network exposure is critical to protecting Key Vault from unauthorized access. Configure restrictions from most to least restrictive:

1. **Disable public network access and use Private Endpoints only (recommended).**  
   Deploy [Azure Private Link](https://learn.microsoft.com/azure/key-vault/general/private-link-service) to establish a private access point from a virtual network, preventing public internet exposure.

2. **Enable the Key Vault Firewall.**  
   Limit access to specific public static IP addresses or virtual networks. See [Configure network security for Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/network-security).

3. **Use Network Security Perimeter.**  
   Define a logical network isolation boundary for PaaS resources (Key Vault, Azure Storage, SQL Database) deployed outside your virtual network. See [Configure network security: Network Security Perimeter](https://learn.microsoft.com/azure/key-vault/general/network-security#network-security-perimeter).

> **Note:** Some workloads require trusted Microsoft services to bypass the firewall. Enable **Allow Trusted Microsoft Services** where needed. See [Key Vault Firewall Trusted Services](https://learn.microsoft.com/azure/key-vault/general/network-security#key-vault-firewall-enabled-trusted-services-only).

---

## 3. TLS and HTTPS

- **Enforce TLS 1.2 or 1.3.** Azure Key Vault supports both versions. Each HTTP request is independently authenticated and authorized. See [Key Vault logging](https://learn.microsoft.com/azure/key-vault/general/logging) for Kusto queries to monitor TLS versions in use.

---

## 4. Identity and Access Management

Azure Key Vault uses Microsoft Entra ID for authentication across two planes:
- **Control plane** – managing Key Vault itself
- **Data plane** – working with keys, secrets, and certificates

### Recommended Practices

1. **Enable managed identities.**  
   Use [Azure managed identities](https://learn.microsoft.com/azure/key-vault/general/authentication) for all app and service connections to eliminate hard-coded credentials.

2. **Use Azure RBAC (not legacy access policies).**  
   Azure RBAC supports Privileged Identity Management (PIM) and provides fine-grained control. See [Azure RBAC for Key Vault data plane operations](https://learn.microsoft.com/azure/key-vault/general/rbac-guide).  
   > Legacy access policies have known security vulnerabilities and should not be used for critical workloads.

3. **Assign just-in-time (JIT) privileged roles.**  
   Use [Azure Privileged Identity Management (PIM)](https://learn.microsoft.com/entra/id-governance/privileged-identity-management/pim-configure) for eligible JIT role assignments for administrators and operators.
   - Require at least one approver to activate JIT roles.
   - Enforce multi-factor authentication (MFA) for role activation. See [Microsoft Entra MFA](https://learn.microsoft.com/entra/identity/authentication/concept-mfa-howitworks).

4. **Enable Microsoft Entra Conditional Access Policies.**  
   Apply access controls based on conditions such as user location or device compliance. See [Conditional Access overview](https://learn.microsoft.com/entra/identity/conditional-access/overview).

5. **Apply the principle of least privilege.**  
   Grant only the minimum permissions required. See [Enhance security with least privileged access](https://learn.microsoft.com/entra/identity-platform/secure-least-privileged-access).

---

## 5. Data Protection

1. **Enable soft delete.**  
   Ensures deleted Key Vault objects can be recovered within a 7–90 day retention period. See [Azure Key Vault soft-delete overview](https://learn.microsoft.com/azure/key-vault/general/soft-delete-overview).

2. **Enable purge protection.**  
   Prevents accidental or malicious permanent deletion even after soft delete is enabled. See [Azure Key Vault soft-delete overview: Purge Protection](https://learn.microsoft.com/azure/key-vault/general/soft-delete-overview#purge-protection).

3. **Implement autorotation for cryptographic assets.**  
   Configure automatic rotation of keys, secrets, and certificates to minimize compromise risk.  
   - [Configure key autorotation](https://learn.microsoft.com/azure/key-vault/keys/how-to-configure-key-rotation)
   - [Configure certificate autorotation](https://learn.microsoft.com/azure/key-vault/certificates/tutorial-rotate-certificates)
   - [Automate secret rotation](https://learn.microsoft.com/azure/key-vault/secrets/tutorial-rotation)

---

## 6. Compliance and Governance

- **Use Azure Policy to enforce configuration.**  
  Configure Azure Policy to audit and enforce secure Key Vault configurations, and set up alerts for deviations. See [Azure Policy Regulatory Compliance controls for Azure Key Vault](https://learn.microsoft.com/azure/key-vault/security-controls-policy).

---

## 7. Logging and Threat Detection

1. **Enable audit logging.**  
   Key Vault logging records all operations performed on the vault. See [Key Vault logging](https://learn.microsoft.com/azure/key-vault/general/logging).

2. **Enable Microsoft Defender for Key Vault.**  
   Monitors and alerts on suspicious activity. See [Microsoft Defender for Key Vault](https://learn.microsoft.com/azure/defender-for-cloud/defender-for-key-vault-introduction).

3. **Enable log alerts for security events.**  
   Set up alerts for critical events such as access failures or secret deletions. See [Monitoring and alerting for Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/alert).

4. **Integrate with Azure Event Grid.**  
   Receive notifications on changes to keys, certificates, or secrets. See [Monitoring Key Vault with Azure Event Grid](https://learn.microsoft.com/azure/key-vault/general/event-grid-overview).

---

## 8. Backup and Recovery

1. **Enable native backup.**  
   Use the Azure Key Vault native backup feature to back up secrets, keys, and certificates. See [Azure Key Vault backup](https://learn.microsoft.com/azure/key-vault/general/backup).

2. **Back up objects that cannot be recreated.**  
   Ensure encryption keys and other non-recoverable objects are backed up.

3. **Test backup and recovery procedures regularly.**  
   Verify the restoration of Key Vault secrets, keys, and certificates to confirm backup effectiveness.

---

## Summary Checklist

| Security Domain | Key Actions |
|---|---|
| **Architecture** | Separate vaults per app, region, environment, and tenant |
| **Network** | Private Endpoints, Firewall, disable public access |
| **TLS** | Enforce TLS 1.2 or higher |
| **Identity & Access** | Managed identities, Azure RBAC, JIT via PIM, MFA, Conditional Access, least privilege |
| **Data Protection** | Soft delete, purge protection, autorotation |
| **Governance** | Azure Policy enforcement |
| **Logging** | Audit logs, Defender for Key Vault, Event Grid alerts |
| **Backup** | Native backup, test recovery procedures |

---

## Related Resources

- [Secure your Azure Key Vault keys](https://learn.microsoft.com/azure/key-vault/keys/secure-keys) – Key rotation, HSM protection, BYOK
- [Secure your Azure Key Vault secrets](https://learn.microsoft.com/azure/key-vault/secrets/secure-secrets) – Secret rotation, caching, monitoring
- [Secure your Azure Key Vault certificates](https://learn.microsoft.com/azure/key-vault/certificates/secure-certificates) – Lifecycle management, renewal, CA integration
- [Azure Key Vault best practices](https://learn.microsoft.com/azure/key-vault/general/best-practices)
- [Zero Trust Guidance Center](https://learn.microsoft.com/security/zero-trust/)
