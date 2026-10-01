# Lab 08 – Manage Azure Storage

## 💾 Overview
This lab covers creating and securing **Azure Storage** for both **Blob storage** and **Azure Files**. It includes configuring a geo-redundant storage account, applying lifecycle and retention policies, controlling access with **SAS tokens** and **RBAC**, and restricting network access using **service endpoints**.

A storage account with public access disabled was created, a lifecycle rule moved infrequently accessed data to a cooler tier, a blob container was protected with a time-based retention policy, limited access was granted through a user delegation SAS, and a file share was managed through Storage Browser before network access was locked down to a virtual network.

## 📋 Lab Scenario
The organization stores data in on-premises data stores, and most files are rarely accessed. To minimize cost, infrequently accessed files should move to lower-priced storage tiers. The organization also wants to explore Azure Storage protection mechanisms — network access, authentication, authorization, and replication — and determine how suitable **Azure Files** is for hosting on-premises file shares.

## 🎯 Objectives
- Create and configure a geo-redundant storage account with no public access
- Configure a lifecycle management rule to move data to the cool tier
- Create a secure blob container with a time-based retention policy
- Upload blobs and grant limited access using a SAS token
- Create and manage an Azure file share using Storage Browser
- Restrict storage account access to a virtual network using service endpoints

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Storage Accounts (GRS / RA-GRS)
- Azure Blob Storage & Containers
- Azure Files (Classic file shares)
- Lifecycle Management
- Immutable Blob Storage (Time-based retention)
- Shared Access Signatures (User delegation SAS)
- Azure RBAC (Storage Blob Data Contributor)
- Virtual Networks & Service Endpoints
- Azure Storage Browser

> ⏱️ **Estimated time:** 50 minutes
> 🌍 **Region used:** East US

---

## 1. Create and Configure a Storage Account
A storage account was created using **geo-redundant storage** with public network access disabled.

### Storage Account Configuration
| Setting | Value |
|---------|-------|
| Resource group | az104-rg7 |
| Region | East US |
| Performance | Standard |
| Preferred storage type | Azure Blob Storage or Azure Data Lake Storage |
| Redundancy | Geo-redundant storage (GRS) |
| Read access on regional unavailability | Enabled (RA-GRS) |
| Public network access | Disabled |

> 💡 **Standard** performance suits most applications; **Premium** is for enterprise or high-performance workloads.

The **Data protection** tab showed a default soft delete retention of **7 days**, with optional blob versioning. Public network access was then reconfigured to **Enabled from selected networks**.

### Lifecycle Management Rule
| Setting | Value |
|---------|-------|
| Rule name | Movetocool |
| Condition | Base blobs last modified more than **30 days** ago |
| Action | Move to cool storage |

✅ **Validation:** The storage account was deployed with GRS redundancy and the `Movetocool` lifecycle rule was created.

---

## 2. Create and Configure Secure Blob Storage
Blob containers are directory-like structures that store unstructured data.

### Container & Retention Policy
| Setting | Value |
|---------|-------|
| Container name | data |
| Public access level | Private (no anonymous access) |
| Immutable policy type | Time-based retention |
| Retention period | 180 days |

### Manage Blob Uploads
- Enabled **Allow storage account key access** under the storage account configuration.
- Assigned the **Storage Blob Data Contributor** and **Storage File Data Privileged Contributor** roles through **Access Control (IAM)**.
- Uploaded a file to the `data` container.

| Upload Setting | Value |
|----------------|-------|
| Blob type | Block blob |
| Block size | 4 MiB |
| Access tier | Hot |
| Upload to folder | securitytest |

**Test – anonymous access:** Opening the blob URL in an InPrivate browser window returned an XML error (`ResourceNotFound` / `PublicAccessNotPermitted`) — expected, since the container is private.

### Limited Access with a SAS Token
| Setting | Value |
|---------|-------|
| Signing method | User delegation key |
| Permissions | Read |
| Start / Expiry | Yesterday → Tomorrow |
| Allowed IP addresses | Blank |

**Test – SAS access:** Opening the generated Blob SAS URL in an InPrivate window displayed the file contents.

✅ **Validation:** Anonymous access was denied, while the SAS URL granted time-limited read access.

---

## 3. Create and Configure Azure File Storage
Azure Files was configured and then secured, using **Storage Browser** to manage the share.

### File Share Configuration
| Setting | Value |
|---------|-------|
| Share name | share1 |
| Access tier | Transaction optimized |
| Backup | Disabled (to simplify the lab) |

A file was uploaded to `share1` through **Storage Browser**, which provides a single place to view and manage all storage services in the account.

### Restrict Network Access
A virtual network with a **service endpoint** for `Microsoft.Storage` was created, and the storage account was limited to that network.

| Setting | Value |
|---------|-------|
| Virtual network | vnet1 |
| Service endpoint | Microsoft.Storage |
| Subnet | default |
| Allowed traffic | Selected virtual network only |

**Test:** Refreshing Storage Browser returned a **"not authorized to perform this operation"** message, because the connection no longer originated from the allowed virtual network.

✅ **Validation:** Access to blob and file content was blocked from outside the virtual network.

---

## ✅ Validation Results
- [x] Geo-redundant storage account created with public access disabled
- [x] Public network access scoped to selected networks
- [x] Lifecycle rule `Movetocool` created (30 days → cool tier)
- [x] Private blob container `data` created
- [x] Time-based retention policy (180 days) applied to the container
- [x] RBAC roles assigned for blob and file access
- [x] File uploaded to the `securitytest` folder
- [x] Anonymous access denied for the private container
- [x] User delegation SAS granted time-limited read access
- [x] File share `share1` created and file uploaded via Storage Browser
- [x] Service endpoint configured on `vnet1`
- [x] Storage access restricted to the virtual network and verified

## 💡 Key Takeaways
- **Standard** performance fits most workloads; **Premium** is for high-performance enterprise needs.
- **Geo-redundant storage** replicates data to a secondary region, and **read access** can be enabled for regional outages.
- **Lifecycle management** rules automatically move data to cooler tiers to reduce storage cost.
- **Time-based retention** policies make blob data immutable for a set period.
- A **SAS token** grants limited, time-bound access without exposing account keys, and a **user delegation SAS** is backed by Microsoft Entra credentials.
- **Storage Browser** gives a single portal view for managing blobs, file shares, queues, and tables.
- **Service endpoints** let a storage account accept traffic only from specific virtual networks, blocking everything else.
