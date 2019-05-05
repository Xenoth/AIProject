#!/bin/bash

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
    tar xvf ../../Ref/yokai_v2.tar.gz
    cd ../../
fi


echo "BUILDING C EXECUTABLES..."

# Building Joueur
cd build
cmake ..
make
cd ..

echo "BUILDING JAVA ENGINE..."

export LD_LIBRARY_PATH=$1
javac -cp $2 -d build src/main/java/*.java

echo "DONE"
