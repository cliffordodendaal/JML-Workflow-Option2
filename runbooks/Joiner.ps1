<#
.SYNOPSIS
    Joiner.ps1 – Automates the Joiner workflow for new employees.

.DESCRIPTION
    This runbook provisions a new user account based on Sage HR + Jira approval payload.
    It creates AD/Entra ID accounts, enables Exchange mailbox, assigns licenses,
    and adds the user to appropriate groups. All actions are logged for Sentinel monitoring.

.PARAMETER Payload
    JSON payload from Sage HR via Jira webhook containing employee attributes.

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

Write-Output "Processing Joiner workflow for $($event.employee.firstName) $($event.employee.lastName)..."

try {
    # --- Governance Gate ---
    if ($event.workflow.approvalStatus -ne "Approved") {
        throw "Joiner workflow not approved in Jira. Aborting."
    }

    # --- AD Account Creation ---
    $userPrincipalName = $event.employee.email
    New-ADUser -Name "$($event.employee.firstName) $($event.employee.lastName)" `
               -SamAccountName $event.employee.employeeId `
               -UserPrincipalName $userPrincipalName `
               -Department $event.employee.department `
               -Title $event.employee.jobTitle `
               -Enabled $true

    Write-Output "AD account created for $userPrincipalName"

    # --- Exchange Mailbox Enablement ---
    Enable-Mailbox -Identity $userPrincipalName
    Write-Output "Exchange mailbox enabled for $userPrincipalName"

    # --- License Assignment (Entra ID / M365) ---
    foreach ($license in $event.provisioning.assignLicenses) {
        Set-MsolUserLicense -UserPrincipalName $userPrincipalName -AddLicenses $license
        Write-Output "Assigned license $license to $userPrincipalName"
    }

    # --- Group Memberships ---
    foreach ($group in $event.provisioning.addGroups) {
        Add-ADGroupMember -Identity $group -Members $userPrincipalName
        Write-Output "Added $userPrincipalName to group $group"
    }

    # --- Audit Logging ---
    $logEntry = @{
        Workflow = "Joiner"
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $userPrincipalName
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Success"
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Joiner_$($event.employee.employeeId).json"

    Write-Output "Joiner workflow completed successfully."

} catch {
    Write-Error "Joiner workflow failed: $_"

    # --- Audit Failure Logging ---
    $logEntry = @{
        Workflow = "Joiner"
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $event.employee.email
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Failed"
        Error = $_.Exception.Message
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Joiner_$($event.employee.employeeId)_Error.json"

    throw
}

