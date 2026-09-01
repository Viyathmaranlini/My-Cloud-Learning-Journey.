# Lab 01 – Manage Microsoft Entra ID Identities

## 👤 Overview
This is the first lab in the **AZ-104 Azure Administrator** series. It focuses on **users and groups** — the basic building blocks of an identity solution in **Microsoft Entra ID**.

Internal and external (guest) user accounts were created and configured with organizational properties, and a security group was created with assigned members and owners. This demonstrates how to provision identities so that engineers can authenticate through Microsoft Entra ID.

## 📋 Lab Scenario
The organization is building a lab environment for pre-production testing of apps and services. New engineers are being hired to manage the environment, including the virtual machines. To let these engineers authenticate using Microsoft Entra ID, users and groups must be provisioned — with group membership organized to minimize administrative overhead.

## 🎯 Objectives
- Create and configure an internal user account
- Invite and configure an external (guest) user account
- Create a security group
- Add members and owners to the group
- Understand static vs. dynamic group membership

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Microsoft Entra ID
- Entra ID Users (internal & guest accounts)
- Entra ID Groups (Security groups)
- Identity & Access Management (IAM)

> ⏱️ **Estimated time:** 30 minutes
> 🌍 **Region used:** East US

---

## 1. Create and Configure User Accounts
User accounts store user data such as name, department, location, and contact information. Both an internal user and an external guest user were created.

### Internal User
Created a new user in **Microsoft Entra ID → Users → Create new user**.

| Setting | Value |
|---------|-------|
| User principal name | az104-user1 |
| Display name | az104-user1 |
| Auto-generate password | Checked |
| Account enabled | Checked |
| Job title | IT Lab Administrator |
| Department | IT |
| Usage location | United States |

### External (Guest) User
Invited an external user through **Users → Invite an external user**. The invited user receives an email invitation to join the tenant.

| Setting | Value |
|---------|-------|
| Email | *(personal email address)* |
| Display name | *(your name)* |
| Send invite message | Checked |
| Job title | IT Lab Administrator |
| Department | IT |
| Usage location | United States |

✅ **Validation:** Both the internal user (`az104-user1`) and the invited guest user appear in the Users list.

---

## 2. Create Groups and Add Members
Group accounts combine related users or devices. Members can be assigned in two ways:

- **Static (Assigned):** Administrators add and remove members manually.
- **Dynamic:** Membership updates automatically based on user or device properties (e.g. job title). *Requires an Entra ID Premium P1 or P2 license.*

### Create the Security Group
Created a new group in **Microsoft Entra ID → Groups → New group**.

| Setting | Value |
|---------|-------|
| Group type | Security |
| Group name | IT Lab Administrators |
| Group description | Administrators that manage the IT lab |
| Membership type | Assigned |

### Add Owners and Members
- **Owner:** Assigned yourself as the group owner (a group can have more than one owner).
- **Members:** Added `az104-user1` and the invited guest user.

✅ **Validation:** The `IT Lab Administrators` group was created with the correct members and owners.

---

## ✅ Validation Results
- [x] Internal user `az104-user1` created and configured
- [x] External guest user invited and configured
- [x] Both users assigned Job title, Department, and Usage location
- [x] Security group `IT Lab Administrators` created (Assigned membership)
- [x] Owner assigned to the group
- [x] Both users added as members
- [x] Group members and owners verified

## 💡 Key Takeaways
- A **tenant** represents your organization and manages a specific instance of Microsoft cloud services for internal and external users.
- Microsoft Entra ID supports both **user** and **guest** accounts, each with access scoped to the work expected of them.
- **Groups** combine related users or devices; the two main types are **Security** and **Microsoft 365**.
- Group membership can be assigned **statically** (manual) or **dynamically** (automatic, based on properties).
- Dynamic membership requires an **Entra ID Premium P1 or P2** license.
