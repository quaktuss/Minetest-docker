#Instal Docker File & Docker compose
#!/bin/bash

##### ECHO CUSTOM #####
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


detect_distribution() {
    if [ -f /etc/os-release ]; then
        # freedesktop.org et systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # Pour certaines versions de Debian/Ubuntu sans lsb_release
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Ancien Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    else
        # Système inconnu
        OS=$(uname -s)
        VER=$(uname -r)
    fi
}

# Exécuter la fonction de détection
detect_distribution

function pacman_progress() {

  # Définition des caractères pour Pac-Man et le point
  pacman_closed="C"
  pacman_open="c"
  dot="."
  blank=" "

  # Total de points à "manger"
  total_dots=30

  # Initialisation de la barre
  echo -ne "Chargement: ["

  # Position initiale de Pac-Man
  pos=0

  while [ $pos -le $total_dots ]; do
    # Effacer la ligne précédente
    echo -ne "\rChargement: ["

    # Afficher les points mangés par Pac-Man
    for ((i=0; i<pos; i++)); do
        echo -n "$blank"
    done

    # Alternance de la bouche ouverte et fermée de Pac-Man
    if ((pos % 2 == 0)); then
        echo -n "$pacman_open"
    else
        echo -n "$pacman_closed"
    fi

    # Afficher les points restants
    for ((i=pos+1; i<=total_dots; i++)); do
        echo -n "$dot"
    done

    # Fermer la barre
    echo -n "]"

    # Incrémenter la position de Pac-Man
    ((pos++))

    # Délai pour l'animation
    sleep 0.1
  done

  echo " Terminé!"
}


Installation_docker() {
    case $OS in
        Ubuntu|Debian)
            sudo apt-get update -y &> /dev/null &
            local pid=$!
            pacman_progress $pid
            wait $pid
            sudo apt-get install -y docker.io docker-compose &> /dev/null &
            pid=$!
            pacman_progress $pid
            wait $pid
            ;;
        Fedora)
            sudo dnf -y install docker docker-compose &> /dev/null &
            local pid=$!
            pacman_progress $pid
            wait $pid
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        CentOS)
            sudo yum update -y &> /dev/null &
            local pid=$!
            pacman_progress $pid
            wait $pid
            sudo yum install -y yum-utils docker-ce docker-compose &> /dev/null &
            pid=$!
            pacman_progress $pid
            wait $pid
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        *)
            echo "Désolé, votre distribution ($OS) n'est pas prise en charge par ce script."
            exit 1
            ;;
    esac
}




if ! command -v docker &> /dev/null; then
  echo "Docker n'est pas installé. Installation en cours..."
  Installation_docker
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
