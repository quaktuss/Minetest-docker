# Use a base image with Ubuntu
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ARG SERVERNAME

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libirrlicht-dev \
    cmake \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libxxf86vm-dev \
    libgl1-mesa-dev \
    libsqlite3-dev \
    libogg-dev \
    libvorbis-dev

RUN apt-get install -y \
    libopenal-dev \
    libcurl4-gnutls-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libgmp-dev \
    libjsoncpp-dev \
    git \
    wget \
    libncurses5-dev \  
    libzstd-dev        

# Clone Minetest repository
RUN git clone --depth 1 https://github.com/minetest/minetest.git /minetest

# Clone Minetest Game repository
RUN git clone --depth 1 https://github.com/minetest/minetest_game.git /minetest/games/minetest_game

# Build Minetest
WORKDIR /minetest
RUN cmake . -DRUN_IN_PLACE=TRUE -DBUILD_CLIENT=FALSE -DBUILD_SERVER=TRUE
RUN make -j$(nproc)

# Add Minetest map 
COPY ${SERVERNAME} /minetest/worlds/${SERVERNAME} 

# Expose the default Minetest port
EXPOSE 30000/udp

# Set the entry point
ENTRYPOINT ["./bin/minetestserver"]
CMD ["--worldname", "downloaded-map", "--gameid", "minetest_game"]
