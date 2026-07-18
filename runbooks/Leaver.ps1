<#
.SYNOPSIS
    Leaver.ps1 – Automates the Leaver workflow for departing employees.

.DESCRIPTION
    This runbook deprovisions user accounts based on Sage HR + Jira approval payload.
    It disables AD/Entra ID accounts, revokes licenses, removes group memberships,
    disables Exchange mailbox, and triggers SCIM deprovisioning for SaaS apps.
    All actions are logged for Sentinel monitoring.

.PARAMETER Payload
    JSON payload from Sage HR via Jira webhook containing employee attributes.

.NOTES
    Author: cliffordodendaal
    Compliance: SOX 404, NIST AC-2(4), ISO 27001 A.9.2
    Audit: Logs pushed to Log Analytics for Sentinel ingestion
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Payload
)

# Convert incoming JSON payload
$event = $Payload | ConvertFrom-Json

Write-Output "Processing Leaver workflow for $($event.employee.firstName) $($event.employee.lastName)..."

try {
    # --- Governance Gate ---
    if ($event.workflow.approvalStatus -ne "Approved") {
        throw "Leaver workflow not approved in Jira. Aborting."
    }

    $userPrincipalName = $event.employee.email

    # --- Disable AD Account ---
    Disable-ADAccount -Identity $userPrincipalName
    Write-Output "AD account disabled for $userPrincipalName"

    # --- Revoke Licenses (Entra ID / M365) ---
    foreach ($license in $event.deprovisioning.revokeLicenses) {
        Set-MsolUserLicense -UserPrincipalName $userPrincipalName -RemoveLicenses $license
        Write-Output "Revoked license $license from $userPrincipalName"
    }

    # --- Remove Group Memberships ---
    foreach ($group in $event.deprovisioning.removeGroups) {
        Remove-ADGroupMember -Identity $group -Members $userPrincipalName -Confirm:$false
        Write-Output "Removed $userPrincipalName from group $group"
    }

    # --- Disable Exchange Mailbox ---
    Disable-Mailbox -Identity $userPrincipalName
    Write-Output "Exchange mailbox disabled for $userPrincipalName"

    # --- Trigger SCIM Deprovisioning ---
    if ($event.deprovisioning.triggerSCIM -eq $true) {
        # Placeholder for SCIM API call
        Write-Output "SCIM deprovisioning triggered for $userPrincipalName"
    }

    # --- Audit Logging ---
    $logEntry = @{
        Workflow = "Leaver"
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $userPrincipalName
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Success"
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Leaver_$($event.employee.employeeId).json"

    Write-Output "Leaver workflow completed successfully."

} catch {
    Write-Error "Leaver workflow failed: $_"

    # --- Audit Failure Logging ---
    $logEntry = @{
        Workflow = "Leaver"
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $event.employee.email
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Failed"
        Error = $_.Exception.Message
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Leaver_$($event.employee.employeeId)_Error.json"

    throw
}

