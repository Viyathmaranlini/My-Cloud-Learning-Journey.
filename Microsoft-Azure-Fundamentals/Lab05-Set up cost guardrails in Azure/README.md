# 💰 Lab 05: Set Up Cost Guardrails in Azure

## 📌 Overview
This hands-on lab focuses on financial governance and cloud cost management in Microsoft Azure. It demonstrates how to monitor, analyze, and control cloud spending by configuring Azure Budgets, Cost Alerts, Resource Tags, and Azure Policy to enforce cost guardrails across Azure resources.

---

## 🎯 Key Learning Objectives
* **Analyze Azure Costs:** Use Azure Cost Management + Billing to visualize and forecast resource spending.
* **Configure Cost Budgets & Alerts:** Set up spending thresholds and email notifications when consumption exceeds pre-defined limits.
* **Enforce Resource Tagging:** Use tags for cost allocation, departmental tracking, and governance.
* **Apply Cost Governance Policies:** Enforce Azure Policies to restrict expensive resource SKUs and unauthorized region deployments.

---

## 🛠️ Services & Tools Used
* **Azure Cost Management + Billing**
* **Azure Budgets & Cost Alerts**
* **Azure Resource Tags**
* **Azure Policy (Cost Control Enforcement)**

---

## 🚀 Key Steps & Configuration

### 1. Cost Analysis & Budget Creation
* Navigated to **Cost Management + Billing** in the Azure Portal.
* Created an **Azure Budget** for the Subscription/Resource Group with a defined monthly spending threshold.
* Configured **Cost Alert Rules** to send notifications at specific spending percentages (e.g., 50%, 80%, and 100% of the budget).

### 2. Implementing Resource Tagging for Cost Allocation
* Applied mandatory tags (`Environment`, `Department`, `CostCenter`) to resources.
* Filtered cost analysis views using resource tags to track departmental cloud spending.

### 3. Enforcing Cost Guardrails with Azure Policy
* Assigned Azure Policies to block the creation of high-cost Virtual Machine SKUs.
* Restricted resource deployment to approved, cost-effective Azure regions.

---

## 💡 Key Takeaways
> Establishing cost guardrails is essential for cloud governance and FinOps best practices. Azure Budgets and Policies ensure proactive cost control, preventing unexpected cloud charges while maintaining operational oversight.
