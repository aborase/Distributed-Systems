#!/bin/sh

port=5000
fpath="/data/string.txt"

echo "***********************************************"
echo "*   COMPILE SERVER AND CLIENT JAVA PROGRAMS   *"
echo "***********************************************"
javac cat_node/catserver.java
javac cat_node/catclient.java

#cleanup existing images and containers
echo "*******************************************************"
echo "*  CLEANUP EXISTING SAME_NAMED IMAGES AND CONTAINERS  *"
echo "*******************************************************"
docker rm -f catclient
docker rm -f catserver
docker rm -f catdata
docker rmi -f cat_data
docker rmi -f cat_node
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
docker build -t cat_node ./cat_node/

echo "****************************************"
echo "*   RUN SERVER AND CLIENT CONTAINERS   *"
echo
docker run -itd --net=mynet --name catserver --volumes-from catdata cat_node java catserver $fpath $port
docker run -itd --net=mynet --name catclient --volumes-from catdata cat_node java catclient $fpath $port

sleep 33

# Results
echo "****************************************"
echo "*   RESULTS FROM THE CAT_CLIENT LOGS   *"
echo "****************************************"
docker logs catclient
docker logs catserver
