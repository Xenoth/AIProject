#include "JoueurEngine.h"

#define NAME_JOUEUR "Bailleux-Oberson"

#define SENS_TO_START SUD

#define NAME_SERVER_C "0.0.0.0"
#define PORT_SERVER_C 75

#define NAME_SERVER_JAVA "0.0.0.0"
#define PORT_SERVER_JAVA 85

int main(int argc, char **argv)
{
    JoueurState state;

    if (initJoueur(&state, NAME_JOUEUR, SENS_TO_START, NAME_SERVER_C, PORT_SERVER_C, NAME_SERVER_JAVA, PORT_SERVER_JAVA) < 0)
    {
        fprintf(stderr, "Error happened while attempting to init the joueur.\n");
        exit(EXIT_FAILURE);
    }

    while(state.step != DONE && state.step != DONE_ERROR)
    {
        if (updateJoueur(&state) < 0) {
            fprintf(stderr, "Error happened while updating the joueur.\n");
        }
    }

    if(state.step == DONE_ERROR)
        return EXIT_FAILURE;

    return EXIT_SUCCESS;
}
