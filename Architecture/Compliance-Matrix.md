# Compliance Matrix – JML Workflow Option 2

## Purpose
This document maps the Joiner–Mover–Leaver (JML) workflow steps to major compliance frameworks (SOX, NIST 800‑53, COBIT, ISO 27001, PCI DSS).  
It provides a human‑readable overview of how governance and controls are enforced across the automation system.  
For structured data, see [compliancemapping.csv](compliancemapping.csv).

---

## Workflow Step vs Compliance Control

| Workflow Step | SOX | NIST 800‑53 | COBIT | ISO 27001 | PCI DSS |
|---------------|-----|-------------|-------|-----------|---------|
| Sage HR event creation | SOX 404 – HR data integrity | AU‑2 – audit events | DSS01 – manage operations | A.12.4 – logging and monitoring | Req. 10 – track and monitor access |
| Jira approval workflow | SOX 302 – management responsibility | AC‑3 – access enforcement | APO01 – governance framework | A.9.1 – access control policy | Req. 7 – restrict access by need‑to‑know |
| Azure Runbook execution | SOX 404 – automated control execution | CM‑3 – configuration change control | BAI06 – manage changes | A.12.1 – change management | Req. 6 – develop secure systems |
| AD account creation | SOX 404 – user provisioning control | AC‑2 – account management | DSS05 – manage security services | A.9.2 – user provisioning | Req. 8 – identify and authenticate users |
| Exchange mailbox enablement | SOX 404 – email access control | AC‑17 – remote access | DSS05 – manage security services | A.13.2 – email security | Req. 7 – restrict access |
| Entra ID sync + license assignment | SOX 404 – cloud access control | IA‑2 – identification and authentication | DSS06 – manage business services | A.9.4 – access provisioning | Req. 8 – unique IDs |
| Mover workflow (attribute/group changes) | SOX 404 – role change control | AC‑2(3) – account modification | BAI08 – manage knowledge | A.9.2 – user role management | Req. 7 – least privilege |
| Leaver workflow (disable/revoke) | SOX 404 – termination control | AC‑2(4) – account deactivation | DSS05 – manage security services | A.9.2 – termination of access | Req. 8 – revoke access promptly |
| Sentinel monitoring + anomaly detection | SOX 404 – monitoring of controls | AU‑6 – audit review, analysis | MEA01 – monitor, evaluate, assess | A.12.4 – event logging | Req. 10 – log and monitor all access |

---

## Notes
- **Governance:** Jira approvals provide auditable evidence of control execution.  
- **Hybrid Identity:** On‑prem AD + Exchange remain authoritative, synced into Entra ID.  
- **Compliance Overlay:** Sentinel playbooks enforce continuous monitoring and anomaly detection.  
- **FinOps/TBM:** Cost center attributes from Sage HR tie compliance actions to financial accountability.  

