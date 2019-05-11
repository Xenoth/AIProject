#!/bin/bash

# Script for tournament, set the port and name for C Server.

# CHANGE IF BIND ERROR ON PORT
JAVA_SERVER_NAME=0.0.0.0
JAVA_SERVER_PORT=1066

SICSTUSJASPERCP=/applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar
SICSTUSLDPATH=/applis/sicstus-4.3.3/lib/

if [[ $# < 2 ]]
then
    echo "Missing args."
	echo "Usage: runJoueur.sh NAME_SERVER_C PORT_SERVER_C (+optional ld_library_path Jasper_classpath)"
    echo "default classpath for ld_library_path : /applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar"
    echo "default classpath for jasper : /applis/sicstus-4.3.3/lib/"
    exit 1
fi

if [[ $# != 4 ]]
then
    echo "default classpath for ld_library_path : /applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar"
    echo "default classpath for jasper : /applis/sicstus-4.3.3/lib/"
fi

if [ ! -z $3 ]
then
    if [[ ! -e $3 ]]
    then
        echo LD library folder not found at \'$3\'
        exit 1
    else
        SICSTUSLDPATH=$3
    fi
fi

if [ ! -z $4 ]
then
    if [[ ! -e $4 ]]
    then
        echo Jasper classpath not found at \'$4\'
        exit 1
    else
       SICSTUSJASPERCP=$4
    fi
fi

export LD_LIBRARY_PATH=${SICSTUSLDPATH}

echo "RUNNING JOUEUR..."

java -cp "./build/:${SICSTUSJASPERCP}" "JavaEngine" ${JAVA_SERVER_PORT} &
cd build/bin
sleep 1
./joueur $1 $2 ${JAVA_SERVER_NAME} ${JAVA_SERVER_PORT}
