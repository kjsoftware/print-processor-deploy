# print-processor-deploy

De print-processor verwerkt de printopdrachten die vanuit de applicatie worden aangevraagd.

## Requirements

Om de print-processor te kunnen gebruiken, moeten de volgende onderdelen op het station geïnstalleerd zijn:
- Docker Desktop
- Git

Daarnaast moeten er configuratiegegevens door KJ Software opgestuurd zijn. Mocht je deze nog niet hebben ontvangen, neem dan contact op.

## Voorbereiding

Maak een clone van de repository (branch: env/production).

```bash
  git clone https://github.com/kjsoftware/print-processor-deploy.git --branch env/production
```

## Installatie (Windows - geautomatiseerd)

Als het een Windows machine betreft, kan de installatie geautomatiseerd verlopen via PowerShell.  
Voer het bestand [run.ps1](run.ps1) uit in PowerShell. 

Er zal om de configuratiegegevens gevraagd worden. 

### Updaten

Voer het bestand [run.ps1](run.ps1) opnieuw uit in PowerShell.  
De laatste versie zal opgehaald en uitgevoerd worden.  

> Tip: Voeg het bestand toe tijdens het opstarten van de machine, zodat de instantie altijd draait en de instantie altijd up-to-date is.

## Installatie (handmatig)

Indien het niet mogelijk is om de geautomatiseerde installatie te starten, moeten de volgende stappen handmatig gevolgd worden:
1. Kopieer bestand [.env-example](.env-example) en hernoem naar ".env"
2. Zoek het IP-adres van de machine op
3. Bewerk .env bestand en voer waardes in  
CUPS_SERVER_IP='Het verkregen IP uit stap 2'  
RABBITMQ_QUEUE='De queue ontvangen vanuit configuratiegegevens KJ Software'  
RABBITMQ_VHOST='De vhost ontvangen vanuit configuratiegegevens KJ Software'  
RABBITMQ_USER='De gebruikersnaam ontvangen vanuit configuratiegegevens KJ Software'  
RABBITMQ_PASSWORD='Het wachtwoord ontvangen vanuit configuratiegegevens KJ Software'  
4. Voer commando uit:  
```bash
    docker-compose up -d
```

### Updaten

Voer de volgende commando's uit (vanuit de root folder) om de container bij te werken.
```bash
    docker-compose stop
    docker-compose pull
    docker-compose up -d 
```

> Tip: Ook al faalt de automatische installatie kun je het bestand alsnog toevoegen aan de opstart van de machine om zo het updaten te automatiseren.

We raden aan om de container dagelijks opnieuw op te starten. Dit kan bijvoorbeeld door een taak in te stellen in Windows Taakplanner.
Dit zorgt ervoor dat de container altijd up-to-date blijft en eventuele problemen worden opgelost.