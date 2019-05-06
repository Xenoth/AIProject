#!/bin/bash

# Script for tournament, set the port and name for C Server.

# CHANGE IF BIND ERROR ON PORT
JAVA_SERVER_NAME=0.0.0.0
JAVA_SERVER_PORT=1066

SICSTUSJASPERCP=/applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar
SICSTUSLDPATH=/applis/sicstus-4.3.3/lib/

if [[ $# != 2 ]]
then
    echo "Missing args."
	echo "Usage: run.sh NAME_SERVER_C PORT_SERVER_C"
    exit 1
fi

export LD_LIBRARY_PATH=${SICSTUSLDPATH}

echo "RUNNING..."

java -cp "./build/:${SICSTUSJASPERCP}" "JavaEngine" ${JAVA_SERVER_PORT} &
cd build/bin
sleep 1
./joueur $1 $2 ${JAVA_SERVER_NAME} ${JAVA_SERVER_PORT}
