# AzureSQLJobs-AutomationAccount
Execute Azure SQL DB Procedures via Automation Account PowerShell runbooks

## Table Of Content
* Introduction
* Technologies/Services Used
* Components

### Introduction
This project enables you to execute/schedule Azure SQL Stored procedure using PowerShell runbooks in Azure Automation Account.

### Technologies/Services Used
* Powershell 5.1
* Azure Automation Account

### Components
* Parent job runbook.
* GetDBCredFromKeyVault.ps1 (Child runbook to read DB credentials from KeyVault)
* ExecuteProcedureGeneric.ps1 (Child runbook to execute stored procedure)
* SendEmail.ps1 (Child runbook to send email in case of exceptions)
  
