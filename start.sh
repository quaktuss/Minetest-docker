#Instal Docker File & Docker compose
#!/bin/bash

##### ECHO CUSTOM #####
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

if ! command -v docker &> /dev/null; then
  echo "Docker n'est pas installé. Installation en cours..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker $USER
  rm get-docker.sh
fi

if ! command -v ssh &> /dev/null; then
  echo "SSH n'est pas installé. Veuillez installer OpenSSH."
  exit 1
fi

echo " Map : $1"

servername="downloaded-map"

case $1 in 
    *.zip)
        echo "EXTRACTING..."
        sudo unzip -qq -d "$servername" -j "$1" 
        ;;
    *.tar.gz)
        sudo mkdir $servername && tar xf $1 -C $servername --strip-components 1
        ;;
    *.gz)
        sudo gzip -d "$1" 
        filename=$(basename "$1" .gz)
        sudo mv "$filename" "$servername"
        ;;
    *)
        echo "Please share a *.zip, *tar.gz, *.gz file"
        exit 1
        ;;
esac

docker build -t "minetest_server" --build-arg SERVERNAME=$servername .

sudo rm -rf $servername

docker run --name minetest_server -d -p 30000:30000/udp minetest_server