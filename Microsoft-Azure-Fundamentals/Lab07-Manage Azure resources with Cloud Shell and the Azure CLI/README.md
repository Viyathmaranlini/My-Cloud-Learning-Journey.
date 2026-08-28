# Lab 07 – Manage Azure resources with Cloud Shell and the Azure CLI

## 💻 Overview
This lab demonstrates how to manage the full lifecycle of Azure resources entirely from the command line using the **Azure CLI** in **Cloud Shell**.

A resource group and two storage accounts were created, listed, and filtered using CLI commands. Tags were applied and queried using **JMESPath** filters, the CLI output was compared against the portal, and finally all resources were cleaned up with a single delete command — completing the full resource lifecycle from the command line.

## 🎯 Objectives
- Launch Cloud Shell in Bash mode
- Verify the active account and subscription
- Explore the built-in CLI help system
- List available Azure regions
- Create a resource group and two storage accounts from the CLI
- List and filter resources by type
- Apply tags to resource groups and individual resources
- Query and reshape output using JMESPath filters
- Compare CLI results against the portal
- Delete a resource group and all its resources from the CLI

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Cloud Shell (Bash)
- Azure CLI
- Azure Resource Groups
- Azure Storage Accounts
- JMESPath (query language)

---

## 1. Launch Cloud Shell & Explore the Environment
Opened **Cloud Shell** in **Bash** mode from the Azure portal — a browser-based terminal preloaded with the Azure CLI, requiring no local installation.

**Verify the active account and subscription:**
```bash
az account show --output table
```

**List all subscriptions (if switching is needed):**
```bash
az account list --output table
```

**Explore the CLI help system:**
```bash
az --help
az group --help
az group create --help
```

**List available regions:**
```bash
az account list-locations --output table
```

> Regions are returned by their `Name` value (e.g. `eastus`, `westeurope`, `southeastasia`) — this value is used when creating resources.

---

## 2. Create Resources from the CLI

**Create a resource group:**
```bash
az group create --name rg-gp-cli-demo --location eastus
```

**Verify the resource group:**
```bash
az group show --name rg-gp-cli-demo --output table
```

**Create the first storage account:**
```bash
az storage account create \
  --name stgpclidemo0164529475 \
  --resource-group rg-gp-cli-demo \
  --location eastus \
  --sku Standard_LRS
```

**Create the second storage account:**
```bash
az storage account create \
  --name stgpclidemo0264529475 \
  --resource-group rg-gp-cli-demo \
  --location eastus \
  --sku Standard_LRS
```

> Confirm `provisioningState: Succeeded` in the JSON output for each command.

---

## 3. List & Filter Resources

**List all resources in the resource group:**
```bash
az resource list --resource-group rg-gp-cli-demo --output table
```

**Filter to show only storage accounts:**
```bash
az resource list \
  --resource-group rg-gp-cli-demo \
  --resource-type Microsoft.Storage/storageAccounts \
  --output table
```

**Show details of a specific storage account:**
```bash
az storage account show \
  --name stgpclidemo0164529475 \
  --resource-group rg-gp-cli-demo \
  --output table
```

> The `--output` flag controls the format — `table`, `json`, `jsonc`, `tsv`, and `yaml` are all supported.

---

## 4. Tag Resources from the CLI

**Tag the resource group:**
```bash
az group update \
  --name rg-gp-cli-demo \
  --tags environment=test department=it-ops
```

**Verify the resource group tags:**
```bash
az group show --name rg-gp-cli-demo --query tags
```

**Tag an individual storage account:**
```bash
az resource tag \
  --tags environment=test department=operations \
  --ids $(az storage account show \
    --name stgpclidemo0164529475 \
    --resource-group rg-gp-cli-demo \
    --query id \
    --output tsv)
```

---

## 5. Query Resources with JMESPath

**List resource names with their tags:**
```bash
az resource list \
  --resource-group rg-gp-cli-demo \
  --query "[].{Name:name, Department:tags.department, Environment:tags.environment}" \
  --output table
```

**Filter resources by a specific tag value:**
```bash
az resource list \
  --resource-group rg-gp-cli-demo \
  --query "[?tags.department=='development'].{Name:name, Type:type}" \
  --output table
```

**Count the resources in the resource group:**
```bash
az resource list \
  --resource-group rg-gp-cli-demo \
  --query "length([])"
```

> JMESPath is a built-in query language that filters and reshapes JSON output directly, without piping to external tools.

---

## 6. Compare CLI Output to the Portal
The portal was opened alongside Cloud Shell to confirm both tools manage the same underlying resources. The `rg-gp-cli-demo` resource group showed the same two storage accounts, and the **Tags** at both the resource group and resource level matched exactly what was set from the CLI.

---

## 7. Clean Up from the CLI

**Delete the resource group and everything inside it:**
```bash
az group delete --name rg-gp-cli-demo --yes --no-wait
```

**Check the deletion status:**
```bash
az group show --name rg-gp-cli-demo --output table
```

> `--yes` skips the confirmation prompt and `--no-wait` returns control immediately while deletion continues in the background. A **"not found"** error confirms the resource group was fully deleted.

---

## ✅ Validation Results
- [x] Cloud Shell launched in Bash mode
- [x] Account and subscription verified
- [x] CLI help system navigated successfully
- [x] Target region identified and recorded
- [x] Resource group `rg-gp-cli-demo` created and verified
- [x] Two storage accounts created (`provisioningState: Succeeded`)
- [x] Resources listed and filtered by type
- [x] Tags applied to the resource group and individual resources
- [x] JMESPath queries extracted and filtered tag values
- [x] CLI output confirmed to match the portal
- [x] Resource group deleted and removal confirmed

## 💡 Key Takeaways
- The **Azure CLI** manages the full resource lifecycle from a single terminal — often replacing many portal clicks with one command.
- **Cloud Shell** provides a preconfigured, browser-based CLI with no local installation required.
- The built-in **help system** (`--help`) makes it easy to discover commands and required parameters.
- The **`--output`** flag reshapes results into table, JSON, TSV, or YAML formats.
- **JMESPath** (`--query`) filters and reshapes JSON output directly within the CLI.
- **Tags** can be applied across resources quickly and consistently from the command line.
- Deleting a **resource group** removes every resource inside it — a key reason to organize resources into groups.
