#!/bin/bash

##### CUSTOM ECHO #####
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to echo in color
color_echo() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Function to check and install Docker
install_docker() {
    if ! command -v docker &> /dev/null; then
        color_echo $YELLOW "Docker is not installed. Installing..."
        curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null
        sudo sh get-docker.sh > /dev/null
        sudo usermod -aG docker $USER
        rm get-docker.sh
        color_echo $GREEN "Docker installed successfully."
    fi
}

# Function to check if OpenSSH is installed
check_ssh() {
    if ! command -v ssh &> /dev/null; then
        color_echo $RED "SSH is not installed. Please install OpenSSH."
        exit 1
    fi
}

# Function to extract downloaded file
extract_file() {
    local file=$1
    local servername="downloaded-map"
    local spinner="/-\|"
    local delay=0.1

    case $file in 
        *.zip)
            color_echo $BLUE "🚧 Extraction in progress..."
            sudo unzip -qq -o -d "$servername" -j "$file" > /dev/null
            ;;
        *.tar.gz)
            color_echo $BLUE "Extraction in progress..."
            sudo mkdir $servername && tar xf $file -C $servername --strip-components 1 > /dev/null
            ;;
        *.gz)
            color_echo $BLUE "Extraction in progress..."
            sudo gzip -d "$file" > /dev/null
            filename=$(basename "$file" .gz)
            sudo mv "$filename" "$servername" > /dev/null
            ;;
        *)
            color_echo $RED "Please provide a *.zip, *tar.gz, or *.gz file."
            exit 1
            ;;
    esac
    
    color_echo $GREEN "Extraction completed."
}

# Main function
main() {
    color_echo $BLUE "🚀 Initializing process..."
    check_ssh
    install_docker
    color_echo $BLUE "📥 Downloading file: $1"
    extract_file $1
    color_echo $BLUE "🐳 Building Docker image..."
    docker build -t "minetest_server" --build-arg SERVERNAME=$servername . > /dev/null
    sudo rm -rf src/$servername
    color_echo $GREEN "✅ Process completed successfully."
    color_echo $GREEN "🚀 Server starting..."
    docker run -d -p 30000:30000/udp minetest_server
    color_echo $GREEN "✅ Server started ! You can play join at 0.0.0.0:30000"
}

# Execute main function
main "$@"
