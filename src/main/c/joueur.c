// Author : Pol Bailleux
#include "JoueurEngine.h"

#define NAME_JOUEUR "Bailleux-Oberson"

#define SENS_TO_START SUD

#define SERVERS_NAME_SIZE 128

int checkingArgs(int argc, char **argv, char *name_c_server, int *port_c_server, char *name_java_server, int *port_java_server);

int main(int argc, char **argv)
{
    char nameC[SERVERS_NAME_SIZE];
    int portC;
    char nameJava[SERVERS_NAME_SIZE];
    int portJava;

    if(checkingArgs(argc, argv, nameC, &portC, nameJava, &portJava) < 0) {
        fprintf(stderr, "Error while checking args : %s name_c_server port_c_server name_java_server port_java_server", argv[0]);
        exit(EXIT_FAILURE);
    }

    JoueurState state;

    if (initJoueur(&state, NAME_JOUEUR, SENS_TO_START, nameC, (unsigned short)portC, nameJava, (unsigned short)portJava) < 0)
    {
        fprintf(stderr, "Error happened while attempting to init the joueur.\n");
        exit(EXIT_FAILURE);
    }

    while(state.step != DONE && state.step != DONE_ERROR)
    {
        if (updateJoueur(&state) < 0) {
            fprintf(stderr, "Error happened while updating the joueur.\n");
            fprintf(stderr, "crashed from step: %d\n", state.crashedFromStep);
        }
    }

    if(state.step == DONE_ERROR)
        return EXIT_FAILURE;

    return EXIT_SUCCESS;
}

int checkingArgs(int argc, char **argv, char *name_c_server, int *port_c_server, char *name_java_server, int *port_java_server)
{
    if (argc < 5)
        return -1;

    stpcpy(name_c_server, argv[1]);
    stpcpy(name_java_server, argv[3]);
    *port_c_server = atoi(argv[2]);
    *port_java_server = atoi(argv[4]);

    return 0;
}
