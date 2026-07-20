# Lab 03 - Organize and Protect Resources with Tags and Locks

## Objective
Implement cloud governance and resource protection mechanisms by logically organizing Azure resources using structured Tags and preventing accidental modification or deletion using Resource Locks.

## Steps Performed
1. Navigated to the Azure Resource Group or specific resource blade within the portal.
2. Configured structured metadata Tags (Key-Value pairs) on active cloud components to enable organized tracking and cost allocation.
3. Implemented a `CanNotDelete` Resource Lock on a critical service environment to safeguard it from accidental deletion.
4. Attempted a simulation to delete the protected resource to verify that the restriction was enforced correctly by Azure.
5. Configured and reviewed explicit resource configurations to understand how lock inheritance flows down through subscriptions and environments.

## Result
Azure resources logically cataloged via custom metadata tags and successfully locked against unauthorized or unintended termination processes.

## Skills Learned
* Cloud Governance & Management Strategies
* Resource Security & Safeguarding Techniques
* Metadata Tagging Implementation
* Inheritance Architecture Principles
