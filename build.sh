#!/bin/bash

SICSTUSJASPERCP=/applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar
SICSTUSLDPATH=/applis/sicstus-4.3.3/lib/

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

export LD_LIBRARY_PATH="${SICSTUSLDPATH}"
javac -cp ${SICSTUSJASPERCP} -d build src/main/java/*.java

echo "DONE"
