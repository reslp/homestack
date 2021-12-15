
if [[ $(which docker-compose) == "" ]]; then
	echo "Docker compose has to be installed. Will do this now..."
	sudo apt-get install docker-compose
fi

echo "Enter password you want to use for pihole (make sure to keep it somewhere save):"
read -p $PW

sed -i s/mypihole/${PW}/ docker-compose.yml
echo "Will start pihole now"
docker-compose -d up



