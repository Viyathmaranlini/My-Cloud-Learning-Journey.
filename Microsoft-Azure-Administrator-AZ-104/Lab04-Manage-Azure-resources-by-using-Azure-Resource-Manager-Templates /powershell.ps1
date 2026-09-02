# =============================================================
# Lab 04 - Deploy ARM Templates with Azure PowerShell
# AZ-104 - Manage Azure resources with ARM Templates
#
# Run in Azure Cloud Shell (PowerShell mode).
# Replace <your-subscription-id> with your subscription.
# =============================================================


# -------------------------------------------------------------
# Confirm the correct subscription context
# -------------------------------------------------------------
Get-AzContext
Set-AzContext -Subscription <your-subscription-id>


# -------------------------------------------------------------
# Deploy the ARM template to the resource group
# (edit the disk name to az104-disk3 in the template first)
# -------------------------------------------------------------
New-AzResourceGroupDeployment `
  -ResourceGroupName az104-rg3 `
  -TemplateFile template.json `
  -TemplateParameterFile parameters.json

# Confirm the disk was created
Get-AzDisk | ft Name,ResourceGroupName,Location,DiskSizeGb,ProvisioningState
