# Lab 05 – Implement Virtual Networking

## 🌐 Overview
This lab covers the fundamentals of **virtual networking** in Azure — designing virtual networks and subnets, securing traffic with **Network Security Groups (NSGs)** and **Application Security Groups (ASGs)**, and configuring **public and private DNS zones**.

Two virtual networks were created (one via the portal, one via an ARM template), an NSG was configured with rules to allow ASG traffic and deny internet access, and both public and private Azure DNS zones were set up for name resolution.

## 📋 Lab Scenario
The organization is implementing virtual networks to accommodate existing resources while planning for growth. The **CoreServicesVnet** holds the largest number of resources and needs a large address space. The **ManufacturingVnet** supports manufacturing systems and anticipates many internally connected devices. The networks and subnets are structured to avoid overlapping IP ranges and allow for future growth.

## 🎯 Objectives
- Create a virtual network with subnets using the portal
- Create a virtual network with subnets using an ARM template
- Configure communication between an ASG and an NSG
- Configure public and private Azure DNS zones

## 🛠️ Azure Services & Technologies
- Microsoft Azure
- Azure Virtual Networks (VNet) & Subnets
- Network Security Groups (NSG)
- Application Security Groups (ASG)
- Azure DNS (Public & Private zones)
- ARM Templates

> ⏱️ **Estimated time:** 50 minutes
> 🌍 **Region used:** East US

---

## 1. Create a Virtual Network with Subnets (Portal)
Created the **CoreServicesVnet** with a large address space to accommodate growth, along with two subnets. The default subnet was deleted.

### CoreServicesVnet Configuration
| Setting | Value |
|---------|-------|
| Resource group | az104-rg4 |
| Name | CoreServicesVnet |
| Region | East US |
| Address space | 10.20.0.0/16 |

### Subnets
| Subnet | Address range | Size |
|--------|---------------|------|
| SharedServicesSubnet | 10.20.10.0 | /24 |
| DatabaseSubnet | 10.20.20.0 | /24 |

> ℹ️ Every virtual network must have at least one subnet, and **5 IP addresses are always reserved** per subnet — factor this into planning.

After deployment, the VNet's ARM template was exported (**Automation → Export template**) and the `template.json` and `parameters.json` files were downloaded for reuse in the next task.

---

## 2. Create a Virtual Network with Subnets (Template)
The exported template was edited to create the **ManufacturingVnet**, sized for anticipated growth.

### Edits Made to the Template
| Original | Changed to |
|----------|-----------|
| CoreServicesVnet | ManufacturingVnet |
| 10.20.0.0 | 10.30.0.0 |
| SharedServicesSubnet | SensorSubnet1 |
| 10.20.10.0/24 | 10.30.20.0/24 |
| DatabaseSubnet | SensorSubnet2 |
| 10.20.20.0/24 | 10.30.21.0/24 |

The `parameters.json` file was also updated (CoreServicesVnet → ManufacturingVnet), then deployed via **Deploy a custom template → Build your own template in the editor**.

✅ **Validation:** The ManufacturingVnet and its subnets were created in `az104-rg4`.

---

## 3. Configure ASG and NSG Communication
An **Application Security Group** and a **Network Security Group** were created, with rules to allow ASG traffic inbound and deny internet access outbound.

### Application Security Group
| Setting | Value |
|---------|-------|
| Name | asg-web |
| Resource group | az104-rg4 |

### Network Security Group
| Setting | Value |
|---------|-------|
| Name | myNSGSecure |
| Associated subnet | SharedServicesSubnet (CoreServicesVnet) |

### Inbound Rule – Allow ASG Traffic
| Setting | Value |
|---------|-------|
| Source | Application security group (asg-web) |
| Destination port ranges | 80, 443 |
| Protocol | TCP |
| Action | Allow |
| Priority | 100 |
| Name | AllowASG |

### Outbound Rule – Deny Internet Access
| Setting | Value |
|---------|-------|
| Source | Any |
| Destination | Service tag → Internet |
| Protocol | Any |
| Action | Deny |
| Priority | 4096 |
| Name | DenyInternetOutbound |

✅ **Validation:** The NSG allows ASG traffic on ports 80/443 and denies outbound internet access.

---

## 4. Configure Public and Private DNS Zones
Azure DNS provides name resolution for both public domains and private virtual networks.

### Public DNS Zone
Configured to resolve host names in a public domain.

| Setting | Value |
|---------|-------|
| Resource group | az104-rg4 |
| Zone name | *(a unique public domain name)* |
| Record | www → A record → 10.1.1.4 |

Name resolution was verified using `nslookup` against one of the four assigned Azure DNS name servers:
```bash
nslookup www.<your-domain>.com <assigned-name-server>
```

### Private DNS Zone
Provides name resolution within linked virtual networks only — not accessible from the internet.

| Setting | Value |
|---------|-------|
| Resource group | az104-rg4 |
| Zone name | private.contoso.com *(adjusted if renamed)* |
| Virtual network link | manufacturing-link → ManufacturingVnet |
| Record | sensorvm → A record → 10.1.1.4 |

✅ **Validation:** The public zone resolves the `www` record, and the private zone is linked to the ManufacturingVnet with a record set.

---

## ✅ Validation Results
- [x] CoreServicesVnet created with two subnets via the portal
- [x] VNet template exported for reuse
- [x] ManufacturingVnet created via an edited ARM template
- [x] Application security group `asg-web` created
- [x] Network security group `myNSGSecure` created and associated to a subnet
- [x] Inbound rule allows ASG traffic on ports 80/443
- [x] Outbound rule denies internet access
- [x] Public DNS zone created and verified with nslookup
- [x] Private DNS zone created and linked to the ManufacturingVnet

## 💡 Key Takeaways
- A **virtual network** is a representation of your own network in the cloud.
- Avoid **overlapping IP address ranges** when designing networks to reduce issues and simplify troubleshooting.
- A **subnet** is a range of IP addresses within a VNet; networks can be divided into multiple subnets for organization and security.
- A **Network Security Group (NSG)** contains rules that allow or deny traffic, with customizable default inbound and outbound rules.
- An **Application Security Group (ASG)** protects groups of servers with a common function (e.g. web or database servers).
- **Azure DNS** hosts DNS domains for name resolution — public zones resolve public domains, while private zones resolve names within linked virtual networks.
