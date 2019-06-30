#!/bin/sh

mydir=`dirname $0`
sh -c "${mydir}/own-data.sh ./data"

# Delete DynMap data
cp ./data/plugins/dynmap/configuration.txt .
rm -r ./data/plugins/dynmap/*
mv ./configuration.txt ./data/plugins/dynmap

# Delete plugins data
sudo docker volume rm docked-spigot_mysql

# Delete world data
rm -r ./data/world/*
