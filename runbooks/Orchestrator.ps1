<#
.SYNOPSIS
    Orchestrator.ps1 – Master controller for JML workflows.

.DESCRIPTION
    This runbook receives a JSON payload from Sage HR via Jira webhook.
    It validates approval, determines workflow type (Joiner, Mover, Leaver),
    and invokes the corresponding runbook script. All actions are logged for Sentinel monitoring.

.PARAMETER Payload
    JSON payload containing employee attributes and workflow metadata.

.NOTES
    Author: cliffordodendaal
    Compliance: SOX 404, NIST AC-2, ISO 27001 A.9.2
    Audit: Logs pushed to Log Analytics for Sentinel ingestion
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Payload
)

# Convert incoming JSON payload
$event = $Payload | ConvertFrom-Json

Write-Output "Received JML event: $($event.eventType) for $($event.employee.firstName) $($event.employee.lastName)"

try {
    # --- Governance Gate ---
    if ($event.workflow.approvalStatus -ne "Approved") {
        throw "Workflow not approved in Jira. Aborting."
    }

    # --- Route to Correct Runbook ---
    switch ($event.eventType) {
        "Joiner" {
            Write-Output "Routing to Joiner.ps1..."
            & "C:\Runbooks\Joiner.ps1" -Payload $Payload
        }
        "Mover" {
            Write-Output "Routing to Mover.ps1..."
            & "C:\Runbooks\Mover.ps1" -Payload $Payload
        }
        "Leaver" {
            Write-Output "Routing to Leaver.ps1..."
            & "C:\Runbooks\Leaver.ps1" -Payload $Payload
        }
        default {
            throw "Unknown eventType: $($event.eventType)"
        }
    }

    # --- Audit Logging ---
    $logEntry = @{
        Workflow = $event.eventType
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $event.employee.email
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Success"
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Orchestrator_$($event.employee.employeeId).json"

    Write-Output "Orchestration completed successfully."

} catch {
    Write-Error "Orchestration failed: $_"

    # --- Audit Failure Logging ---
    $logEntry = @{
        Workflow = $event.eventType
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $event.employee.email
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Failed"
        Error = $_.Exception.Message
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Orchestrator_$($event.employee.employeeId)_Error.json"

    throw
}

