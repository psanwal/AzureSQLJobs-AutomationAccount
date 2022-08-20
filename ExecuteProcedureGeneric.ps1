	# Defining parameters for this runbook.
	Param
	([Parameter (Mandatory= $true)]
	[String] $procedureName,
	[Parameter (Mandatory= $true)]
	[String] $secretValueText
	)
	$ErrorActionPreference = 'Stop'
	try{
	    $outputMsg = "Fetching DBServer and DB name"
		
		# get variable vaule from variable assets defined in Automation account.
		
	    $DBServer = Get-AutomationVariable -Name 'DBServerName'
	    $DBName = Get-AutomationVariable -Name 'DBName'
	    $outputMsg = "$outputMsg `nCreating Data Table To Hold The Output Of Stored Procedure"
		
		# Creating table object to hold output of stored procedure.
		
	    $resultsDataTable = New-Object system.Data.DataTable 
	    $outputMsg = "$outputMsg `nCreating PS Credential Object to use with Invoke-DBAQuery"
		
		# Converting plain text password to a secure string.
		
	    $secStringPassword = ConvertTo-SecureString $secretValueText -AsPlainText -Force
		
		# Creating PSCredentials object.
		
	    $credObject = New-Object System.Management.Automation.PSCredential ('DB_User_Name', $secStringPassword)
	    $outputMsg = "$outputMsg `nCalling Stored procedure"
		
		# Calling stored procedure
		
	    $resultsDataTable = Invoke-DbaQuery -SqlInstance $DBServer -Database $DBName -Query "Exec $procedureName" -SqlCredential $credObject
	    
		# Checking for error messages in output of stored procedure.
		
	    $outputMsg = "$outputMsg `nChecking if procedure Output have any error message"
	    foreach ($row in $resultsDataTable) 
	    {
	        if ( !$row.Item("errorCode") )
	        {
	            $errorMsg = $row.Item('errorMsg')
	            $outputMsg = "$outputMsg `nProcedure errorCode : $errorMsg"
	            throw $errorMsg
	        }
	    }
	    $outputMsg = "$outputMsg `nNo Error Found"
	    Write-Output $outputMsg
	}
	catch{
		
		# in case of any exception, exception msg will be passed to parent runbook catch block.
	    
	    $outputMsg = "$outputMsg `nException in ExecuteProcedureGeneric : `n$_"
	    throw $outputMsg
}
