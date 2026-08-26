# Lab 02 – Set Up New Employee Access with Microsoft Entra ID and RBAC

## 🔐 Overview

This lab demonstrates how to set up identity-based access control for a new employee using **Microsoft Entra ID** and **Azure Role-Based Access Control (RBAC)**.

A security group was created, a user was added to the group, and the **Reader** role was assigned to the group at the resource group scope. The access model was then validated to demonstrate the **principle of least privilege**.

## 🎯 Objectives

* Create an Azure Resource Group and test resource
* Create a Microsoft Entra security group
* Create and configure a user account
* Add the user to the security group
* Assign the Reader RBAC role to the group
* Verify inherited permissions using IAM
* Review RBAC changes in the Activity Log
* Validate the least-privilege access model

## 🛠️ Azure Services & Technologies

* **Microsoft Azure**
* **Microsoft Entra ID**
* **Azure Resource Groups**
* **Azure Storage Accounts**
* **Azure Role-Based Access Control (RBAC)**
* **Azure IAM**
* **Activity Log**

---

## 1. Prepare the Azure Environment

Created a Resource Group to provide a sandbox environment for practicing identity and access management.

**Resource Group:**

`rg-gp-access-model`

A test Storage Account was also created inside the Resource Group.

**Storage Account:**

`stgpaccessmodel64466195`

### Storage Configuration

| Setting        | Configuration                   |
| -------------- | ------------------------------- |
| Resource Group | `rg-gp-access-model`            |
| Storage Type   | Azure Blob Storage              |
| Performance    | Standard                        |
| Redundancy     | Locally-redundant storage (LRS) |

---

## 2. Create a Security Group

Created a **Microsoft Entra Security Group** to manage permissions through group-based access control.

**Security Group:**

`gp-rg-readers64466195`

The group was configured as a security group for managing access to the project resource group.

---

## 3. Add the User to the Group

A test user account was added to the security group.

The user was successfully added as a member of:

`gp-rg-readers64466195`

Using a group for access management allows permissions to be assigned once at the group level instead of assigning the same permissions individually to users.

---

## 4. Assign the Reader RBAC Role

The **Reader** role was assigned to the security group at the **Resource Group scope**.

### RBAC Configuration

| Setting     | Value                   |
| ----------- | ----------------------- |
| Role        | Reader                  |
| Scope       | `rg-gp-access-model`    |
| Assigned To | `gp-rg-readers64466195` |

The Reader role allows users to **view resources** but does not allow them to create, modify, or delete resources.

---

## 5. Verify Access with IAM

The **Check access** feature in Azure IAM was used to verify the user's effective permissions.

The user was shown to have the **Reader** role inherited through the security group:

`gp-rg-readers64466195`

This confirmed that the group-based RBAC assignment was working correctly.

---

## 6. Review the Activity Log

The Azure **Activity Log** was reviewed to verify the RBAC change.

A `Create role assignment` event was found, confirming that the role assignment was successfully created and recorded in Azure's audit trail.

---

## 7. Validate the Least-Privilege Model

The access model was tested using the assigned Reader permissions.

### Read Access

The test user was able to:

* View the Resource Group
* View the resources within the Resource Group
* Access Storage Account information

### Write Access

The test user was not able to create a new Storage Account within the Resource Group.

This confirmed that the user had **read-only access** and could not perform resource creation or modification operations.

---

## ✅ Validation Results

* [x] Resource Group created successfully
* [x] Test Storage Account created
* [x] Microsoft Entra Security Group created
* [x] User added to the security group
* [x] Reader role assigned to the security group
* [x] Reader role assigned at Resource Group scope
* [x] User's inherited permissions verified through IAM
* [x] RBAC assignment verified through Activity Log
* [x] Read access successfully validated
* [x] Write access successfully restricted
* [x] Least-privilege model successfully demonstrated

## 💡 Key Takeaways

* **Microsoft Entra ID** can be used to manage identities and security groups.
* **Azure RBAC** provides fine-grained access control over Azure resources.
* Assigning roles to groups simplifies permission management and makes access easier to scale.
* The **Reader** role provides read-only access without allowing resource modifications.
* IAM's **Check access** feature can be used to verify effective permissions.
* The **Activity Log** provides an audit trail for RBAC changes.
* Applying the **principle of least privilege** ensures users receive only the permissions required for their tasks.

---
