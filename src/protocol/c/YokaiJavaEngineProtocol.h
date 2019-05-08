#ifndef AIPROJECT_YOKAIJAVAPROTOCOL_H
#define AIPROJECT_YOKAIJAVAPROTOCOL_H

typedef enum
{
    YJ_NEW_GAME = 0,
    YJ_SEND_MOVE = 1,
    YJ_ASK_MOVE = 2,
    YJ_STOP = 3,
} YJRequestID;

typedef enum
{
    YJ_ERR_SUCCESS = 0,
    YJ_ERR_NEW_GAME = -1,
    YJ_ERR_SEND_MOVE = -2,
    YJ_ERR_ASK_MOVE = -3,
    YJ_ERR_NOT_YOUR_TURN = -4,
    YJ_ERR_UNDEFINED = -5,
} YJReturnCode;

/*
 * Requete New Game : IDRequete id; SensPiece faction
 */
typedef enum
{
    YJ_NORD = 0,
    YJ_SUD = 1
} YJSensPiece;

typedef struct
{
    YJRequestID id;
    YJSensPiece sens;
} YJNewGameRequest;

/*
 * Reponse New Game : ReturnCode OK | ERROR
 */
typedef struct
{
    YJReturnCode returnCode;
} YJNewGameAnswer;

/*
 * Requete SendMove : IDRequete id; Move or put, ...
 */
typedef enum
{
    YJ_MOVE = 0,
    YJ_PLACE = 1
} YJMoveType;

// From 0 to n - 1
typedef struct
{
    int Col;
    int Line;
} YJCase;

typedef struct
{
    YJRequestID id;
    YJMoveType moveType;
    YJCase from;
    YJCase to;

} YJSendMoveRequest;

typedef struct
{
    YJReturnCode returnCode;
} YJMoveAnswer;

typedef enum
{
    YJ_KODAMA = 0,
    YJ_KODAMA_SAMOURAI = 1,
    YJ_KIRIN = 2,
    YJ_KOROPOKKURU = 3,
    YJ_ONI = 4,
    YJ_SUPER_ONI = 5
} YJPiece;

typedef struct
{
    YJRequestID id;
    YJMoveType moveType;
    YJPiece piece;
    YJSensPiece sens;
    YJCase cell;

} YJSendPlaceRequest;

typedef struct
{
    YJReturnCode returnCode;
} YJPlaceAnswer;

typedef struct
{
    YJRequestID id;
} YJAskNextMoveRequest;

typedef struct
{
    YJReturnCode returnCode;
    YJMoveType moveType;
    YJPiece piece;
    YJSensPiece sens;
    int capture; // capturing opponent piece ? 1 : 0
    YJCase from; // set to -1 value if moveType == YJ_PLACE
    YJCase to;

} YJAskNextMoveAnswer;

typedef struct
{
    YJRequestID id;
} YJSendStop;

typedef struct
{
    YJReturnCode returnCode;
} YJStopAnswer;

int32_t intToInt32bJava(const int something);

int byteArrayJavaToIntC(const char *buff);


#endif
