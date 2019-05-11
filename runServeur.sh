#!/bin/bash

# Script for tournament, set the port for C Server.

if [[ $# != 1 ]]
then
    echo "Missing args."
	echo "Usage: runServeur.sh PORT_SERVER_C"
    exit 1
fi

echo "RUNNING SERVEUR..."

cd build/bin
sleep 1
./serveurArbitre $1
