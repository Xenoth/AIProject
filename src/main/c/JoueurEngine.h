#ifndef JOUEURENGINE_H
#define JOUEURENGINE_H

#include <stdint.h>

#include "../../lib/c/SCS-Lib/fonctionsTCP.h"
#include "../../protocol/c/protocolYokai.h"

#define NAME_SIZE 30

enum JoueurStep_type {
    INIT = 1,
    START_FIRST_GAME = 2,
    START_SECOND_GAME = 3,
    PLAY_TURN = 4,
    WAIT_TURN = 5,
    END_GAME = 6,
    END = 7,
    END_ERROR = -1,
    DONE = 8,
    DONE_ERROR = -2,
};


struct t_joueur_state {

    enum JoueurStep_type step;

    char *name;

    TSensTetePiece desiredSensToStart;
    TSensTetePiece sens;

    uint8_t nbMoves;
    uint8_t nbGames;

    SOCKET socketC;
    SOCKET socketJava;
};

typedef struct t_joueur_state JoueurState;
/**
 *
 * @param state                 out
 * @param name                  in
 * @param desiredSensToStart    in
 * @param nameServerC           in
 * @param portServerC           in
 * @param nameServerJava        in
 * @param portServerJava        in
 * @return
 */
int initJoueur(JoueurState *state, char *name, TSensTetePiece desiredSensToStart, char *nameServerC, unsigned short portServerC, char *nameServerJava, unsigned short portServerJava);

/**
 *
 * @param state     in/out
 * @return
 */
int updateJoueur(JoueurState *state);

/**
 *
 * @param state             in/out
 * @param nameServerC       in
 * @param portServerC       in
 * @param nameServerJava    in
 * @param portServerJava    in
 * @return
 */
int connectToServers(JoueurState *state, char *nameServerC, unsigned short portServerC, char *nameServerJava, unsigned short portServerJava);

/**
 * @param state     in
 * @return
 */
int sendPartieRequestToServerC(JoueurState state);

/**
 *
 * @param state     in/out
 * @param partieRep    out
 * @return
 */
int receivePartieAnswerFromServerC(JoueurState *state, TPartieRep *partieRep);

/**
 *
 * @param state     in
 * @param coupReq   in
 * @return
 */
int sendCoupRequestToServerC(JoueurState state, TCoupReq coupReq);

/**
 *
 * @param state     in/out
 * @param coupRep   out
 * @return
 */
int receiveCoupAnswerFromServerC(JoueurState *state, TCoupRep *coupRep);

// TODO
int sendInitRequestToJavaServer(JoueurState state, int other);
// TODO
int sendCoupToJavaServer(JoueurState state, int other);

/**
 *
 * @param state     in/out
 * @return
 */
int shutdownAndCloseSockets(JoueurState *state);

#endif
