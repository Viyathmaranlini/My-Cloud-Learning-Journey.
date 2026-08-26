# Lab 03 – Organize and Protect Resources with Tags and Locks

## 🏷️ Overview
This lab demonstrates how to organize Azure resources using **tags** and protect them from accidental changes or deletions using **resource locks**.

Organizational tags were applied to a resource group and its storage accounts, and tag-based filtering was used to manage resources at scale. A **delete lock** and a **read-only lock** were then applied at different scopes, tested to confirm enforcement, and removed to demonstrate the full lock lifecycle.

## 🎯 Objectives
- Create an Azure Resource Group with two Storage Accounts
- Apply organizational tags to a resource group and its resources
- Use tag-based filtering to organize resources
- Apply a delete lock to a storage account
- Apply a read-only lock to a resource group
- Test lock enforcement on modify and delete operations
- Remove locks and confirm normal operations are restored
- Demonstrate the full lock lifecycle: apply → enforce → remove → confirm

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Resource Groups
- Azure Storage Accounts
- Azure Tags
- Azure Resource Locks
- Azure Activity / Governance controls

---

## 1. Prepare the Azure Environment
Created a Resource Group to provide a sandbox environment for practicing tagging and locking, along with a test Storage Account to apply tags and locks to.

**Resource Group:**

`rg-gp-tags-locks`

**Storage Account:**

`stgptagslock64467472`

### Storage Configuration
| Setting | Configuration |
|---------|---------------|
| Resource Group | rg-gp-tags-locks |
| Storage Type | Azure Blob Storage |
| Performance | Standard |
| Redundancy | Locally-redundant storage (LRS) |

---

## 2. Tag the Resource Group
Organizational tags were applied to the resource group. Tags are key-value pairs that help categorize resources, track costs by department or project, and enforce governance policies.

### Tag Configuration
| Key | Value |
|-----|-------|
| department | development |
| environment | test |

---

## 3. Tag the Storage Account
The same tags were applied to the storage account. Tagging resources individually ensures accurate cost reporting even when multiple teams share a resource group.

### Tag Configuration
| Key | Value |
|-----|-------|
| department | development |
| environment | test |

---

## 4. Create a Second Storage Account with Different Tags
A second Storage Account was created with different tag values to demonstrate how tags enable filtering and cost allocation across teams.

**Storage Account:**

`stgptagsops64467472`

### Tag Configuration
| Key | Value |
|-----|-------|
| department | operations |
| environment | test |

---

## 5. Filter Resources by Tag
Tag-based filtering was used on the resource list to display only the resources belonging to a specific department.

| Filter | Result |
|--------|--------|
| `department` Equals `development` | Only `stgptagslock` appears |
| `department` Equals `operations` | Only `stgptagsops` appears |

This demonstrated the practical value of consistent tagging for managing resources at scale.

---

## 6. Apply a Delete Lock to the Storage Account
A **delete lock** was applied to the first storage account. A delete lock allows normal read and write operations but blocks deletion until the lock is removed, protecting critical resources from human error.

### Lock Configuration
| Setting | Value |
|---------|-------|
| Lock name | prevent-delete |
| Lock type | Delete |
| Scope | stgptagslock64467472 |

---

## 7. Apply a Read-Only Lock to the Resource Group
A **read-only lock** was applied at the resource group scope. A read-only lock prevents any modifications to resources within the group, including creating new resources.

### Lock Configuration
| Setting | Value |
|---------|-------|
| Lock name | read-only-rg |
| Lock type | Read-only |
| Scope | rg-gp-tags-locks |

The resource group Locks pane also displayed the `prevent-delete` lock scoped to the storage account — resource group locks inherit and display locks from child resources.

---

## 8. Test Lock Enforcement
The locks were tested to confirm they block operations as expected.

### Read-Only Lock Test
Attempting to add a new tag (`test-tag: blocked`) to the resource group **failed** with an error indicating the resource group is locked.

### Delete Lock Test
Attempting to delete the storage account was **blocked** with an error referencing the delete lock.

This confirmed that both governance controls were active and protecting the environment.

---

## 9. Remove the Locks & Confirm Normal Operations
Both locks were removed from the resource group Locks pane, which manages locks across all child resources from a single location.

After removal:
- Adding a tag (`lock-test: passed`) to the resource group **succeeded**, confirming write permissions were restored.
- The test tag was then removed to clean up.

This completed the full lock lifecycle: **apply → enforce → remove → confirm**.

---

## ✅ Validation Results
- [x] Resource Group created successfully
- [x] Test Storage Account created
- [x] Organizational tags applied to the resource group
- [x] Organizational tags applied to the storage account
- [x] Second storage account created with different tags
- [x] Tag-based filtering verified for each department value
- [x] Delete lock applied to the storage account
- [x] Read-only lock applied to the resource group
- [x] Lock inheritance verified at the resource group scope
- [x] Read-only lock enforcement verified (modification blocked)
- [x] Delete lock enforcement verified (deletion blocked)
- [x] Locks removed successfully
- [x] Normal operations restored and confirmed
- [x] Full lock lifecycle successfully demonstrated

## 💡 Key Takeaways
- Tags are key-value pairs used to categorize resources, track costs, and enforce governance.
- Consistent tagging enables filtering and cost allocation across teams at scale.
- A **delete lock** blocks deletion while still allowing read and write operations.
- A **read-only lock** blocks all modifications, including creating new resources.
- Resource group locks inherit and display locks from child resources, allowing centralized lock management.
- Locks protect resources even from users who have full permissions.
- The full lock lifecycle — apply, enforce, remove, and confirm — ensures resources stay protected while remaining manageable.
