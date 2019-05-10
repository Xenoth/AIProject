#!/bin/bash

C_SERVER_NAME=0.0.0.0
JAVA_SERVER_NAME=0.0.0.0

C_SERVER_PORT=1045
JAVA_SERVER_PORT=1046
JAVA_SERVER_PORT2=1747

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

if [[ ! -d build ]]
then
    mkdir build
fi

if [[ ! -d build/bin ]]
then
    mkdir build/bin
fi

if [[ ! -e build/bin/yokaiServeur ]]
then
    cd build/bin
    tar xvf ../../Ref/yokai_v3.tar.gz
    cd ../../
fi


echo "BUILDING C EXECUTABLES"

# Building Joueur
cd build
cmake ..
make
cd ..

echo "BUILDING JAVA ENGINE"

export LD_LIBRARY_PATH=$1
javac -cp $2 -d build src/main/java/*.java


echo "RUNNING..."
skill java &
sleep 1
java -cp "./build/:$2" "JavaEngine" ${JAVA_SERVER_PORT} &
java -cp "./build/:$2" "JavaEngine" ${JAVA_SERVER_PORT2} &
cd build/bin
./yokaiServeur ${C_SERVER_PORT} &
#./serveurArbitre ${C_SERVER_PORT} &
sleep 1
./joueur ${C_SERVER_NAME} ${C_SERVER_PORT} ${JAVA_SERVER_NAME} ${JAVA_SERVER_PORT} &
./joueur ${C_SERVER_NAME} ${C_SERVER_PORT} ${JAVA_SERVER_NAME} ${JAVA_SERVER_PORT2}
