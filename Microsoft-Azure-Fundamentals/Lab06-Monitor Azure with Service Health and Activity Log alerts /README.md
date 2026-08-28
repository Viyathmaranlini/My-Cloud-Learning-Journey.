# Lab 06 – Monitor Azure with Service Health and Activity Log Alerts

## 🚨 Overview

This lab demonstrates how to monitor Azure resources and receive notifications about important platform and resource events using **Azure Monitor Alerts**.

An Action Group was created for email notifications, followed by a **Service Health alert** and an **Activity Log alert**. The alert configurations were then reviewed and validated to demonstrate proactive monitoring and operational awareness.

## 🎯 Objectives

- Create an Azure Monitor Action Group
- Configure email notifications for alerts
- Test the notification channel
- Review Azure Service Health information
- Create a Service Health alert
- Create an Activity Log alert
- Configure alert severity and conditions
- Verify alert rules and their associated actions

## 🛠️ Azure Services & Technologies

- **Microsoft Azure**
- **Azure Monitor**
- **Azure Service Health**
- **Azure Activity Log**
- **Azure Alerts**
- **Action Groups**
- **Azure Resource Groups**

---

## 1. Prepare the Monitoring Environment

Created a Resource Group to organize the monitoring resources used in this lab.

**Resource Group:**

`rg-gp-monitoring-alerts`

---

## 2. Create an Action Group

Created an Azure Monitor **Action Group** to define the notification channel used by the alert rules.

| Setting | Configuration |
|---|---|
| Action Group | `ag-gp-ops-email` |
| Display Name | `OpsEmail` |
| Notification | Email |
| Region | Global |

The Action Group was tested to verify that email notifications could be delivered successfully.

---

## 3. Configure a Service Health Alert

Azure **Service Health** was reviewed to understand the status of Azure services and platform events.

The following Service Health areas were reviewed:

- Service Issues
- Planned Maintenance
- Health Advisories
- Health History

A Service Health alert was then created to monitor:

- **Service Issues**
- **Planned Maintenance**

### Alert Configuration

| Setting | Value |
|---|---|
| Alert Rule | `ar-gp-service-health` |
| Event Types | Service Issue, Planned Maintenance |
| Action Group | `ag-gp-ops-email` |
| Region | Global |
| Status | Enabled |

This alert provides automatic notification when relevant Azure platform events occur.

---

## 4. Configure an Activity Log Alert

An **Activity Log Alert** was created to monitor resource management events.

The alert was configured to detect:

**Delete resource group**

### Alert Configuration

| Setting | Value |
|---|---|
| Alert Rule | `ar-gp-activity-delete` |
| Signal | Delete Resource Group |
| Severity | Sev 2 - Warning |
| Resource Group | `rg-gp-monitoring-alerts` |
| Action Group | `ag-gp-ops-email` |
| Status | Enabled |

When the configured Activity Log event occurs, the Action Group sends an email notification.

---

## 5. Verify Alert Configuration

Both alert rules were reviewed through **Azure Monitor → Alerts → Alert Rules**.

The following configurations were verified:

- Service Health alert is enabled
- Activity Log alert is enabled
- Correct conditions are configured
- Correct severity is configured for the Activity Log alert
- The `ag-gp-ops-email` Action Group is attached to both alerts

The Activity Log was also reviewed to understand how Azure records management operations for auditing and monitoring purposes.

---

## ✅ Validation Results

- [x] Monitoring Resource Group created
- [x] Action Group created successfully
- [x] Email notification configured
- [x] Action Group test completed successfully
- [x] Service Health information reviewed
- [x] Service Health alert created and enabled
- [x] Activity Log alert created and enabled
- [x] Alert conditions verified
- [x] Action Group successfully attached to both alert rules
- [x] Alert configuration reviewed

## 💡 Key Takeaways

- **Azure Monitor** provides centralized monitoring and alerting capabilities for Azure resources.
- **Action Groups** define how and where alert notifications are delivered.
- **Service Health** helps identify Azure platform issues and planned maintenance that may affect resources.
- **Activity Log Alerts** can monitor important management operations performed on Azure resources.
- Alert severity helps prioritize operational events.
- Combining Service Health and Activity Log alerts improves visibility into both Azure platform events and resource management activities.
- Regularly reviewing alert configurations helps ensure the correct events are monitored and the appropriate teams are notified.

---

