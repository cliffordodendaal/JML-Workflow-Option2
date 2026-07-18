# Runbook Documentation – JML Workflow Option 2

## Purpose
This folder contains PowerShell runbooks that automate the Joiner–Mover–Leaver (JML) lifecycle.  
They are orchestrated to enforce governance, compliance, and cost transparency across hybrid identity systems.

---

## Runbook Files

| File | Function | Notes |
|------|----------|-------|
| **Orchestrator.ps1** | Master controller that calls Joiner, Mover, and Leaver scripts based on Jira webhook input. | Ensures sequencing and error handling. |
| **Joiner.ps1** | Creates new user accounts, enables Exchange mailbox, assigns licenses, and adds to groups. | Requires validated HR data and Jira approval. |
| **Mover.ps1** | Updates user attributes, modifies group memberships, and adjusts licenses for role changes. | Enforces least privilege and role‑based access. |
| **Leaver.ps1** | Disables AD account, revokes licenses, removes group memberships, and triggers SCIM deprovisioning. | Ensures prompt termination of access. |

---

## Governance Controls
- **Approval Gate:** All runbooks require a Jira webhook trigger tied to manager approval.  
- **Audit Logging:** Each script outputs structured logs to Log Analytics for Sentinel ingestion.  
- **Separation of Duties:** HR initiates events, IT executes automation, Compliance monitors outcomes.  
- **Error Handling:** Orchestrator.ps1 captures failures and raises alerts to Sentinel.

---

## Execution Flow
1. **Webhook Trigger** → Jira approval sends HTTP POST to Orchestrator.ps1.  
2. **Orchestrator.ps1** → Determines workflow type (Joiner, Mover, Leaver).  
3. **Runbook Execution** → Calls the relevant script.  
4. **Hybrid Identity Actions** → AD/Exchange changes, Entra ID sync, Graph API calls.  
5. **SCIM Deprovisioning** → Leaver.ps1 notifies SaaS apps.  
6. **Sentinel Overlay** → Logs and anomalies monitored for compliance.

---

## Evidence Artifacts
- **Runbook Logs:** Execution steps and outcomes.  
- **Jira Tickets:** Approval records.  
- **Sentinel Alerts:** Compliance monitoring.  
- **AD/Exchange Audit Logs:** Account creation, modification, disablement.  
- **Entra ID Audit Logs:** License assignment, group membership changes.

---

## Risks & Mitigations
- **Risk:** Unauthorized execution → **Mitigation:** Runbooks only accept Jira webhook input.  
- **Risk:** Incomplete HR data → **Mitigation:** Mandatory field validation in Jira.  
- **Risk:** Compliance gaps → **Mitigation:** Sentinel continuous monitoring and reporting.  

