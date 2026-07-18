# Governance Narrative – JML Workflow Option 2

## Purpose
This document explains how governance is embedded into the Joiner–Mover–Leaver (JML) workflow.  
It highlights the roles of HR, IT, and Compliance stakeholders, and shows how automation is controlled, monitored, and auditable across hybrid identity systems.

---

## Governance Principles
- **Accountability:** Every identity change is traceable to a business request in Sage HR and an approval in Jira.  
- **Transparency:** Logs and audit trails are maintained across Jira, Runbooks, AD/Exchange, and Entra ID.  
- **Separation of Duties:** HR initiates events, IT executes automation, Compliance monitors outcomes.  
- **Auditability:** Sentinel overlays ensure continuous monitoring and anomaly detection.  
- **Policy Enforcement:** Employment Status and Policy Override fields in Sage HR drive lifecycle triggers and conditional access.

---

## Governance Flow

1. **Sage HR – Source of Truth**  
   - HR records employee lifecycle events (Joiner, Mover, Leaver).  
   - Cost center and business unit fields tie identity changes to financial accountability.  

2. **Jira – Approval & Governance Layer**  
   - HR events flow into Jira Service Management.  
   - Approvals are logged, providing auditable evidence of control execution.  
   - Validation rules enforce mandatory fields (e.g., Cost Center, Manager).  

3. **Azure Automation Runbooks – Controlled Execution**  
   - Runbooks execute only after Jira approval.  
   - Managed Identity ensures secure, credential‑free access to Graph API.  
   - Structured logging provides evidence of every action taken.  

4. **Hybrid Identity – AD & Exchange**  
   - On‑prem Active Directory remains the authoritative source for accounts.  
   - Exchange hybrid ensures mailbox provisioning is controlled and logged.  

5. **Cloud Identity – Entra ID & Graph API**  
   - Synchronization ensures cloud accounts match HR records.  
   - License assignment and group membership changes are auditable via Graph API.  

6. **Sentinel – Compliance Overlay**  
   - Playbooks detect anomalies (e.g., unapproved accounts, rogue mailboxes).  
   - Alerts feed into compliance dashboards for SOX, NIST, COBIT, ISO, PCI DSS alignment.  

---

## Governance Roles

| Role | Responsibility |
|------|----------------|
| **HR (Sage HR)** | Initiates lifecycle events, maintains source data |
| **IT Operations (Jira + Runbooks)** | Executes approved automation, maintains IAM systems |
| **Compliance (Sentinel)** | Monitors, audits, and reports anomalies |
| **Finance (Cost Center/TBM)** | Ensures costs are allocated to correct business units |

---

## Evidence Artifacts
- **Jira Tickets:** Approval records for each JML event.  
- **Runbook Logs:** Structured output showing execution steps.  
- **AD/Exchange Audit Logs:** Account creation, modification, and disablement.  
- **Entra ID Audit Logs:** License assignment, group membership changes.  
- **Sentinel Alerts:** Compliance monitoring and anomaly detection.  

---

## Risks & Mitigations
- **Risk:** Unauthorized changes bypassing Jira → **Mitigation:** Runbooks require Jira webhook trigger.  
- **Risk:** Missing HR data → **Mitigation:** Mandatory field validation in Jira.  
- **Risk:** Compliance gaps → **Mitigation:** Sentinel continuous monitoring and reporting.  

