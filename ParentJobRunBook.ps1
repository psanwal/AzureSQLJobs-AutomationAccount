$ErrorActionPreference = 'Stop'
try
{
	# Calling child runbook to get DB credentials from Keyvault
	
	$outputMsg = .\GetDBCredFromKeyVault.ps1
	
	# Parsing output of .\GetDBCredFromKeyVault.ps1 runbook to fetch memory location address
	
	$outputMsgArray = $outputMsg.split("`n")
	$intPTR = [long]$outputMsgArray[-1]
	$secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($intPTR)
	[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($intPTR)

	# Calling another child runbook to execute the procedure in Azure SQL DB
	
	$procedureExecutionOutput = .\ExecuteProcedureGeneric.ps1 `
		-procedureName 'usp_ExecJobAccessProfileHistory' `
		-secretValueText $secretValueText
		
	$outputMsg = "$outputMsg `n$procedureExecutionOutput"
	Write-Output $outputMsg
}
catch
{
	$outputMsg = "$outputMsg `n$_ `nInside Catch Block in AccessProfileHistory "
	$outputMsg = "$outputMsg `nCalling SendEmail Runbook "
	
	# Calling SendEmail child runbook in case any exception occured
	
	$emailOutPut = .\SendEmail.ps1 `
		-Body $outputMsg `
		-Subject 'Failure in AccessProileHistory Job'
	$outputMsg = "$outputMsg `n$emailOutPut"
	Write-Output $outputMsg
	
	# Finally calling throw statement to forcefully set the runbook to failed.
	
	throw
}
