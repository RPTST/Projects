Installed on Ticket Board with Armbian ubuntu desktop

Update SoC

sudo apt-get update
sudo apt-­get install armdian-update
sudo armdian-update
sudo reboot
sudo apt-get upgrade
sudo reboot
sudo apt-get install python python3 python-pip python3-pip curl git wget nano net-tools ser2net bridge-utils

Install Docker
sudo curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi

or

sudo curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh
sudo groupadd docker
sudo gpasswd -a pi docker
newgrp docker


Tested images that work


docker run armhf/hello-world