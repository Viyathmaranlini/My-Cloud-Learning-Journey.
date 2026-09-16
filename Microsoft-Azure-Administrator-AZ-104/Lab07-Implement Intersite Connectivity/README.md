# Lab 07 – Implement Intersite Connectivity

## 🔗 Overview
This lab explores communication between virtual networks in Azure. It covers implementing **virtual network peering**, testing connectivity with **Network Watcher** and **Azure PowerShell**, and creating a **custom route (user-defined route)**.

Two VMs were deployed in separate virtual networks, connectivity was tested (and confirmed blocked by default), VNet peering was configured to enable communication, connectivity was re-tested to confirm success, and a custom route was created to direct traffic through a network virtual appliance.

## 📋 Lab Scenario
The organization segments core IT apps and services (such as DNS and security) from other parts of the business, like the manufacturing department. In some scenarios these segmented areas need to communicate. This lab configures connectivity between them — a common pattern for separating production from development, or one subsidiary from another.

## 🎯 Objectives
- Create two VMs in two separate virtual networks
- Test connectivity between VMs with Network Watcher (before peering)
- Configure virtual network peering between the two VNets
- Re-test connectivity using Azure PowerShell (after peering)
- Create a custom route (user-defined route)

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Virtual Machines & Virtual Networks
- Virtual Network Peering
- Azure Network Watcher (Connection Troubleshoot)
- Route Tables & User-Defined Routes (UDR)
- Azure PowerShell (Run Command)

---

## 1. Create the Core Services VM and VNet
Created the first VM along with its virtual network in a single step.

### VM & Network Configuration
| Setting | Value |
|---------|-------|
| VM name | CoreServicesVM |
| Resource group | az104-rg5 |
| Image | Windows Server 2025 Datacenter |
| Size | Standard_D2s_v5 |
| Virtual network | CoreServicesVnet (10.0.0.0/16) |
| Subnet | Core (10.0.0.0/24) |
| Public inbound ports | None |

---

## 2. Create the Manufacturing VM and VNet
Created a second VM in a **separate** virtual network with a non-overlapping address space.

### VM & Network Configuration
| Setting | Value |
|---------|-------|
| VM name | ManufacturingVM |
| Resource group | az104-rg5 |
| Image | Windows Server 2025 Datacenter |
| Size | Standard_D2s_v5 |
| Virtual network | ManufacturingVnet (172.16.0.0/16) |
| Subnet | Manufacturing (172.16.0.0/24) |
| Public inbound ports | None |

---

## 3. Test Connectivity with Network Watcher (Before Peering)
Used **Network Watcher → Connection troubleshoot** to test connectivity from CoreServicesVM to ManufacturingVM.

| Setting | Value |
|---------|-------|
| Source | CoreServicesVM |
| Destination | ManufacturingVM |
| Protocol / Port | TCP / 3389 |

**Result:** The connectivity test returned **Unreachable** — expected, because the VMs are in different virtual networks that cannot communicate by default.

✅ **Validation:** Connectivity failed before peering, confirming default network isolation.

---

## 4. Configure Virtual Network Peering
Created a **bidirectional peering** between the two VNets to enable communication.

| Peering Link | Direction |
|--------------|-----------|
| CoreServicesVnet-to-ManufacturingVnet | Core → Manufacturing |
| ManufacturingVnet-to-CoreServicesVnet | Manufacturing → Core |

Both links were configured to allow access and forwarded traffic.

✅ **Validation:** Both peering links show a **Connected** status.

---

## 5. Test Connectivity with PowerShell (After Peering)
Re-tested connectivity using the VM **Run command** feature.

**On CoreServicesVM** — enabled the inbound RDP firewall rule:
```powershell
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

**On ManufacturingVM** — tested the connection to CoreServicesVM's private IP:
```powershell
Test-NetConnection <CoreServicesVM-private-IP> -port 3389
```

**Result:** The connection **succeeded** this time, because peering now enables cross-VNet communication.

✅ **Validation:** Connectivity succeeded after peering, confirming the VNets can now communicate.

---

## 6. Create a Custom Route
To control traffic between the perimeter subnet and the internal core services subnet, a **user-defined route (UDR)** was created to route traffic through a future Network Virtual Appliance (NVA).

### New Subnet
| Setting | Value |
|---------|-------|
| Name | perimeter |
| Address range | 10.0.1.0/24 |

### Route Table
| Setting | Value |
|---------|-------|
| Name | rt-CoreServices |
| Enable peering routes | Yes |

### Custom Route
| Setting | Value |
|---------|-------|
| Route name | PerimetertoCore |
| Destination | 10.0.0.0/16 (core services VNet) |
| Next hop type | Virtual appliance |
| Next hop address | 10.0.1.7 (future NVA) |

The route table was then **associated** with the perimeter subnet.

✅ **Validation:** The user-defined route directs traffic from the perimeter subnet toward the NVA and is associated with the correct subnet.

---

## ✅ Validation Results
- [x] CoreServicesVM created in CoreServicesVnet (10.0.0.0/16)
- [x] ManufacturingVM created in ManufacturingVnet (172.16.0.0/16)
- [x] Connectivity confirmed Unreachable before peering
- [x] Bidirectional VNet peering configured
- [x] Both peering links show Connected status
- [x] RDP firewall rule enabled via PowerShell Run command
- [x] Connectivity confirmed successful after peering
- [x] Perimeter subnet and route table `rt-CoreServices` created
- [x] Custom route `PerimetertoCore` created and associated with the subnet

## 💡 Key Takeaways
- By default, resources in **different virtual networks cannot communicate**.
- **Virtual network peering** seamlessly connects two or more VNets, which then appear as one for connectivity purposes.
- Traffic between peered VNets travels over the **Microsoft backbone** infrastructure.
- **System routes** are created automatically for each subnet; **user-defined routes (UDRs)** override or add to them.
- **Azure Network Watcher** provides tools to monitor, diagnose, and view metrics/logs for Azure IaaS resources.
- Custom routes are used to direct traffic through appliances like an NVA for inspection or security.
