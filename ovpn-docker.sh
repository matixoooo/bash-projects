#!/bin/bash

mikruspubip= #adres publiczny przez ktory laczysz sie do ssh srv08...
mikrusport=20217 ##port na torym ma nasluchiwac openvpn UDP musisz uzyc dwoch udostepnionych w ramach mikrusa
user=example ## user ovpn


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

mkdir /docker && cd /docker &&

git clone https://github.com/kylemanna/docker-openvpn.git /docker/docker-openvpn &&

cd /docker/docker-openvpn && docker build -t myownvpn . &&

mkdir -p /docker/vpn-data && touch /docker/vpn-data/vars &&

docker run -v /docker/vpn-data:/etc/openvpn --rm myownvpn ovpn_genconfig -u udp://$mikruspubip:$mikrusport &&

docker run -v /docker/vpn-data:/etc/openvpn --rm -it myownvpn ovpn_initpki && 

docker run --name vpn-docker --privileged -v /docker/vpn-data:/etc/openvpn -v /dev/net/tun:/dev/net/tun -d -p $mikrusport:1194/udp --cap-add=NET_ADMIN myownvpn &&

cd /docker &&

docker run -v /docker/vpn-data:/etc/openvpn --rm -it myownvpn easyrsa build-client-full $user nopass &&

docker run -v /docker/vpn-data:/etc/openvpn --rm myownvpn ovpn_getclient $user > $user.ovpn

cat > docker-compose.yml <<'_EOF'
version: '3'

services:
  openvpn:
    build:
      context: ./docker-openvpn
      dockerfile: Dockerfile
    ports:
      - "$mikrusport:1194/udp"    
    volumes:
      - /docker/vpn-data:/etc/openvpn
      - /dev/net/tun:/dev/net/tun:ro 
    cap_add:
      - NET_ADMIN
    restart: unless-stopped
    networks: 
      vpn:
        ipv4_address: "172.1.69.69"


networks:
  vpn:
    driver: bridge
    ipam:
     config:
       - subnet: 172.1.0.0/16
 #        gateway: 172.1.69.1
_EOF

echo DONE!
