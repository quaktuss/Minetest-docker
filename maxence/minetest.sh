#!/bin/bash

usage() {
  echo "Usage: $0 <map_archive>" 1>&2
  echo "Arguments:" 1>&2
  echo "  <map_archive> : Nom du fichier ZIP, TAR ou GZ contenant la carte Minetest à charger (obligatoire)" 1>&2
  exit 1
}

map_archive="$1"

if [ -z "$map_archive" ]; then
  echo "Veuillez spécifier le nom du fichier ZIP, TAR ou GZ contenant la carte Minetest à charger." 1>&2
  usage
fi

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

git clone git@github.com:quaktuss/Minetest-docker.git Minetest-docker || exit 1
cd Minetest-docker || exit 1

docker build -t minetest:latest --build-arg MAP_ARCHIVE="$map_archive" .
docker run --name minetest_server -d -p 30000:30000/udp minetest:latest

# Supprimer le répertoire cloné après avoir construit l'image Docker et lancé le conteneur
cd ..
rm -rf Minetest-docker
