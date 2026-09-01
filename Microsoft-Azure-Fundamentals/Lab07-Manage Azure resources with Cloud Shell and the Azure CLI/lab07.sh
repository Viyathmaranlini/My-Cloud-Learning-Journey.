#!/bin/bash
# =============================================================
# Lab 07 - Manage Azure Resources with the Azure CLI
# Cloud Learning Journey - Azure CLI Labs
#
# Run these commands in Azure Cloud Shell (Bash mode).
# Replace 'eastus' with your preferred region if needed.
# =============================================================


# -------------------------------------------------------------
# 1. Explore the Environment
# -------------------------------------------------------------

# Verify the active account and subscription
az account show --output table

# List all subscriptions (if switching is needed)
az account list --output table

# Explore the CLI help system
az --help
az group --help
az group create --help

# List available regions
az account list-locations --output table


# -------------------------------------------------------------
# 2. Create Resources
# -------------------------------------------------------------

# Create a resource group
az group create --name rg-gp-cli-demo --location eastus

# Verify the resource group
az group show --name rg-gp-cli-demo --output table

# Create the first storage account
az storage account create \
  --name stgpclidemo0164529475 \
  --resource-group rg-gp-cli-demo \
  --location eastus \
  --sku Standard_LRS

# Create the second storage account
az storage account create \
  --name stgpclidemo0264529475 \
  --resource-group rg-gp-cli-demo \
  --location eastus \
  --sku Standard_LRS


# -------------------------------------------------------------
# 3. List & Filter Resources
# -------------------------------------------------------------

# List all resources in the resource group
az resource list --resource-group rg-gp-cli-demo --output table

# Filter to show only storage accounts
az resource list \
  --resource-group rg-gp-cli-demo \
  --resource-type Microsoft.Storage/storageAccounts \
  --output table

# Show details of a specific storage account
az storage account show \
  --name stgpclidemo0164529475 \
  --resource-group rg-gp-cli-demo \
  --output table


# -------------------------------------------------------------
# 4. Tag Resources
# -------------------------------------------------------------

# Tag the resource group
az group update \
  --name rg-gp-cli-demo \
  --tags environment=test department=it-ops

# Verify the resource group tags
az group show --name rg-gp-cli-demo --query tags

# Tag an individual storage account
az resource tag \
  --tags environment=test department=operations \
  --ids $(az storage account show \
    --name stgpclidemo0164529475 \
    --resource-group rg-gp-cli-demo \
    --query id \
    --output tsv)


# -------------------------------------------------------------
# 5. Query Resources with JMESPath
# -------------------------------------------------------------

# List resource names with their tags
az resource list \
  --resource-group rg-gp-cli-demo \
  --query "[].{Name:name, Department:tags.department, Environment:tags.environment}" \
  --output table

# Filter resources by a specific tag value
az resource list \
  --resource-group rg-gp-cli-demo \
  --query "[?tags.department=='development'].{Name:name, Type:type}" \
  --output table

# Count the resources in the resource group
az resource list \
  --resource-group rg-gp-cli-demo \
  --query "length([])"


# -------------------------------------------------------------
# 6. Clean Up
# -------------------------------------------------------------

# Delete the resource group and everything inside it
#   --yes     : skips the confirmation prompt
#   --no-wait : returns control immediately (deletes in background)
az group delete --name rg-gp-cli-demo --yes --no-wait

# Check the deletion status (a "not found" error confirms removal)
az group show --name rg-gp-cli-demo --output table
