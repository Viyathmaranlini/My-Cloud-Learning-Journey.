# Lab 04 – Share Files Securely

## 🔒 Overview
This lab demonstrates how to securely share a file with an external partner using **Shared Access Signatures (SAS)** backed by a **stored access policy**, and how to automatically clean up shared files using **lifecycle management**.

A private blob container was created and a report file uploaded. A stored access policy was defined on the container, and a SAS URL was generated from it to grant temporary read-only access. Partner access was tested, then instantly revoked by deleting the policy. Finally, a lifecycle rule was configured to auto-delete shared files after 30 days.

## 🎯 Objectives
- Create a storage account with a private blob container
- Upload a report file to the private container
- Create a stored access policy on the container
- Generate a SAS URL that inherits rules from the policy
- Verify that direct (unauthenticated) access is blocked
- Test SAS-based partner access
- Revoke partner access by deleting the stored access policy
- Configure a lifecycle management rule to auto-delete files after 30 days

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Resource Groups
- Azure Storage Accounts
- Azure Blob Storage (Containers)
- Shared Access Signatures (SAS)
- Stored Access Policies
- Azure Storage Lifecycle Management

---

## 1. Prepare the Azure Environment
Created a Resource Group and a Storage Account to provide a secure foundation for sharing files. The storage account provides encryption at rest and in transit.

**Resource Group:**

`rg-gp-file-exchange`

**Storage Account:**

`stgpfilexchg64469050`

### Storage Configuration
| Setting | Configuration |
|---------|---------------|
| Resource Group | rg-gp-file-exchange |
| Storage Type | Azure Blob Storage |
| Performance | Standard |
| Redundancy | Locally-redundant storage (LRS) |

---

## 2. Create the Private Container
A blob container was created with **private** access. This ensures that even if the container URL is discovered, blobs cannot be listed or accessed without explicit permissions such as a SAS token.

### Container Configuration
| Setting | Value |
|---------|-------|
| Container name | partner-drop |
| Anonymous access level | Private (no anonymous access) |

---

## 3. Upload the Report File
A sample report file (`monthly-report.txt`) was uploaded to the `partner-drop` container. Once uploaded, only users with explicit permissions or a valid SAS token can download it.

**Uploaded file:**

`monthly-report.txt`

---

## 4. Create a Stored Access Policy
A stored access policy was created on the container to act as a central control point. Instead of managing individual one-off SAS tokens, the policy defines the permissions and expiry once at the container level — and deleting the policy instantly revokes every SAS token linked to it.

### Access Policy Configuration
| Setting | Value |
|---------|-------|
| Identifier | partner-read-policy |
| Permissions | Read only |
| Start time | Effective immediately (today) |
| Expiry time | 1 hour from start |

> ⚠️ The policy must be **saved** after being added, or it will not be created.

---

## 5. Generate a SAS from the Stored Access Policy
A SAS token was generated on the `monthly-report.txt` blob using the `partner-read-policy`. Because the token inherits its rules from the policy, the Permissions and Expiry fields are grayed out — all tokens share the same rules, and revoking the policy revokes them all.

The **Blob SAS URL** was copied and saved securely for use in partner-access testing.

---

## 6. Test Partner Access
Both sides of the access model were tested to demonstrate the security boundary between direct access and token-based access.

### Direct Access (Blocked)
The direct blob URL (without a SAS token) was pasted into an incognito browser window. Access was **denied** with an authentication error.

### SAS Access (Allowed)
The SAS URL was pasted into the same incognito window. The file content **displayed successfully**, even though the session was not signed in — access was granted purely by the SAS token.

---

## 7. Revoke Partner Access
Partner access was revoked immediately by **deleting the stored access policy**, rather than waiting for the token to expire.

| Step | Result |
|------|--------|
| SAS URL before revocation | File content still displays (token valid) |
| Delete `partner-read-policy` and Save | Policy removed |
| SAS URL after revocation | Access denied with authorization error |
| Check file in container | `monthly-report.txt` still exists |

> Deleting the policy invalidated the SAS token **instantly**, even before its expiry time. Revoking access only removes the access pathway — it does not delete the underlying data.

---

## 8. Configure Lifecycle Management
A lifecycle management rule was created to automatically delete shared files after 30 days, ensuring old files don't accumulate indefinitely.

### Lifecycle Rule Configuration
| Setting | Value |
|---------|-------|
| Rule name | delete-shared-files |
| Blob type | Block blobs |
| Condition | Last modified more than 30 days ago |
| Action | Delete the blob |
| Prefix match (scope) | partner-drop/ |

> Lifecycle rules run once per day. The prefix `partner-drop/` scopes the rule to only the partner exchange container — blobs in other containers are unaffected.

---

## ✅ Validation Results
- [x] Resource Group created successfully
- [x] Storage Account deployed and verified
- [x] Private container `partner-drop` created (Private access)
- [x] `monthly-report.txt` uploaded to the container
- [x] Stored access policy `partner-read-policy` created with Read permission
- [x] SAS URL generated from the stored access policy
- [x] Direct (unauthenticated) access confirmed blocked
- [x] SAS-based access confirmed working
- [x] Stored access policy deleted to revoke access
- [x] SAS access confirmed revoked instantly
- [x] File confirmed still present after revocation
- [x] Lifecycle rule `delete-shared-files` created and verified

## 💡 Key Takeaways
- A **private container** blocks all access unless explicit permissions or a valid SAS token are provided.
- A **SAS token** grants temporary, scoped access to a file without requiring a sign-in.
- A **stored access policy** centralizes SAS rules (permissions and expiry) at the container level.
- Deleting a stored access policy **instantly revokes** every SAS token generated from it — even before expiry.
- Revoking access removes the access pathway but does **not** delete the underlying data.
- **Lifecycle management** rules automatically clean up shared files after a set period, reducing manual overhead.
- This is the enterprise approach to secure file sharing — controlled, revocable, and self-cleaning.
