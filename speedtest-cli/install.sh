#!/bin/bash
set -e

echo "Will first pull the correct docker container"
docker pull reslp/speedtest-cli:2.1.3

echo "Now I will download the dropbox command line client so that the speedtest results will always be in the dropbox"
wget https://github.com/dropbox/dbxcli/releases/download/v3.0.0/dbxcli-linux-arm

echo "It will be placed in ~/bin"

mkdir -p ~/bin
cp dbxcli-linux-arm ~/bin/dbxcli
chmod +x ~/bin/dbxcli
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

touch test
echo "We will now use dbxcli for the first time to set up the connection to the Dropbox account. To do this you will have to follow these instructions:"
~/bin/dbxcli put $(pwd)/test test
rm test

echo "Now we setup crontabs to get speedtest to run and the data to Dropbox"

crontab -l > file;

echo '3 */6 * * * docker run --rm reslp/speedtest-cli:2.1.3 speedtest-cli --csv >> /home/pi/speedtest/speedtest_data.txt 2> /home/pi/speedtest/log_speedtest' >> file
echo '5 */6 * * * /home/pi/bin/dbxcli put /home/pi/speedtest/speedtest_data.txt speedtest_data.txt 2> /home/pi/log_dbxcli' >> file

crontab file

rm file

echo "done"


