#include "JoueurEngine.h"

int initJoueur(JoueurState *state, char *name, TSensTetePiece desiredSensToStart, char *nameServerC, unsigned short portServerC, char *nameServerJava,
               unsigned short portServerJava)
{
    if(connectToServers(state, nameServerC, portServerC, nameServerJava, portServerJava) < 0)
        return -1;

    state->name = name;
    state->nbGames = 0;
    state->nbMoves = 0;
    state->desiredSensToStart = desiredSensToStart;
    state->step = INIT;

    return 0;
}

int updateJoueur(JoueurState *state)
{
    switch (state->step) {
        case INIT:
            sendPartieRequestToServerC(state);
            TPartieRep partieRep;
            if (receivePartieAnswerFromServerC(state, &partieRep) < 0)
            {
                state->step = END_ERROR;
                return -1;
            }
            if(partieRep.validSensTete == 0K)
                state->sens = state->desiredSensToStart;
            else
                (state->desiredSensToStart == NORD? state->sens = SUD: state->sens = NORD);

            state->step = START_FIRST_GAME;
            break;

        case START_FIRST_GAME:
            if(state->sens == SUD)
                state->step = PLAY_TURN;
            else
                state->step = WAIT_TURN;
            break;

        case START_SECOND_GAME:
            state->nbMoves = 0;
            if(state->sens == SUD)
                state->step = WAIT_TURN;
            else
                state->step = PLAY_TURN;
            break;

        case PLAY_TURN:

            // Ask nextCoup from Java Engine

            // Default here
            TCoupReq coupReq;
            if (sendCoupRequestToServerC(state, coupReq) < 0)
            {
                state->step = END_ERROR;
                return -1;
            }
            TCoupRep coupRep;
            if (receiveCoupAnswerFromServerC(state, &coupRep) < 0)
            {
                state->step = END_ERROR;
                return -1;
            }

            state->nbMoves++;

            //TODO Handle ohter propCoup ?
            if(coupRep.propCoup != CONT)
                state->step = END_GAME;
            // Send Coup to Java Engine

            state->step = WAIT_TURN;
            break;

        case WAIT_TURN:
            TCoupRep coupRep;
            if(receiveCoupAnswerFromServerC(state, &coupRep) < 0)
            {
                state->step = END_ERROR;
                return -1;
            }
            state->nbMoves ++;

            // Send opponent coup to Java Engine

            if(coupRep.propCoup != CONT)
                state->step = END_GAME;

            state->step = PLAY_TURN;

            break;

        case END_GAME:
            if(state->nbGames == 0)
                state->step = START_SECOND_GAME;
            else
                state->step = END;
            state->nbGames++;
            break;

        case END:
            shutdownAndCloseSockets(state);
            state->step = DONE;
            break;

        case END_ERROR:
            shutdownAndCloseSockets(state);
            fprintf(stderr, "JoueurEngine::Error happened, Aborting execution.\n");
            state->step = DONE_ERROR;
            break;

        case DONE_ERROR:
            break;
        case DONE:
            break;
        default:
            return -1;
    }

    return 0;
}

int connectToServers(JoueurState *state, char *nameServerC, unsigned short portServerC, char *nameServerJava, unsigned short portServerJava)
{
    state->socketC = socketClient(nameServerC, portServerC);
    if (state->socketC == SOCKET_ERROR)
        return -1;

    state->socketJava = socketClient(nameServerJava, portServerJava);
    if (state->socketJava == SOCKET_ERROR)
    {
        shutdownSocket(state->socketC);
        closeSocket(state->socketC);
        return -1;
    }
    return 0;
}

int sendPartieRequestToServerC(JoueurState state)
{
    TPartieReq partieReq;
    partieReq.piece = state.desiredSensToStart;
    partieReq.nomJoueur = state.name;
    partieReq.idReq = PARTIE;

    if (send(state.socketC, &partieReq, sizeof(TPartieReq), 0) <= 0)
        return -1;

    return 0;
}

int receivePartieAnswerFromServerC(JoueurState *state, TPartieRep *partieRep)
{
    return -1;
}

int sendCoupRequestToServerC(JoueurState state, TCoupReq coupReq)
{
    return -1;
}

int receiveCoupAnswerFromServerC(JoueurState *state, TCoupRep *coupRep)
{
    return -1;
}

int sendInitRequestToJavaServer(JoueurState state, int other)
{
    return -1;
}

int sendCoupToJavaServer(JoueurState state, int other)
{
    return -1;
}

int shutdownAndCloseSockets(JoueurState *state)
{
    return -1;
}