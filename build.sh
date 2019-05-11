#!/bin/bash

SICSTUSJASPERCP=/applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar
SICSTUSLDPATH=/applis/sicstus-4.3.3/lib/

if [[ $# != 2 ]]
then
    echo "usage : build.sh (using default classpath) or build.sh ld_library_path Jasper_classpath"
    echo "default classpath for ld_library_path : /applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar"
    echo "default classpath for jasper : /applis/sicstus-4.3.3/lib/"
fi

if [ ! -z $1 ]
then
    if [[ ! -e $1 ]]
    then
        echo LD library folder not found at \'$1\'
        exit 1
    else
        SICSTUSLDPATH=$1
    fi
fi

if [ ! -z $2 ]
then
    if [[ ! -e $2 ]]
    then
        echo Jasper classpath not found at \'$2\'
        exit 1
    else
       SICSTUSJASPERCP=$2
    fi
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

export LD_LIBRARY_PATH="${SICSTUSLDPATH}"
javac -cp ${SICSTUSJASPERCP} -d build src/main/java/*.java

echo "DONE"
