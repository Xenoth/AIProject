#ifndef JOUEURENGINE_H
#define JOUEURENGINE_H

#include <stdint.h>

#include "../../lib/c/SCS-Lib/fonctionsTCP.h"
#include "../../protocol/c/protocolYokai.h"
#include "../../protocol/c/YokaiJavaEngineProtocol.h"


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
int sendPartieRequestToServerC(JoueurState *state);


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
int sendCoupRequestToServerC(JoueurState *state, TCoupReq coupReq);


/**
 *
 * @param state     in/out
 * @param coupRep   out
 * @return
 */
int receiveCoupAnswerFromServerC(JoueurState *state, TCoupRep *coupRep);

/**
 *
 * @param state
 * @param coupReq
 * @return
 */
int receiveCoupReqFromServerC(JoueurState *state, TCoupReq *coupReq);

/**
 *
 * @param state
 * @param newGameRequest
 * @return
 */
int sendInitRequestToJavaServer(JoueurState *state, YJNewGameRequest newGameRequest);

/**
 *
 * @param state
 * @param newGameAnswer
 * @return
 */
int receiveInitAnswerFromJavaServer(JoueurState *state, YJNewGameAnswer *newGameAnswer);

/**
 *
 * @param state
 * @param sendMoveRequest
 * @return
 */
int sendMoveRequestToJavaServer(JoueurState *state, YJSendMoveRequest sendMoveRequest);

/**
 *
 * @param state
 * @param moveAnswer
 * @return
 */
int receiveMoveAnswerFromJavaServer(JoueurState *state, YJMoveAnswer *moveAnswer);

/**
 *
 * @param state
 * @param sendPlaceRequest
 * @return
 */
int sendPlaceRequestToJavaServer(JoueurState *state, YJSendPlaceRequest sendPlaceRequest);

/**
 *
 * @param state
 * @param placeAnswer
 * @return
 */
int receivePlaceAnswerFromJavaServer(JoueurState *state, YJPlaceAnswer *placeAnswer);

/**
 *
 * @param state
 * @param askNextMoveRequest
 * @return
 */
int askNextCoupToJavaServer(JoueurState *state, YJAskNextMoveRequest askNextMoveRequest);

/**
 *
 * @param state
 * @param other
 * @return
 */
int getNextCoupFromJavaServer(JoueurState *state, YJAskNextMoveAnswer *askNextMoveAnswer);

/**
 *
 * @param state     in/out
 * @return
 */
int shutdownAndCloseSockets(JoueurState *state);

int sendInt32b(JoueurState *state, int32_t something);
int receiveByteBufferFromJavaEngine(JoueurState *state, char *buff);

TCoupReq YJAskNextMoveAnswer2TCoupReq(YJAskNextMoveAnswer askNextMoveAnswer, uint8_t nbGames);
YJSendMoveRequest TCoupReq2YJSendMoveRequest(TCoupReq coupReq);
YJSendPlaceRequest TCoupReq2YJSendPlaceRequest(TCoupReq coupReq);

#endif
