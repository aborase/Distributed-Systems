#!/bin/sh

port=5000
fpath="/data/string.txt"

#cleanup existing images and containers
echo "*******************************************************"
echo "*  CLEANUP EXISTING SAME_NAMED IMAGES AND CONTAINERS  *"
echo "*******************************************************"
docker rm -f catclient
docker rm -f catserver
docker rm -f catdata
docker rmi -f cat_data
docker rmi -f cat_server
docker rmi -f cat_client
docker network rm mynet

# create custom network off 'bridge'
echo "********************************"
echo "*   CREATE A CUSTOM NETWORK    *"
echo "********************************"

docker network create -d bridge mynet

# build data volume image and run a container off the same
echo "********************************************************"
echo "*    BUILD AND INSTANTIATE A DATA VOLUME CONTAINER     *"
echo "********************************************************"
docker build -t cat_data ./cat_data/
docker run -itd --name catdata cat_data

# build a client & server image and run a server and client containers based on the same
echo "****************************************"
echo "*    BUILD SERVER AND CLIENT IMAGES    *"
echo "****************************************"
docker build -t cat_server ./cat_server/
docker build -t cat_client ./cat_client/

echo "****************************************"
echo "*   RUN SERVER AND CLIENT CONTAINERS   *"
echo "****************************************"
docker run -itd --net=mynet --name catserver --volumes-from catdata cat_server python catserver.py $fpath $port
docker run -itd --net=mynet --name catclient --volumes-from catdata cat_client python catclient.py $fpath $port

sleep 33

# Results
echo "****************************************"
echo "*   RESULTS FROM THE CAT_CLIENT LOGS   *"
echo "****************************************"
docker logs catclient
