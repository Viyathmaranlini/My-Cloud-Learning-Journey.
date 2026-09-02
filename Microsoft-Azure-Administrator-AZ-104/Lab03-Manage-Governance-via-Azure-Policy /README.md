# Lab 03 – Manage Governance via Azure Policy

## ⚖️ Overview
This lab focuses on implementing organizational governance in Azure using **resource tags** and **Azure Policy**. It covers enforcing tagging standards, automatically remediating non-compliant resources, and protecting resources with locks.

Tags were applied to a resource group, a policy was assigned to **enforce** required tags on new resources, a second policy was used to **inherit** tags onto non-compliant resources, and a resource lock was configured and tested to prevent accidental deletion.

## 📋 Lab Scenario
The organization's cloud footprint has grown considerably. A recent audit found many resources without a defined owner, project, or cost center. To improve governance, the following was implemented:
- Apply **resource tags** to attach important metadata to resources.
- **Enforce** the use of tags on new resources with Azure Policy.
- **Update** existing resources with tags via remediation.
- Use **resource locks** to protect configured resources.

## 🎯 Objectives
- Create and assign tags via the Azure portal
- Enforce tagging using a built-in Azure Policy
- Apply tags to non-compliant resources via policy remediation
- Configure and test a resource lock

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Resource Groups
- Azure Tags
- Azure Policy (built-in definitions)
- Policy Remediation & Managed Identity
- Azure Resource Locks

> ⏱️ **Estimated time:** 30 minutes
> 🌍 **Region used:** East US

---

## 1. Assign Tags via the Azure Portal
Tags are a critical part of a governance strategy, letting you identify resource owners, cost centers, sunset dates, and other important metadata. A `Cost Center` tag was assigned to a new resource group.

### Resource Group & Tag
| Setting | Value |
|---------|-------|
| Resource group name | az104-rg2 |
| Region | East US |
| Tag name | Cost Center |
| Tag value | 000 |

---

## 2. Enforce Tagging via Azure Policy
The built-in **Require a tag and its value on resources** policy was assigned to the resource group to enforce governance. Azure Policy can be assigned at the management group, subscription, or resource group scope.

### Policy Assignment
| Setting | Value |
|---------|-------|
| Policy | Require a tag and its value on resources |
| Scope | az104-rg2 |
| Tag Name | Cost Center |
| Tag Value | 000 |
| Enforcement | Enabled |

**Test:** Attempting to create a storage account **without** the `Cost Center` tag resulted in a **Validation failed** message — the deployment was disallowed by the policy.

✅ **Validation:** Resource creation without the required tag was blocked by the policy.

> ⏳ Policies can take 5–10 minutes to take effect.

---

## 3. Apply Tagging via Policy Remediation
To bring non-compliant resources into compliance automatically, the enforcement policy was replaced with the **Inherit a tag from the resource group if missing** policy, which uses the **Modify** effect (requiring a managed identity).

### Policy Assignment
| Setting | Value |
|---------|-------|
| Policy | Inherit a tag from the resource group if missing |
| Scope | az104-rg2 |
| Tag Name | Cost Center |
| Remediation task | Enabled |
| Managed identity | Required (Modify effect) |

**Test:** A new storage account was created **without** manually adding the tag. This time validation **passed**, and the `Cost Center: 000` tag was **automatically inherited** from the resource group.

✅ **Validation:** The new resource automatically received the `Cost Center: 000` tag from the resource group.

---

## 4. Configure and Test Resource Locks
Resource locks prevent deletion or modification of a resource and **override any user permissions**. A delete lock was applied to the resource group.

### Lock Configuration
| Setting | Value |
|---------|-------|
| Lock name | rg-lock |
| Lock type | Delete |
| Scope | az104-rg2 |

**Test:** Attempting to delete the resource group returned a **notification denying the deletion** — the lock must be removed before deletion is possible.

✅ **Validation:** The delete lock blocked the resource group deletion.

---

## ✅ Validation Results
- [x] Resource group `az104-rg2` created with a `Cost Center` tag
- [x] "Require a tag" policy assigned to the resource group
- [x] Non-compliant resource creation blocked by policy
- [x] Enforcement policy replaced with the "Inherit a tag" policy
- [x] Remediation task configured with a managed identity
- [x] New resource automatically inherited the `Cost Center: 000` tag
- [x] Delete lock `rg-lock` applied to the resource group
- [x] Resource group deletion blocked by the lock

## 💡 Key Takeaways
- **Tags** are key-value metadata that logically label resources for reporting and governance.
- **Azure Policy** establishes conventions for resources — definitions describe compliance conditions and the effect to apply when a condition is met.
- Many **built-in policy definitions** are available, and custom policies can also be created.
- **Remediation tasks** bring non-compliant resources into compliance (for Modify or DeployIfNotExists effects).
- **Resource locks** protect resources from accidental deletion or modification and override user permissions.
- **Azure Policy** is a **pre-deployment** security practice, while **RBAC and resource locks** are **post-deployment** practices.
