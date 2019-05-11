# AIProject
AI project for semester 8 at the Universitée de Franche Comté during IT Master.

## Requires
* Cmake 2.6.1 : If you have issues edit de file CMakeLists.txt to match your version.
* SICStus-Prolog
## Build
default SICSTUSJASPERCP=/applis/sicstus-4.3.3/lib/sicstus-4.3.3/bin/jasper.jar
        SICSTUSLDPATH=/applis/sicstus-4.3.3/lib/

To build the the executables run :
```
bash build.sh (+optional SICSTUSLDPATH SICSTUSJASPERPATH)
```
If you encounter an error change SICSTUSJASPERCP and SICSTUSLDPATH to match your SICStus installation.

## Run
For tournament, for example if the Arbitrator Server is on IP 0.0.0.0 at port 1065 run :
```
bash runJoueur.sh 0.0.0.0 1065 (+optional SICSTUSLDPATH SICSTUSJASPERPATH)
```
For run the server :
bash runServeur 1065
# Authors
* Pol Bailleux
* Quentin Oberson 
