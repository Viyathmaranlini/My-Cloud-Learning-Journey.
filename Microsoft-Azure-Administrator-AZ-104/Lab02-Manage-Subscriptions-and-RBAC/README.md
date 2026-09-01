# Lab 02 – Manage Subscriptions and RBAC

## 🔑 Overview
This lab focuses on **Role-Based Access Control (RBAC)** and **management groups** in Azure. It covers using permissions and scopes to control what actions identities can perform, and organizing subscriptions to simplify management at scale.

A management group was created to organize subscriptions, a built-in role was assigned to a group, a custom RBAC role was built to enforce least privilege, and role assignments were monitored through the Activity Log.

## 📋 Lab Scenario
To simplify management of Azure resources across the organization, the following was implemented:
- A **management group** that includes all Azure subscriptions.
- Permissions to submit support requests across all subscriptions in the group — limited to creating and managing virtual machines and creating support request tickets, **without** the ability to register Azure resource providers.

## 🎯 Objectives
- Create and configure a management group
- Review built-in Azure roles
- Assign a built-in role (Virtual Machine Contributor) to a group
- Create a custom RBAC role using the least-privilege principle
- Monitor role assignments with the Activity Log

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Management Groups
- Azure Role-Based Access Control (RBAC)
- Built-in & Custom Roles
- Azure IAM (Access Control)
- Azure Activity Log

> ⏱️ **Estimated time:** 20 minutes
> 🌍 **Region used:** East US

---

## 1. Implement Management Groups
Management groups logically organize and segment subscriptions. They allow RBAC and Azure Policy to be assigned once and **inherited** by child management groups and subscriptions — instead of granting access to each subscription individually.

Created a management group under **Management groups → + Create**.

### Management Group Configuration
| Setting | Value |
|---------|-------|
| Management group ID | az104-mg164645923 |
| Display name | az104-mg164645923 |

> The built-in **root management group** sits at the top of the hierarchy — all management groups and subscriptions fold up to it, allowing global policies and role assignments at the directory level.

✅ **Validation:** The `az104-mg164645923` management group appears in the list.

---

## 2. Review and Assign a Built-In Azure Role
Azure provides many built-in roles. The **Virtual Machine Contributor** role was assigned to the **IT Helpdesk** group at the management group scope.

The Virtual Machine Contributor role lets users manage virtual machines, but **not** access their operating system or manage the connected virtual network and storage account — a good fit for a Help Desk team.

### Role Assignment
| Setting | Value |
|---------|-------|
| Role | Virtual Machine Contributor |
| Assigned to | IT Helpdesk (group) |
| Scope | az104-mg164645923 |
| Assignment type | Eligible |

> 💡 **Best practice:** Always assign roles to **groups**, not individual users.

✅ **Validation:** The IT Helpdesk group shows the Virtual Machine Contributor role in the Role assignments tab.

---

## 3. Create a Custom RBAC Role
Custom roles are core to enforcing the **principle of least privilege**. When a built-in role has more permissions than needed, a custom role can be created and trimmed down.

Created a custom role by cloning an existing role and excluding an unwanted permission.

### Custom Role Configuration
| Setting | Value |
|---------|-------|
| Custom role name | Custom Support Request64645923 |
| Description | A custom contributor role for support requests. |
| Baseline permissions | Clone a role → Support Request Contributor |
| Excluded permission | `Microsoft.Support` → Registers Support Resource Provider (added as a **NotAction**) |
| Assignable scope | az104-mg164645923 |

> An Azure **resource provider** is a set of REST operations that enable a specific Azure service. The Help Desk should not register providers, so this capability was excluded from the cloned role as a **NotAction**.

✅ **Validation:** The custom role was created with the excluded permission listed under NotActions in the role JSON.

---

## 4. Monitor Role Assignments with the Activity Log
The **Activity Log** provides insight into subscription-level events, including role assignments.

The `az104-mg164645923` management group's Activity Log was reviewed and filtered for role assignment operations to confirm the changes were recorded in Azure's audit trail.

✅ **Validation:** Role assignment events appear in the Activity Log.

---

## 🧹 Clean Up
To free up resources and minimize cost, the management group was deleted after completing the lab.

| Method | Command / Action |
|--------|------------------|
| Portal | Select the management group → **Delete** → Yes |
| PowerShell | `Remove-AzManagementGroup -GroupName az104-mg164645923` |
| Azure CLI | `az account management-group delete --name az104-mg164645923` |

---

## ✅ Validation Results
- [x] Management group `az104-mg164645923` created and verified
- [x] Built-in roles reviewed
- [x] Virtual Machine Contributor role assigned to the IT Helpdesk group
- [x] Role assigned at the management group scope
- [x] Custom RBAC role created by cloning Support Request Contributor
- [x] Unwanted permission excluded as a NotAction
- [x] Custom role scoped to the management group
- [x] Role assignments verified through the Activity Log

## 💡 Key Takeaways
- **Management groups** logically organize subscriptions, allowing RBAC and Policy to be inherited across them.
- The built-in **root management group** contains all management groups and subscriptions.
- Azure provides many **built-in roles** that control access to resources.
- **Custom roles** can be created or cloned and trimmed to enforce least privilege.
- Roles are defined in a **JSON** file containing `Actions`, `NotActions`, and `AssignableScopes`.
- The **Activity Log** provides an audit trail for monitoring role assignments.
