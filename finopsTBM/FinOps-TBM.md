# FinOps / TBM Narrative – JML Workflow Option 2

## Purpose
This document explains how the Joiner–Mover–Leaver (JML) workflow aligns with FinOps and Technology Business Management (TBM) principles.  
It highlights cost transparency, accountability, and financial governance across HR, IT, and Compliance functions.

---

## TBM Tower Mapping
Each workflow step is mapped to TBM cost towers to ensure traceability:

| Workflow Step | TBM Tower | Cost Driver | Example Resource |
|---------------|-----------|-------------|------------------|
| Sage HR event creation | Business Applications | SaaS subscription | Sage HR license |
| Jira approval workflow | IT Management | Service desk operations | Jira Service Management |
| Azure Runbook execution | IT Automation | Cloud compute | Azure Automation |
| AD account creation | Infrastructure | Directory services | Domain Controllers |
| Exchange mailbox enablement | Applications | Messaging | Exchange Online |
| Entra ID sync + license assignment | Cloud Services | Identity & access | Microsoft 365 licenses |
| Mover workflow | IT Management | Role change operations | Group membership updates |
| Leaver workflow | Security | Deprovisioning | SCIM API calls |
| Sentinel monitoring | Security | SIEM ingestion | Log Analytics workspace |

---

## FinOps Principles Applied
- **Cost Visibility:** Each JML step is tied to a cost center attribute from Sage HR.  
- **Accountability:** Jira approvals ensure costs are linked to business justification.  
- **Optimization:** Leaver workflows reclaim licenses, reducing waste.  
- **Forecasting:** Mover workflows highlight role‑based cost changes (e.g., E3 → E5 upgrade).  
- **Governance:** Sentinel overlays provide compliance evidence tied to financial accountability.

---

## Example Cost Transparency
| Department | Workflow Step | Resource | Monthly Cost (USD) | Notes |
|------------|---------------|----------|--------------------|-------|
| Finance | Joiner | Microsoft 365 E3 License | 1200 | New hires provisioned |
| Finance | Mover | License Upgrade to E5 | 600 | Role change requiring advanced security |
| Finance | Leaver | License Reclamation | -800 | Licenses reclaimed and reused |
| HR | Joiner | Azure Automation Runbook | 150 | Onboarding scripts execution |
| Compliance | Sentinel Monitoring | Log Analytics Ingestion | 500 | Audit and anomaly detection |

---

## Governance Overlay
- **Jira Approvals:** Provide auditable evidence of financial control execution.  
- **Hybrid Identity:** AD + Exchange remain authoritative, synced into Entra ID.  
- **Sentinel Monitoring:** Ensures compliance and anomaly detection tied to cost centers.  
- **FinOps/TBM Integration:** Cost center attributes link compliance actions to financial accountability.

---

## Risks & Mitigations
- **Risk:** License sprawl from movers → **Mitigation:** Automated license reclamation.  
- **Risk:** Untracked SaaS costs → **Mitigation:** SCIM deprovisioning ensures SaaS cleanup.  
- **Risk:** Compliance gaps → **Mitigation:** Sentinel continuous monitoring with cost attribution.  

