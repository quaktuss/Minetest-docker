FROM alpline:latest

LABEL VERSION=0.1

RUN apt update && apt upgrade -y

COPY ./minetest minetest/