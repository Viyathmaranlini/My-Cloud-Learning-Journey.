# Lab 06 – Implement Network Traffic Management

## ⚖️ Overview
This lab focuses on distributing network traffic in Azure using an **Azure Load Balancer** (Layer 4) and an **Azure Application Gateway** (Layer 7).

An infrastructure of three virtual machines was deployed via an ARM template. A public Load Balancer was configured to distribute traffic across two VMs, and an Application Gateway was set up with **path-based routing** to send image and video requests to different backend servers.

## 📋 Lab Scenario
The organization has a public website and needs to load balance incoming public requests across multiple virtual machines. It also needs to serve images and videos from different virtual machines. This is achieved by implementing an Azure Load Balancer and an Azure Application Gateway, all within the same region.

## 🎯 Objectives
- Provision infrastructure (VNet, NSG, and 3 VMs) using an ARM template
- Configure a public Azure Load Balancer (Layer 4)
- Configure an Azure Application Gateway with path-based routing (Layer 7)

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Load Balancer (Standard, Public)
- Azure Application Gateway (Standard V2)
- Azure Virtual Machines & Virtual Networks
- Health Probes & Backend Pools
- Path-based Routing (Layer 7)
- ARM Templates

> ⏱️ **Estimated time:** 50 minutes
> 🌍 **Region used:** East US

---

## 1. Provision Infrastructure with a Template
An ARM template was used to deploy the base infrastructure: one virtual network with three subnets, one network security group, and three virtual machines (one VM per subnet).

### Deployment Settings
| Setting | Value |
|---------|-------|
| Resource group | az104-rg6 |
| VM size | Standard_D2s_v5 *(or next available)* |
| Deployed resources | 1 VNet (3 subnets), 1 NSG, 3 VMs |

> 💡 If deployment fails due to VM size/capacity, retry with `Standard_D2s_v6` or `Standard_D2s_v7` in the same resource group.

✅ **Validation:** The VNet, NSG, and three VMs (`az104-06-vm0`, `vm1`, `vm2`) were deployed.

---

## 2. Configure an Azure Load Balancer
A **Standard public Load Balancer** was placed in front of two VMs. Load Balancers provide **Layer 4 (TCP/UDP)** connectivity, using a front-end IP, a backend pool, and rules that define traffic distribution.

### Load Balancer Configuration
| Component | Setting | Value |
|-----------|---------|-------|
| Load Balancer | Name | az104-lb |
| | SKU / Type | Standard / Public |
| Frontend IP | Name | az104-fe |
| Public IP | Name / Assignment | az104-lbpip / Static |
| Backend pool | Name | az104-be |
| | VMs | az104-06-vm0, az104-06-vm1 |

### Load Balancing Rule
| Setting | Value |
|---------|-------|
| Name | az104-lbrule |
| Protocol / Port | TCP / 80 |
| Backend port | 80 |
| Health probe | az104-hp (TCP, port 80, interval 5) |

**Test:** Browsing to the Load Balancer's public IP displayed **"Hello World from az104-06-vm0"** or **"...vm1"**. Refreshing rotated between the two VMs, confirming traffic distribution.

✅ **Validation:** The Load Balancer distributes traffic across both backend VMs.

---

## 3. Configure an Azure Application Gateway
An **Application Gateway (Standard V2)** was deployed for **Layer 7** load balancing. It provides web traffic routing, WAF support, and SSL termination — here configured with **path-based routing** to send image and video requests to different VMs.

### Dedicated Subnet
The Application Gateway requires its own subnet of **/27 or larger**.

| Setting | Value |
|---------|-------|
| Subnet name | subnet-appgw |
| Address range | 10.60.3.224/27 |

### Application Gateway Configuration
| Component | Setting | Value |
|-----------|---------|-------|
| Gateway | Name / Tier | az104-appgw / Standard V2 |
| | Instance count | 2 |
| Frontend | Public IP | az104-gwpip (Zone-redundant) |

### Backend Pools
| Pool name | Target | Purpose |
|-----------|--------|---------|
| az104-appgwbe | vm1 + vm2 | Default |
| az104-imagebe | vm1 | Images |
| az104-videobe | vm2 | Videos |

### Path-Based Routing Rule (`az104-gwrule`)
| Path | Target | Backend pool |
|------|--------|--------------|
| `/image/*` | images | az104-imagebe |
| `/video/*` | videos | az104-videobe |

**Test:** After confirming both backend servers were **Healthy**, browsing to `http://<frontend-ip>/image/` routed to the image server (vm1), and `http://<frontend-ip>/video/` routed to the video server (vm2).

✅ **Validation:** Path-based routing directs `/image/` and `/video/` requests to the correct backend VMs.

---

## ✅ Validation Results
- [x] Infrastructure (VNet, NSG, 3 VMs) deployed via ARM template
- [x] Standard public Load Balancer `az104-lb` created
- [x] Frontend IP, backend pool, and health probe configured
- [x] Load balancing rule distributes traffic across two VMs
- [x] Traffic rotation between VMs verified in the browser
- [x] Dedicated /27 subnet created for the Application Gateway
- [x] Application Gateway `az104-appgw` deployed (Standard V2)
- [x] Three backend pools configured (default, images, videos)
- [x] Path-based routing rules created for `/image/` and `/video/`
- [x] Backend health confirmed and routing verified in the browser

## 💡 Key Takeaways
- **Azure Load Balancer** distributes traffic at the **transport layer (Layer 4 – TCP/UDP)** across multiple VMs.
- **Public** Load Balancers balance internet traffic to VMs; **internal** ones use private IPs at the frontend only.
- The **Basic** SKU suits small-scale apps; the **Standard** SKU offers high performance, low latency, and a static IP.
- **Azure Application Gateway** is a **web traffic (Layer 7)** load balancer for managing traffic to web applications.
- The **Standard** tier provides L7 load balancing; the **WAF** tier adds a firewall to inspect for malicious traffic.
- Application Gateway can route based on HTTP attributes such as **URI path** or **host headers** (path-based routing).
