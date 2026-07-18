<#
.SYNOPSIS
    Mover.ps1 – Automates the Mover workflow for employees changing roles.

.DESCRIPTION
    This runbook updates user attributes, modifies group memberships, and adjusts licenses
    based on Sage HR + Jira approval payload. All actions are logged for Sentinel monitoring.

.PARAMETER Payload
    JSON payload from Sage HR via Jira webhook containing employee attributes.

.NOTES
    Author: cliffordodendaal
    Compliance: SOX 404, NIST AC-2(3), ISO 27001 A.9.2
    Audit: Logs pushed to Log Analytics for Sentinel ingestion
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Payload
)

# Convert incoming JSON payload
$event = $Payload | ConvertFrom-Json

Write-Output "Processing Mover workflow for $($event.employee.firstName) $($event.employee.lastName)..."

try {
    # --- Governance Gate ---
    if ($event.workflow.approvalStatus -ne "Approved") {
        throw "Mover workflow not approved in Jira. Aborting."
    }

    $userPrincipalName = $event.employee.email

    # --- Update Attributes ---
    Set-ADUser -Identity $userPrincipalName `
               -Title $event.modifications.updateAttributes.jobTitle `
               -Department $event.modifications.updateAttributes.department
    Write-Output "Updated attributes for $userPrincipalName"

    # --- Modify Group Memberships ---
    foreach ($group in $event.modifications.modifyGroups.remove) {
        Remove-ADGroupMember -Identity $group -Members $userPrincipalName -Confirm:$false
        Write-Output "Removed $userPrincipalName from group $group"
    }
    foreach ($group in $event.modifications.modifyGroups.add) {
        Add-ADGroupMember -Identity $group -Members $userPrincipalName
        Write-Output "Added $userPrincipalName to group $group"
    }

    # --- Update Licenses ---
    foreach ($license in $event.modifications.updateLicenses.remove) {
        Set-MsolUserLicense -UserPrincipalName $userPrincipalName -RemoveLicenses $license
        Write-Output "Removed license $license from $userPrincipalName"
    }
    foreach ($license in $event.modifications.updateLicenses.add) {
        Set-MsolUserLicense -UserPrincipalName $userPrincipalName -AddLicenses $license
        Write-Output "Added license $license to $userPrincipalName"
    }

    # --- Update Manager ---
    if ($event.modifications.updateManager -eq $true) {
        Set-ADUser -Identity $userPrincipalName -Manager $event.employee.managerId
        Write-Output "Updated manager for $userPrincipalName"
    }

    # --- Audit Logging ---
    $logEntry = @{
        Workflow = "Mover"
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $userPrincipalName
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Success"
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Mover_$($event.employee.employeeId).json"

    Write-Output "Mover workflow completed successfully."

} catch {
    Write-Error "Mover workflow failed: $_"

    # --- Audit Failure Logging ---
    $logEntry = @{
        Workflow = "Mover"
        EmployeeId = $event.employee.employeeId
        UserPrincipalName = $event.employee.email
        JiraTicket = $event.workflow.jiraTicketId
        Timestamp = (Get-Date).ToString("o")
        Status = "Failed"
        Error = $_.Exception.Message
    }
    $logEntry | ConvertTo-Json | Out-File "C:\RunbookLogs\Mover_$($event.employee.employeeId)_Error.json"

    throw
}

