# JML-Workflow-Option2

## Scenario
This lab demonstrates a **Joiner–Mover–Leaver (JML) workflow** using **Sage HR** as the source system, **Jira Service Management** for approvals, and **Azure Automation Runbooks** for orchestration.  
Accounts are created in **on‑prem Active Directory**, mailboxes enabled in **Exchange hybrid**, synced into **Entra ID**, and cloud tasks completed via **Graph API**.  
**Azure Sentinel** overlays provide compliance monitoring and anomaly detection.

## Objectives
- Automate the JML lifecycle with governance enforced through Jira approvals.
- Use Azure Automation Runbooks to orchestrate PowerShell and Graph API tasks.
- Maintain hybrid source of authority (on‑prem AD + Exchange).
- Provide compliance overlays (SOX, NIST, COBIT, ISO 27001, PCI DSS).
- Monitor anomalies with Sentinel playbooks.

## Prerequisites
- Sage HR system configured as the source of employee lifecycle events (Joiner, Mover, Leaver)
- Jira Service Management project integrated with Sage HR for HR → IT approvals
- Azure subscription with Automation Account and Hybrid Worker
- Entra ID tenant with Graph API permissions
- Exchange hybrid setup with PowerShell remoting enabled
- On‑prem Active Directory as source of authority
- Sentinel workspace for monitoring and anomaly detection

## Architecture
                    Sage HR  
                        │  
                        ▼  
    Jira Approval (HTTP POST with JSON payload)  
                        │  
                        ▼  
            Azure Automation Runbook  
                        │  
                        ├── **JOINER** → Create AD User → Enable Mailbox → Sync to Entra → Assign License → Add to Groups → Set Manager  
                        │  
                        ├── **MOVER** → Update Attributes → Remove Old Groups → Add New Groups → Update App Access  
                        │  
                        └── **LEAVER** → Disable AD Account → Revoke Sessions → Remove Licenses → Remove Groups → Retain per policy  
                        │  
                        ▼  
      Microsoft Graph API → Microsoft Entra ID  
                        │  
                        ▼  
         Audit Log + Sentinel Monitoring

## Runbooks
Located in `/runbooks`:
- `Joiner.ps1` – Creates AD user, enables mailbox, assigns licenses/groups.
- `Mover.ps1` – Updates attributes, reassigns groups.
- `Leaver.ps1` – Disables account, revokes sessions, removes licenses.
- `Orchestrator.ps1` – Routes Jira payloads to the correct runbook.

## Payloads
Located in `/payloads`:
- `joiner.json` – Example HR → Jira payload
- `mover.json`
- `leaver.json`

## Sentinel Monitoring
Playbooks in `/sentinel-playbooks` detect anomalies such as:
- Accounts created without Jira approval
- Mailboxes enabled outside automation
- Licenses assigned without workflow

## Compliance Mapping
See `/compliance/compliancemapping.csv` for overlays across SOX, NIST, COBIT, ISO 27001, PCI DSS.

## FinOps/TBM
See `/finopsTBM` for cost transparency notes, showback/chargeback examples, and optimization strategies.

## Diagrams
Visuals in `/diagrams`:
- Workflow diagram
- Sentinel overlay
- Hybrid vs cloud comparison

## Portfolio Demo
For the polished business case and executive‑style presentation, see [My Portfolio Page](https://cliffordodendaal.com/JML-Demo).

