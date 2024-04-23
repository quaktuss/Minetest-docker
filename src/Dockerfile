# Stage 1: Build environment
FROM ubuntu:20.04 as builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for building Minetest
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

# Stage 2: Final image
FROM ubuntu:20.04

# Copy built binaries and data from the builder stage
COPY --from=builder /minetest/bin/minetestserver /usr/local/bin/minetestserver
COPY --from=builder /minetest /minetest

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libfreetype6-dev \
    libjsoncpp-dev \
    libncurses5-dev \
    libzstd-dev \
    libsqlite3-dev \
    libogg-dev \
    libvorbis-dev \
    libopenal-dev \
    libirrlicht-dev \
    && rm -rf /var/lib/apt/lists/*

# Add Minetest map (make sure SERVERNAME argument is passed)
ARG SERVERNAME
COPY ${SERVERNAME} /minetest/worlds/${SERVERNAME}

# Expose the default Minetest port
EXPOSE 30000/udp

# Set the entry point and default command
ENTRYPOINT ["minetestserver"]
CMD ["--worldname", "downloaded-map", "--gameid", "minetest_game"]
