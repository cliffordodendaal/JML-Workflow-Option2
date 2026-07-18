# HR Business Requirements Document (BRD) – Sage HR Integration

## Purpose
This BRD defines how employee data stored in **Sage HR** will be mapped into the Joiner–Mover–Leaver (JML) workflow.  
The goal is to ensure consistent identity lifecycle automation across **Active Directory**, **Exchange Hybrid**, and **Entra ID**, with governance enforced via **Jira approvals**.

---

## Business Context
- **Problem Statement:** Manual identity lifecycle management causes delays in onboarding and risks in offboarding.  
- **Solution:** Integrate Sage HR as the source of truth for employee data, feeding JML automation workflows.  
- **Scope:** Employee lifecycle events (Joiner, Mover, Leaver) must be captured from Sage HR fields and mapped into IAM attributes.

---

## Functional Requirements
- Capture employee identity attributes from Sage HR.  
- Normalize HR data into IAM‑ready fields.  
- Map HR attributes to AD/Exchange/Entra equivalents.  
- Trigger JML workflows based on Employment Status and lifecycle events.  
- Maintain audit trail via Jira approvals and Sentinel monitoring.

---

## Sage HR Field Mapping

| Sage HR Field | Purpose in HR | Mapping in JML Workflow |
|---------------|---------------|--------------------------|
| **Unique Id** | Permanent identifier for employee | Map to `employeeID` in AD / `employeeId` in Entra |
| **Personnel Number** | Payroll/HR reference number | Optional secondary ID in AD attributes |
| **First Name / Surname / Middle Name / Preferred Name** | Employee identity | Map to `givenName`, `sn`, `displayName` |
| **Email** | Work email address | Map to `mail` in AD / `userPrincipalName` in Entra |
| **HR Department / Team / Division** | Org unit assignment | Map to AD groups / Entra dynamic groups |
| **Job Title / Function / Grade** | Role and level | Map to `title` in AD / `jobTitle` in Entra |
| **Manager (Lookup)** | Reporting line | Map to `manager` attribute in AD/Entra |
| **Employment Status** | Active, On Leave, Terminated | Drives JML trigger (Joiner, Mover, Leaver) |
| **Birth Date / Citizenship / ID** | HR compliance fields | Not mapped to IAM; sensitive data excluded |
| **Location** | Office/site | Map to `physicalDeliveryOfficeName` in AD |
| **Cost Center / Business Unit** | Finance tracking | Map to `extensionAttribute` for FinOps/TBM |
| **Policy Override** | Temporary access rules | Map to conditional group membership |

---

## Non‑Functional Requirements
- **Security:** Sensitive HR fields (Birth Date, Citizenship, ID) excluded from IAM mapping.  
- **Performance:** JML workflows must execute within 90 seconds end‑to‑end.  
- **Compliance:** Align with SOX, NIST, COBIT, ISO 27001, PCI DSS.  
- **Scalability:** Support growth to 1000+ employees without redesign.  

---

## Deliverables
- **HR → IAM Mapping Table** (above)  
- **Workflow Diagrams** (see `/diagrams`)  
- **Compliance Matrix** (see `/compliance/Compliance-Matrix.md`)  
- **Runbook Payloads** (see `/payloads`)  
- **Audit Evidence** (Jira tickets, Runbook logs, Sentinel alerts)

---

## Risks & Mitigations
- **Risk:** HR data mismatch → **Mitigation:** Validation rules in Jira before Runbook trigger.  
- **Risk:** API downtime → **Mitigation:** Retry logic in Runbooks.  
- **Risk:** Compliance gaps → **Mitigation:** Sentinel monitoring + audit logs.  

