#!/bin/bash

# Script for tournament, set the port and name for C Server.

C_SERVER_NAME=0.0.0.0
JAVA_SERVER_NAME=0.0.0.0

C_SERVER_PORT=1065
JAVA_SERVER_PORT=1066

if [[ $# != 2 ]]
then
    echo Missing ld_library_path and jasper classpath in args
    exit 1
fi

if [[ ! -e $1 ]]
then
    echo LD library folder not found at \'$1\'
    exit 1
fi

if [[ ! -e $1 ]]
then
    echo Jasper classpath not found at \'$2\'
    exit 1
fi


echo "RUNNING..."

java -cp "./build/:$2" "JavaEngine" ${JAVA_SERVER_PORT} &
cd build/bin
sleep 1
./joueur ${C_SERVER_NAME} ${C_SERVER_PORT} ${JAVA_SERVER_NAME} ${JAVA_SERVER_PORT}
