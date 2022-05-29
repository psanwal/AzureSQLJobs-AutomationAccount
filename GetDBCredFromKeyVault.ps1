	$ErrorActionPreference = 'Stop'
	try{
	    $outputMsg = "Trying to fetch value from key vault using Managed Identity"
		
		# read key from Key vault using Get-AzKeyVaultSecret cmdlet.
		# Automation account should be configured with managed identity.
		# Automation account managed identity should have proper rights on Key vault you are trying to read.
		
	    $secret = Get-AzKeyVaultSecret -VaultName 'YourKeyVaultName' -Name 'KeyName'
		
		# Storing secret value to memory location
	    $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
	    
	    $outputMsg = "$outputMsg `nSecret Fetched Successfully"
	    $outputMsg = "$outputMsg `n$ssPtr"
	    Write-Output $outputMsg
	}
	catch
	{
	    $outputMsg = "$outputMsg `nIn Catch Block GetDBCredFromKeyVault"
	    $outputMsg = "$outputMsg `nError in Getting DB Credentials from KeyValut. Exception message is mentioned below."
	    
		# in case there is any exception reading secret vaule, exception message _$ will be thrown out to parent runbook catch block
		
		$outputMsg = "$outputMsg `n$_"
	    throw $outputMsg
}