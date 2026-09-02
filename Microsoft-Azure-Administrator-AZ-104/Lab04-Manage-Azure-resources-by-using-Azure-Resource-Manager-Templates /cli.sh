#!/bin/bash
# =============================================================
# Lab 04 - Deploy ARM Templates with the Azure CLI
# AZ-104 - Manage Azure resources with ARM Templates
#
# Run in Azure Cloud Shell (Bash mode).
# Replace <your-subscription-id> with your subscription.
# =============================================================


# -------------------------------------------------------------
# Confirm the correct subscription context
# -------------------------------------------------------------
az account show
az account set --subscription <your-subscription-id>

# List uploaded template files in Cloud Shell storage
ls


# -------------------------------------------------------------
# Deploy the ARM template to the resource group
# (edit the disk name to az104-disk4 in the template first)
# -------------------------------------------------------------
az deployment group create \
  --resource-group az104-rg3 \
  --template-file template.json \
  --parameters parameters.json

# Confirm the disk was created
az disk list --resource-group az104-rg3 --output table
