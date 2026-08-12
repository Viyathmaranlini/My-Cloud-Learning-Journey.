# ☁️ Lab 04: Share Files Securely (Azure Storage & SAS)

## 📌 Overview
This hands-on lab focuses on configuring secure file-sharing mechanisms within Microsoft Azure using Azure Storage accounts, Azure Files, File Shares, and Shared Access Signatures (SAS) to restrict access to sensitive cloud data.

---

## 🎯 Key Learning Objectives
* **Create and Configure Azure File Shares:** Set up cloud-based file shares for organizational file access.
* **Implement Shared Access Signatures (SAS):** Generate granular, time-bound access tokens for secure file access without sharing account keys.
* **Configure Azure Storage Firewalls & Virtual Networks:** Restrict access to designated IP addresses and network ranges.
* **Verify Access Control:** Test authorized vs. unauthorized access to shared files.

---

## 🛠️ Services & Features Used
* **Azure Storage Account**
* **Azure Files / File Share**
* **Shared Access Signatures (SAS Token & URL)**
* **Network Security / Storage Firewalls**

---

## 🚀 Key Steps & Configuration

### 1. File Share Creation
* Created an Azure File Share named `corporate-fileshare` inside the primary Azure Storage Account.
* Uploaded test documentation to verify file access.

### 2. Secure Access Generation (SAS)
* Generated a **Service SAS** for specified files with `Read` and `List` permissions only.
* Set an expiration time limit to ensure temporary access validity.

### 3. Testing Access Restrictions
* Verified successful file access via the generated SAS Blob/File URL.
* Verified access revocation after token expiration.

---

## 📸 Key Takeaways
> Shared Access Signatures (SAS) provide a secure way to grant limited access to objects in your storage account without exposing your account key. This aligns with the Principle of Least Privilege (PoLP).
