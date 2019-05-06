#include "JoueurEngine.h"
#include "../../protocol/c/YokaiJavaEngineProtocol.h"

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

    YJNewGameRequest newGameRequest;
    YJNewGameAnswer newGameAnswer;

    YJAskNextMoveRequest askNextMoveRequest;
    YJAskNextMoveAnswer askNextMoveAnswer;

    YJSendMoveRequest sendMoveRequest;
    YJMoveAnswer moveAnswer;

    YJSendPlaceRequest sendPlaceRequest;
    YJPlaceAnswer placeAnswer;

    TCoupReq coupReq;
    TCoupRep coupRep;

    TPartieRep partieRep;

    YJSendStop sendStop;
    YJStopAnswer stopAnswer;


    switch (state->step) {
        case INIT:
            if(sendPartieRequestToServerC(state) < 0)
                return crash(state);

            if (receivePartieAnswerFromServerC(state, &partieRep) < 0)
                return crash(state);

            if(partieRep.validSensTete == OK)
                state->sens = state->desiredSensToStart;
            else
            {
                if(state->desiredSensToStart == NORD)
                    state->sens = SUD;
                else
                    state->sens = NORD;
            }

            printf("Sens joueur : %d\n", state->sens);

            state->step = START_FIRST_GAME;
            break;

        case START_FIRST_GAME:

            newGameRequest.id = YJ_NEW_GAME;

            if(state->sens == NORD)
                newGameRequest.sens = YJ_NORD;

            else
                newGameRequest.sens = YJ_SUD;

            if(sendInitRequestToJavaServer(state, newGameRequest) < 0 )
                return crash(state);

            if(receiveInitAnswerFromJavaServer(state, &newGameAnswer) < 0)
                return crash(state);

            if(newGameAnswer.returnCode != YJ_ERR_SUCCESS)
                return crash(state);

            if(state->sens == SUD)
                state->step = PLAY_TURN;
            else
                state->step = WAIT_TURN;
            break;

        case START_SECOND_GAME:
            state->nbMoves = 0;

            newGameRequest.id = YJ_NEW_GAME;

            if(state->sens == NORD)
                newGameRequest.sens = YJ_NORD;

            else
                newGameRequest.sens = YJ_SUD;

            if (sendInitRequestToJavaServer(state, newGameRequest) < 0)
                return crash(state);

            if(receiveInitAnswerFromJavaServer(state, &newGameAnswer) < 0)
                return crash(state);

            if(newGameAnswer.returnCode != YJ_ERR_SUCCESS)
                return crash(state);

            if(state->sens == SUD)
                state->step = WAIT_TURN;
            else
                state->step = PLAY_TURN;
            break;

        case PLAY_TURN:

            askNextMoveRequest.id = YJ_ASK_MOVE;

            if(askNextCoupToJavaServer(state, askNextMoveRequest) < 0)
                return crash(state);

            if(getNextCoupFromJavaServer(state, &askNextMoveAnswer) < 0)
                return crash(state);

            //TODO handle nextMove potential errors

            coupReq = YJAskNextMoveAnswer2TCoupReq(askNextMoveAnswer, state->nbGames);
            if (sendCoupRequestToServerC(state, coupReq) < 0)
                return crash(state);

            if (receiveCoupAnswerFromServerC(state, &coupRep) < 0)
                return crash(state);

            state->nbMoves++;

            //TODO Handle ohter propCoup ?
            if(coupRep.propCoup != CONT)
            {
                state->step = END_GAME;
                break;
            }

            // TODO For now we only move pieces, no place Request needed
            sendMoveRequest = TCoupReq2YJSendMoveRequest(coupReq);
            if (sendMoveRequestToJavaServer(state, sendMoveRequest) < 0)
                return crash(state);

            if(receiveMoveAnswerFromJavaServer(state, &moveAnswer) < 0)
                return crash(state);

            if(moveAnswer.returnCode != YJ_ERR_SUCCESS)
                return crash(state);

            state->step = WAIT_TURN;
            break;

        case WAIT_TURN:
            if(receiveCoupAnswerFromServerC(state, &coupRep) < 0)
                return crash(state);

            state->nbMoves ++;

            if(coupRep.propCoup != CONT)
            {
                state->step = END_GAME;
                break;
            }

            if (receiveCoupReqFromServerC(state, &coupReq) < 0)
                return crash(state);

            if(coupReq.typeCoup == DEPLACER)
            {
                sendMoveRequest = TCoupReq2YJSendMoveRequest(coupReq);
                if(sendMoveRequestToJavaServer(state, sendMoveRequest) < 0)
                    return crash(state);

                if(receiveMoveAnswerFromJavaServer(state, &moveAnswer) < 0)
                    return crash(state);

                if(moveAnswer.returnCode != YJ_ERR_SUCCESS)
                    return crash(state);

            }
            else
            {
                sendPlaceRequest = TCoupReq2YJSendPlaceRequest(coupReq);
                if(sendPlaceRequestToJavaServer(state, sendPlaceRequest) < 0)
                    return crash(state);

                if(receivePlaceAnswerFromJavaServer(state, &placeAnswer) < 0)
                    return crash(state);

                if(placeAnswer.returnCode != YJ_ERR_SUCCESS)
                    return crash(state);
            }

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
            sendStop.id = YJ_STOP;
            if(sendStopRequestToJavaServer(state, sendStop) < 0)
                return crash(state);

            if(receiveStopAnswerFromJavaServer(state, &stopAnswer) < 0)
                return crash(state);

            if(stopAnswer.returnCode != YJ_ERR_SUCCESS)
                return crash(state);

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

int sendPartieRequestToServerC(JoueurState *state)
{
    TPartieReq partieReq;
    partieReq.piece = state->desiredSensToStart;
    strcpy(partieReq.nomJoueur, state->name);
    partieReq.idReq = PARTIE;

    if (send(state->socketC, &partieReq, sizeof(TPartieReq), 0) <= 0)
        return -1;

    return 0;
}

int receivePartieAnswerFromServerC(JoueurState *state, TPartieRep *partieRep)
{
    if (recv(state->socketC, partieRep, sizeof(TPartieRep), 0) <= 0)
        return -1;

    return 0;
}

int sendCoupRequestToServerC(JoueurState *state, TCoupReq coupReq)
{
    printf("Sending Coup to C Server : Faction %d ,piece:%d (sens %d), from : %d,%d to : %d,%d\n\n", state->sens, coupReq.piece.typePiece, coupReq.piece.sensTetePiece, coupReq.params.deplPiece.caseDep.c, coupReq.params.deplPiece.caseDep.l, coupReq.params.deplPiece.caseArr.c, coupReq.params.deplPiece.caseArr.l);
    if (send(state->socketC, &coupReq, sizeof(TCoupReq), 0) <= 0)
        return -1;

    return 0;
}

int receiveCoupAnswerFromServerC(JoueurState *state, TCoupRep *coupRep)
{
    if (recv(state->socketC, coupRep, sizeof(TCoupRep), 0) <= 0)
        return -1;

    return 0;
}

int receiveCoupReqFromServerC(JoueurState *state, TCoupReq *coupReq)
{
    if (recv(state->socketC, coupReq, sizeof(TCoupReq), 0) <= 0)
        return -1;

    return 0;
}

int sendInitRequestToJavaServer(JoueurState *state, YJNewGameRequest newGameRequest)
{

    printf("Sending init request to Java Server faction %d sens = %d\n", state->sens, newGameRequest.sens);
    int32_t id = intToInt32bJava(newGameRequest.id);
    int32_t faction = intToInt32bJava(newGameRequest.sens);

    if(sendInt32b(state, id) < 0)
        return -1;

    if(sendInt32b(state, faction) < 0)
        return -1;

    return 0;
}

int receiveInitAnswerFromJavaServer(JoueurState *state, YJNewGameAnswer *newGameAnswer)
{
    char buff[4];
    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    newGameAnswer->returnCode = (YJReturnCode)byteArrayJavaToIntC(buff);

    return 0;
}

int sendMoveRequestToJavaServer(JoueurState *state, YJSendMoveRequest sendMoveRequest)
{
    int32_t id = intToInt32bJava(sendMoveRequest.id);
    int32_t move_type = intToInt32bJava(sendMoveRequest.moveType);
    int32_t from_col = intToInt32bJava(sendMoveRequest.from.Col);
    int32_t from_line = intToInt32bJava(sendMoveRequest.from.Line);
    int32_t to_col = intToInt32bJava(sendMoveRequest.to.Col);
    int32_t to_line = intToInt32bJava(sendMoveRequest.to.Line);

    printf("Sending move request to java server : id = %d , moveType = %d, fromCol = %d, fromLine = %d, toCol = %d, toLine = %d\n", id, move_type, from_col, from_line, to_col, to_line);

    if(sendInt32b(state, id) < 0)
        return -1;

    if(sendInt32b(state, move_type) < 0)
        return -1;

    if(sendInt32b(state, from_col) < 0)
        return -1;

    if(sendInt32b(state, from_line) < 0)
        return -1;

    if(sendInt32b(state, to_col) < 0)
        return -1;

    if(sendInt32b(state, to_line) < 0)
        return -1;

    return 0;
}

int receiveMoveAnswerFromJavaServer(JoueurState *state, YJMoveAnswer *moveAnswer)
{
    char buff[4];
    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;

    moveAnswer->returnCode = (YJReturnCode)byteArrayJavaToIntC(buff);

    return 0;
}

int sendPlaceRequestToJavaServer(JoueurState *state, YJSendPlaceRequest sendPlaceRequest)
{
    int32_t id = intToInt32bJava(sendPlaceRequest.id);
    int32_t move_type = intToInt32bJava(sendPlaceRequest.moveType);
    int32_t piece_type = intToInt32bJava(sendPlaceRequest.piece);
    int32_t cell_col = intToInt32bJava(sendPlaceRequest.cell.Col);
    int32_t cell_line = intToInt32bJava(sendPlaceRequest.cell.Line);

    if(sendInt32b(state, id) < 0)
        return -1;

    if(sendInt32b(state, move_type) < 0)
        return -1;

    if(sendInt32b(state, piece_type) < 0)
        return -1;

    if(sendInt32b(state, cell_col) < 0)
        return -1;

    if(sendInt32b(state, cell_line) < 0)
        return -1;

    return 0;
}

int receivePlaceAnswerFromJavaServer(JoueurState *state, YJPlaceAnswer *placeAnswer)
{
    char buff[4];
    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    placeAnswer->returnCode = (YJReturnCode)byteArrayJavaToIntC(buff);

    return 0;
}

int askNextCoupToJavaServer(JoueurState *state, YJAskNextMoveRequest askNextMoveRequest)
{
    int32_t id = intToInt32bJava(askNextMoveRequest.id);

    if(sendInt32b(state, id) < 0)
        return -1;

    return 0;
}

int getNextCoupFromJavaServer(JoueurState *state, YJAskNextMoveAnswer *askNextMoveAnswer)
{
    char buff[4];

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;

    askNextMoveAnswer->returnCode = (YJReturnCode)byteArrayJavaToIntC(buff);

    printf("Received return code = %d\n", askNextMoveAnswer->returnCode);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->moveType = (YJMoveType)byteArrayJavaToIntC(buff);

    printf("Received move type = %d\n", askNextMoveAnswer->moveType);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->piece = (YJPiece)byteArrayJavaToIntC(buff);

    printf("Received piece = %d\n", askNextMoveAnswer->piece);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->sens = byteArrayJavaToIntC(buff);

    printf("Received sens = %d\n", askNextMoveAnswer->sens);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->capture = byteArrayJavaToIntC(buff);

    printf("Received capture = %d\n", askNextMoveAnswer->capture);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->from.Col = byteArrayJavaToIntC(buff);

    printf("Received from Col = %d\n", askNextMoveAnswer->from.Col);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->from.Line = byteArrayJavaToIntC(buff);

    printf("Received from Line = %d\n", askNextMoveAnswer->from.Line);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->to.Col = byteArrayJavaToIntC(buff);

    printf("Received to Col = %d\n", askNextMoveAnswer->to.Col);

    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    askNextMoveAnswer->to.Line = byteArrayJavaToIntC(buff);

    printf("Received to Line = %d\n", askNextMoveAnswer->to.Line);

    return 0;

}

int sendStopRequestToJavaServer(JoueurState *state, YJSendStop sendStop)
{
    int32_t id = intToInt32bJava(sendStop.id);

    if(sendInt32b(state, id) < 0)
        return -1;

    return 0;
}

int receiveStopAnswerFromJavaServer(JoueurState *state, YJStopAnswer *stopAnswer)
{
    char buff[4];
    if(receiveByteBufferFromJavaEngine(state, buff) < 0)
        return -1;
    stopAnswer->returnCode = (YJReturnCode)byteArrayJavaToIntC(buff);

    return 0;
}

int shutdownAndCloseSockets(JoueurState *state)
{
    shutdownSocket(state->socketC);
    shutdownSocket(state->socketJava);
    closeSocket(state->socketJava);
    closeSocket(state->socketC);

    return 0;
}

int crash(JoueurState *state)
{
    state->crashedFromStep = state->step;
    state->step = END_ERROR;
    return -1;
}

int sendInt32b(JoueurState *state, int32_t something)
{
    if (send(state->socketJava, &something, sizeof(int32_t), 0) <= 0)
        return -1;

    return 0;
}

int receiveByteBufferFromJavaEngine(JoueurState *state, char *buff)
{
    int bytesRead = 0;

    while (bytesRead < 4)
    {
        int result = recv(state->socketJava, buff + bytesRead, sizeof(int) - bytesRead, 0);

        if (result <= 0)
        {
            return -1;
        }

        bytesRead += result;
    }

    return 0;
}

TCoupReq YJAskNextMoveAnswer2TCoupReq(YJAskNextMoveAnswer askNextMoveAnswer, uint8_t nbGames)
{
    TCoupReq coupReq;
    coupReq.idRequest = COUP;
    coupReq.typeCoup = DEPLACER;
    coupReq.numPartie = nbGames;
    coupReq.params.deplPiece.estCapt = (askNextMoveAnswer.capture == 1);
    coupReq.params.deplPiece.caseArr.c = (TCol)askNextMoveAnswer.to.Col;
    coupReq.params.deplPiece.caseArr.l = (TLg)askNextMoveAnswer.to.Line;
    coupReq.params.deplPiece.caseDep.c = (TCol)askNextMoveAnswer.from.Col;
    coupReq.params.deplPiece.caseDep.l = (TLg)askNextMoveAnswer.from.Line;
    coupReq.piece.sensTetePiece = (TSensTetePiece)askNextMoveAnswer.sens;

    TTypePiece piece;

    switch (askNextMoveAnswer.piece)
    {
        case YJ_ONI:
            piece = ONI;
            break;
        case YJ_KODAMA:
            piece = KODAMA;
            break;
        case YJ_KODAMA_SAMOURAI:
            piece = KODAMA_SAMOURAI;
            break;
        case YJ_KIRIN:
            piece = KIRIN;
            break;
        case YJ_KOROPOKKURU:
            piece = KOROPOKKURU;
            break;
        case YJ_SUPER_ONI:
            piece = SUPER_ONI;
            break;
    }

    coupReq.piece.typePiece = piece;

    return coupReq;
}

YJSendMoveRequest TCoupReq2YJSendMoveRequest(TCoupReq coupReq)
{
    YJSendMoveRequest sendMoveRequest;
    sendMoveRequest.from.Col = coupReq.params.deplPiece.caseDep.c;
    sendMoveRequest.from.Line = coupReq.params.deplPiece.caseDep.l;
    sendMoveRequest.to.Col = coupReq.params.deplPiece.caseArr.c;
    sendMoveRequest.to.Line = coupReq.params.deplPiece.caseArr.l;

    sendMoveRequest.id = YJ_SEND_MOVE;
    sendMoveRequest.moveType = YJ_MOVE;

    return sendMoveRequest;
}

YJSendPlaceRequest TCoupReq2YJSendPlaceRequest(TCoupReq coupReq)
{
    YJSendPlaceRequest sendPlaceRequest;
    sendPlaceRequest.cell.Col = coupReq.params.deposerPiece.c;
    sendPlaceRequest.cell.Line = coupReq.params.deposerPiece.l;

    sendPlaceRequest.id = YJ_SEND_MOVE;
    sendPlaceRequest.moveType = YJ_PLACE;

    return sendPlaceRequest;
}
