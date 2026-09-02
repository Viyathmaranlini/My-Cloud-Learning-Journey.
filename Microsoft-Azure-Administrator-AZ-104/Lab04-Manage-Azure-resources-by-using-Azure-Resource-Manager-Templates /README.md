# Lab 04 – Manage Azure Resources by Using Azure Resource Manager Templates

## 📄 Overview
This lab focuses on automating resource deployments using **Azure Resource Manager (ARM) templates** and **Bicep**. It covers exporting a template from an existing resource, editing and redeploying it, and deploying templates through multiple methods.

A managed disk was created and exported as an ARM template, then redeployed through the portal, **Azure PowerShell**, the **Azure CLI**, and finally **Bicep** — deploying five disks, each a different way, to demonstrate consistent, repeatable infrastructure-as-code.

## 📋 Lab Scenario
The team wants to automate and simplify resource deployments to reduce administrative overhead, reduce human error, and increase consistency across the organization.

## 🎯 Objectives
- Create a resource and export an ARM template
- Edit an ARM template and redeploy it via the portal
- Deploy a template using Azure PowerShell
- Deploy a template using the Azure CLI
- Deploy a resource using Azure Bicep

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Resource Manager (ARM) Templates
- Azure Bicep
- Azure Managed Disks
- Azure Cloud Shell (PowerShell & Bash)
- Azure PowerShell & Azure CLI

> ⏱️ **Estimated time:** 50 minutes
> 🌍 **Region used:** East US

---

## 1. Create an ARM Template
A managed disk was created in the portal, then its template was exported for reuse in other deployments.

### Managed Disk Configuration
| Setting | Value |
|---------|-------|
| Resource group | az104-rg3 |
| Disk name | az104-disk1 |
| Region | East US |
| Performance | Standard HDD |
| Size | 32 GiB |

After deployment, the template was exported from the **Automation → Export template** blade, and both the **template.json** and **parameters.json** files were downloaded.

> 💡 You can export an entire resource group or just specific resources within it.

---

## 2. Edit and Redeploy the Template (Portal)
The downloaded template was reused to deploy a second disk via **Deploy a custom template → Build your own template in the editor**.

Edits made in the template editor:
- Changed `disks_az104_disk1_name` → `disk_name` (template + parameters files)
- Changed `az104-disk1` → `az104-disk2`

### Deployment Settings
| Setting | Value |
|---------|-------|
| Resource group | az104-rg3 |
| Region | East US |
| Disk_name | az104-disk2 |

✅ **Validation:** `az104-disk2` was created — the resource group now contains two disks. All deployments are recorded under the resource group's **Deployments** blade.

---

## 3. Deploy a Template with Azure PowerShell
Using **Cloud Shell (PowerShell)**, the template and parameters files were uploaded and the disk name was edited to `az104-disk3`.

**Confirm the correct subscription context:**
```powershell
Get-AzContext
Set-AzContext -Subscription <your-subscription-id>
```

**Deploy to the resource group:**
```powershell
New-AzResourceGroupDeployment -ResourceGroupName az104-rg3 -TemplateFile template.json -TemplateParameterFile parameters.json
```

**Confirm the disk was created:**
```powershell
Get-AzDisk | ft Name,ResourceGroupName,Location,DiskSizeGb,ProvisioningState
```

✅ **Validation:** `az104-disk3` deployed with `ProvisioningState: Succeeded`.

---

## 4. Deploy a Template with the Azure CLI
Switched Cloud Shell to **Bash**, edited the disk name to `az104-disk4`, and deployed.

**Confirm the correct subscription context:**
```bash
az account show
az account set --subscription <your-subscription-id>
```

**Deploy to the resource group:**
```bash
az deployment group create --resource-group az104-rg3 --template-file template.json --parameters parameters.json
```

**Confirm the disk was created:**
```bash
az disk list --resource-group az104-rg3 --output table
```

✅ **Validation:** `az104-disk4` deployed with `ProvisioningState: Succeeded`.

---

## 5. Deploy a Resource with Azure Bicep
**Bicep** is a declarative infrastructure-as-code language built on top of ARM templates, offering cleaner syntax and type safety. The `azuredeploydisk.bicep` file was uploaded to Cloud Shell and edited.

Edits made in the Bicep file:
- `managedDiskName` → `az104-disk5`
- `diskSizeinGiB` → `32`
- `sku` name → `StandardSSD_LRS`

**Deploy the Bicep file:**
```bash
az deployment group create --resource-group az104-rg3 --template-file azuredeploydisk.bicep
```

**Confirm the disk was created:**
```bash
az disk list --resource-group az104-rg3 --output table
```

✅ **Validation:** `az104-disk5` deployed successfully — five managed disks created, each a different way.

---

## ✅ Validation Results
- [x] Managed disk `az104-disk1` created and template exported
- [x] `az104-disk2` deployed by editing and redeploying via the portal
- [x] `az104-disk3` deployed via Azure PowerShell
- [x] `az104-disk4` deployed via the Azure CLI
- [x] `az104-disk5` deployed via Azure Bicep
- [x] All five disks confirmed in resource group `az104-rg3`
- [x] Deployment history reviewed under the resource group's Deployments blade

## 💡 Key Takeaways
- **ARM templates** let you deploy, manage, and monitor all resources for a solution as a group, rather than individually.
- An ARM template is a **JSON** file that manages infrastructure **declaratively** rather than with scripts.
- A separate **parameters file** can supply values instead of hardcoding them inline in the template.
- ARM templates can be deployed multiple ways — the **portal**, **Azure PowerShell**, and the **Azure CLI**.
- **Bicep** is a declarative alternative to ARM templates, offering concise syntax, type safety, and support for code reuse.
- Infrastructure-as-code reduces manual effort, human error, and increases consistency across deployments.
