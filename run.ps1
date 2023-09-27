function Write-Env {

  # Get network adapters
  $NetworkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

  # Loop through each network adapter and get the IPv4 addresses this will use the last found
  foreach ($Adapter in $NetworkAdapters) {
      $IPv4Address = ($Adapter | Get-NetIPAddress -AddressFamily IPv4).IPAddress
  }

    if ($IPv4Address -eq "" -or $IPv4Address -eq $null) {
        Write-Host "Niet mogelijk om het IP adres te achterhalen. Installeer de container handmatig. Zie hiervoor de github repo!"
        Read-Host -Prompt "Druk op een toets om af te sluiten"
        Exit 1
    }

    # Ask for print vhost
    $vhost = Read-Host -Prompt 'Voer de aangeleverde vhost in'

	# Ask for print queue
	$queue = Read-Host -Prompt 'Voer de aangeleverde queue in'

	# Ask for username
    $user = Read-Host -Prompt 'Voer de aangeleverde gebruikersnaam in'

    # Ask for password
    $pass = Read-Host -Prompt 'Voer het aangeleverde wachtwoord in'

	# Copy environment example file to environment
	Copy-Item ".env-example" -Destination ".env"

	# Replace environment values
	(Get-Content .env) `
		-replace 'CUPS_SERVER_IP=', "CUPS_SERVER_IP='$($IPv4Address)'" `
        -replace 'RABBITMQ_USER=', "RABBITMQ_USER='$($user)'" `
        -replace 'RABBITMQ_PASSWORD=', "RABBITMQ_PASSWORD='$($pass)'" `
        -replace 'RABBITMQ_VHOST=', "RABBITMQ_VHOST='$($vhost)'" `
		-replace 'RABBITMQ_QUEUE=', "RABBITMQ_QUEUE='$($queue)'" |
	  Out-File .env -encoding utf8
}

if ((Test-Path -Path ".env" -PathType Leaf) -eq $false) {
	Write-Env
}

docker-compose stop
docker-compose pull
docker-compose up -d