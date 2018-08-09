#!/bin/bash
echo "Checking Docker Installation"
dockerCheck=$(docker ps)
	if (( $? != 0 )); then
		echo "FAILURE"
		echo
		echo "Cannot reach Docker" 
		sudo apt-get install -y docker.io
	else
		echo "OK"
	fi
dockerCheck=$(docker-compose --version)
	if (( $? != 0 )); then
		echo "FAILURE"
		echo
		echo "Cannot reach docker-compose" 
		sudo apt-get install -y docker-compose
	else
		echo "OK"
fi
echo "Please enter your email for SSL certificates from CertBot"
read email
echo "You entered $email"
echo "Please enter your primary domain name like : mydomain.com "
read domain
echo "You entered $domain"
echo "Please enter your monitor domain name like : monitor.mydomain.com "
read monitor_domain
echo "You entered $monitor_domain"

echo "Setting Variables"
MYSQLROOTPASS=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
DBNAME=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 6)
mkdir $domain
mkdir -p $domain/wp-content

echo "Made new $domain directory with source files"
sed -i 's/MONITOR/'$monitor_domain'/g' restart.sh
sed -i 's/DOMAIN/'$domain'/g' traefik.toml
sed -i 's/EMAIL/'$email'/g' traefik.toml
sed -i 's/MYSQLROOTPASS/'$MYSQLROOTPASS'/g' docker-compose.yml
sed -i 's/DOMAIN/'$DOMAIN'/g' docker-compose.yml
sed -i 's/DBNAME/'$DBNAME'/g' docker-compose.yml

echo "Moving things into place..."
cp restart.sh $domain/
cp traefik.toml $domain/
cp docker-compose.yml $domain/
cp uploads.ini $domain/

cd $domain ; touch acme.json ; chmod 600 acme.json ; chmod +x ./restart.sh
echo "Starting in 5 seconds..."
sleep 5
./restart.sh
echo "Your site $domain is now ready."