#Instal Docker File & Docker compose
#!/bin/bash

# Fonction pour détecter la distribution Linux
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

# Installation basée sur la distribution détectée
case $OS in
    Ubuntu|Debian)
        sudo apt-get update -y
        sudo apt-get install -y docker.io docker-compose
        ;;
    Fedora)
        sudo dnf -y install docker docker-compose
        sudo systemctl start docker
        sudo systemctl enable docker
        ;;
    CentOS)
        sudo yum update -y
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-compose
        sudo systemctl start docker
        sudo systemctl enable docker
        ;;
    *)
        echo "Désolé, votre distribution ($OS) n'est pas prise en charge par ce script."
        exit 1
        ;;
esac

# Ajout de l'utilisateur au groupe docker
sudo usermod -aG docker $USER

# Activation de docker au démarrage
sudo systemctl enable docker

# Message de fin
echo "Docker installé et configuré sur $OS"


echo " Map : $1"

servername="downloaded-map"

case $1 in 
    *.zip)
        sudo unzip -d "$servername" -j "$1" 
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

docker build -t "minetest_v1.0.0" --build-arg SERVERNAME=$servername .
