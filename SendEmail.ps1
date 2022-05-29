	# Defining parameters
	
	Param
	([Parameter (Mandatory= $true)]
	[String] $body,
	[Parameter (Mandatory= $true)]
	[String] $subject
	)
	
	# Declaring email for receipients.
	
	$to = 'email@domain.com'
	$cc = 'email@domain.com'
	$bcc = 'email@domain.com'
	
	$ErrorActionPreference = 'Stop'
	
	try{
		
	# Replacing new line character `n with HTML <br> tag for email body.
	
	$bodyHtml = $body.replace("`n","<br>")
	$payload = @{
	    body = $bodyHtml
	    subject= $subject
	    to= $to
	    cc= $cc
	    bcc= $bcc
	} | ConvertTo-Json
	$token = 'Your bearer token'
	$outputMsg = "Preparing Headers"
	
	# Defining headers for Post API request.
	
	$Header = @{
	    "X-Auth-Token" = "Bearer $token"
	}
	$uri = "https://YourApiUrl"
	$outputMsg = "$outputMsg `nSending Post request to sendEmail API"
	
	# Calling Email API
	
	$x = Invoke-WebRequest -Method 'Post' -Uri $uri -Body $payload -Headers $Header -ContentType "application/json" -UseBasicParsing
	$outputMsg = "$outputMsg `nResponse Content $x `nisException : True"
	Write-Output $outputMsg
	}
	catch{
	    $outputMsg = "$outputMsg `nException in SendEmail : `n$_ `nisException : True"
	    Write-Output $outputMsg
}