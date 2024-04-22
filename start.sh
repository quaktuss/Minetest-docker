#Instal Docker File & Docker compose
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg
sudo install -y -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg -f --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update

sudo apt-get install -y docker-ce docker-ce-cli docker-buildx-plugin docker-compose-plugin


echo "Docker installé !"



