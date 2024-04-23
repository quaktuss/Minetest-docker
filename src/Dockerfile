# Stage 1: Build environment
FROM ubuntu:20.04 as builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

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
    libvorbis-dev \
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

# Stage 2: Runtime environment
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ARG SERVERNAME

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libirrlicht-dev \
    libcurl4-gnutls-dev \
    libopenal-dev \
    libvorbis-dev \
    libogg-dev \
    libfreetype6-dev \
    libsqlite3-dev \
    zlib1g-dev \
    libjsoncpp-dev

# Copy the built executable and other necessary files from the builder stage
COPY --from=builder /minetest/ /minetest/

# Add Minetest map
COPY ${SERVERNAME} /minetest/worlds/${SERVERNAME}

# Expose the default Minetest port
EXPOSE 30000/udp

# Set the entry point
WORKDIR /minetest
ENTRYPOINT ["./bin/minetestserver"]
CMD ["--worldname", "downloaded-map", "--gameid", "minetest_game"]
