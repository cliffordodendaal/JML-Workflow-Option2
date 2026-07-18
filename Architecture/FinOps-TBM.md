# FinOps & TBM – JML Workflow Option 2

## Purpose
This document outlines how the Joiner–Mover–Leaver (JML) workflow integrates with **FinOps** and **Technology Business Management (TBM)** principles.  
The goal is to provide cost transparency, enable showback/chargeback, and align identity lifecycle automation with financial accountability.

---

## Business Context
- **Problem Statement:** Identity lifecycle automation consumes cloud and hybrid resources (licenses, compute, storage). Without visibility, costs are opaque and uncontrolled.  
- **Solution:** Map Sage HR cost center attributes into IAM workflows, enabling FinOps/TBM reporting.  
- **Scope:** Track costs of licenses, groups, and automation execution across Joiner, Mover, and Leaver events.

---

## FinOps Principles Applied
- **Cost Visibility:** Each JML event tagged with `CostCenter` from Sage HR.  
- **Showback/Chargeback:** Departments see the cost of licenses and resources consumed.  
- **Optimization:** Identify unused licenses after Leaver events and reclaim them.  
- **Forecasting:** Use HR pipeline (future hires) to forecast license demand.  
- **Accountability:** Tie IAM automation costs back to business units.

---

## TBM Alignment
- **IT Tower:** Identity & Access Management (IAM) classified under Security/Infrastructure tower.  
- **Cost Pools:**  
  - **Runbook Execution:** Azure Automation consumption.  
  - **Licenses:** Microsoft 365, Teams, Exchange Online.  
  - **Groups/Apps:** Entra ID group memberships, app access.  
- **Business Units:** Derived from Sage HR `CostCenter` and `BusinessUnit` fields.  
- **Value Mapping:** IAM automation reduces onboarding delays and offboarding risks, improving productivity and compliance.

---

## Workflow Cost Mapping

| Workflow Step | Resource Consumed | Cost Tracking | FinOps/TBM Mapping |
|---------------|------------------|---------------|---------------------|
| **Joiner** | License assignment, Runbook execution | Tag with `CostCenter` | Showback to department |
| **Mover** | Group changes, license reallocation | Track delta cost | Chargeback adjustments |
| **Leaver** | License removal, Runbook execution | Savings captured | Optimization reporting |
| **Sentinel Monitoring** | Log analytics ingestion | Azure Monitor cost | Security tower allocation |

---

## Deliverables
- **Cost Transparency Reports** (per department, per workflow step).  
- **Chargeback Statements** (license usage billed to cost centers).  
- **Optimization Dashboards** (unused licenses reclaimed, automation efficiency).  
- **Forecast Models** (HR pipeline → license demand).  

---

## Risks & Mitigations
- **Risk:** Cost center data missing in HR → **Mitigation:** Mandatory field validation in Jira.  
- **Risk:** License sprawl → **Mitigation:** Automated reclamation in Leaver workflow.  
- **Risk:** FinOps/TBM misalignment → **Mitigation:** Regular review with Finance and IT governance.  

