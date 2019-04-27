import java.io.Serializable;

class YokaiJavaEngineProtocol{
    public enum YJRequestID{
        YJ_NEW_GAME,
        YJ_SEND_MOVE,
        YJ_ASK_MOVE,
        YJ_REQUEST_ID_C_LIMITATION_MAKE_ENUM_32_BIT
    }

    public enum YJReturnCode{
        YJ_ERR_SUCCESS,
        YJ_ERR_NEW_GAME,
        YJ_ERR_SEND_MOVE,
        YJ_ERR_ASK_MOVE,
        YJ_ERR_NOT_YOUR_TURN,
        YJ_ERR_UNDEFINED,
        YJ_REQUEST_ID_C_LIMITATION_MAKE_ENUM_32_BIT
    }

    public enum YJSensPiece{
        YJ_NORD,
        YJ_SUD
    }

    public static class YJNewGameRequest implements Serializable{
        YJRequestID id;
        YJSensPiece sens;

        public YJNewGameRequest(YJRequestID id, YJSensPiece sens){
            this.id = id;
            this.sens = sens;
        }
    }

    public static class YJNewGameAnswer implements Serializable {
        YJReturnCode returnCode;

        public YJNewGameAnswer(YJReturnCode returnCode){
            this.returnCode = returnCode;
        }
    }

    public enum YJMoveType{
        YJ_MOVE,
        YJ_PLACE
    }

    public static class YJCase implements Serializable {
        int Col;
        int Line;

        public YJCase(int Col, int Line){
            this.Col = Col;
            this.Line = Line;
        }
    }

    public static class YJSendMoveRequest implements Serializable {
        YJRequestID id;
        YJMoveType moveType;
        YJCase from;
        YJCase to;

        public YJSendMoveRequest(YJRequestID id, YJMoveType moveType, YJCase from, YJCase to){
            this.id = id;
            this.moveType = moveType;
            this.from = from;
            this.to = to;
        }
    }

    public static class YJMoveAnswer implements Serializable {
        YJReturnCode returnCode;

        public YJMoveAnswer(YJReturnCode returnCode){
            this.returnCode = returnCode;
        }
    }

    public enum YJPiece{
        YJ_KODAMA,
        YJ_KODAMA_SAMOURAI,
        YJ_KIRIN,
        YJ_KOROPOKKURU,
        YJ_ONI,
        YJ_SUPER_ONI
    }

    public static class YJSendPlaceRequest implements Serializable {
        YJRequestID id;
        YJMoveType moveType;
        YJPiece piece;
        YJCase cell;

        public YJSendPlaceRequest(YJRequestID id,YJMoveType moveType, YJPiece piece, YJCase cell){
            this.id = id;
            this.moveType = moveType;
            this.piece = piece;
            this.cell = cell;
        }
    }

    public static class YJPlaceAnswer implements Serializable {
        YJReturnCode returnCode;

        public YJPlaceAnswer(YJReturnCode returnCode){
            this.returnCode = returnCode;
        }
    }

    public static class YJAskNextMoveRequest implements Serializable {
        YJRequestID id;

        public YJAskNextMoveRequest(YJRequestID id){
            this.id = id;
        }
    }

    public static class YJAskNextMoveAnswer implements Serializable {
        YJReturnCode returnCode;
        YJMoveType moveType;
        YJPiece piece;
        YJSensPiece sens;
        int capture;
        YJCase from;
        YJCase to;

        public YJAskNextMoveAnswer(YJReturnCode returnCode,YJMoveType moveType, YJPiece piece, YJSensPiece sens, int capture, YJCase from, YJCase to){
            this.returnCode = returnCode;
            this.moveType = moveType;
            this.piece = piece;
            this.sens = sens;
            this.capture = capture;
            this.from = from;
            this.to = to;
        }
    }
}