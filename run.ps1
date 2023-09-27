function Write-Env {
	# Retrieve local IP
	$ip = (Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet).IPAddress

    # Ask for print vhost
    $vhost = Read-Host -Prompt 'Voer aangeleverde vhost in'

	# Ask for print queue
	$queue = Read-Host -Prompt 'Voer aangeleverde queue in'

	# Ask for username
    $user = Read-Host -Prompt 'Voer aangeleverde gebruikersnaam in'

    # Ask for password
    $pass = Read-Host -Prompt 'Voer aangeleverde wachtwoord in'

	# Copy environment example file to environment
	Copy-Item ".env-example" -Destination ".env"

	# Replace environment values
	(Get-Content .env) `
		-replace 'CUPS_SERVER_IP=', "CUPS_SERVER_IP='$($ip)'" `
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