import java.io.Serializable;
import java.util.Arrays;
import java.util.ArrayList;

class YokaiJavaEngineProtocol{
    public enum YJRequestID{
        YJ_NEW_GAME,
        YJ_SEND_MOVE,
        YJ_ASK_MOVE,
        YJ_FIN
    }

    public enum YJReturnCode{
        YJ_ERR_SUCCESS,
        YJ_ERR_NEW_GAME,
        YJ_ERR_SEND_MOVE,
        YJ_ERR_ASK_MOVE,
        YJ_ERR_NOT_YOUR_TURN,
        YJ_ERR_UNDEFINED,
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
        YJSensPiece sens;
        YJCase cell;

        public YJSendPlaceRequest(YJRequestID id,YJMoveType moveType, YJPiece piece, YJSensPiece sens, YJCase cell){
            this.id = id;
            this.moveType = moveType;
            this.piece = piece;
            this.sens = sens;
            this.cell = cell;
        }
    }

    public static class YJPlaceAnswer implements Serializable {
        YJReturnCode returnCode;

        public YJPlaceAnswer(YJReturnCode returnCode){
            this.returnCode = returnCode;
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

    public static class YJPlateau implements Serializable{
        String[][] plateau;
        ArrayList<String> reserveMoi;
        ArrayList<String> reserveAdv;
        private YJSensPiece sensActuel;

        public YJPlateau(YJSensPiece sens){
            this.sensActuel = sens;
            if(sensActuel == YJSensPiece.YJ_SUD){
                //plateau initial si on est le nord
                this.plateau = plateauNordInitial();
            }else {
                //plateau initial si on est le sud
                this.plateau = plateauSudInitial();
            }

            reserveMoi = new ArrayList<String>();
            reserveAdv = new ArrayList<String>();
        }

        public YJSensPiece getSensActuel() {
            return sensActuel;
        }

        public YJCase plateauToCase(int numCase){
            return new YJCase(numCase%5,numCase/5);
        }

        public void plateauMove(int from, int to){
            String[] tmp = plateau[to];//à voir ce qu'on fait des pièce capturé, comment les stockés, etc
            plateau[to][0] = plateau[from][0];
            plateau[to][1] = plateau[from][1];
            plateau[to][2] = plateau[from][2];
            plateau[from][0] = "v";
            plateau[from][1] = "none";
            plateau[from][2] = "neutre";
        }

        public void plateauMove(YJCase Cfrom, YJCase Cto){
            int from = Cfrom.Line*5 + Cfrom.Col;
            int to = Cto.Line*5 + Cto.Col;

            String namePieceCapt = plateau[to][0];
            String factionPieceCapt = plateau[to][2];

            if(namePieceCapt != "v") {
              if(namePieceCapt.equals("super_oni"))
                namePieceCapt = "oni";
              else if(namePieceCapt.equals("kodama_samourai"))
                namePieceCapt = "kodama";

              if(factionPieceCapt == "moi")
                reserveAdv.add(namePieceCapt);
              else if(factionPieceCapt == "adv")
                reserveMoi.add(namePieceCapt);
            }

            plateau[to][0] = plateau[from][0];
            plateau[to][1] = plateau[from][1];
            plateau[to][2] = plateau[from][2];
            plateau[from][0] = "v";
            plateau[from][1] = "none";
            plateau[from][2] = "neutre";
        }

        public void plateauPlace(YJSensPiece sens, YJPiece piece, YJCase casePiece) {
            int caseOnPlateau = casePiece.Line*5 + casePiece.Col;

            String sensName = "sud";
            if(sens == YJSensPiece.YJ_NORD)
                sensName = "nord";

            String faction = "moi";
            if(sens != sensActuel)
                faction = "adv";

            String pieceName = "error";
            switch(piece) {
              case YJ_KODAMA:
                pieceName = "kodama";
                break;
              case YJ_KIRIN:
                pieceName = "kirin";
                break;
              case YJ_ONI:
                pieceName = "oni";
                break;
            }

            plateau[caseOnPlateau][0] = pieceName;
            plateau[caseOnPlateau][1] = sensName;
            plateau[caseOnPlateau][2] = faction;

            if(faction.equals("moi")) {
                int index = reserveMoi.indexOf(pieceName);
                reserveMoi.remove(index);
            }

            else if(faction.equals("adv")) {
                int index = reserveAdv.indexOf(pieceName);
                System.out.println("attempting to remove piece to index..." + index + " On " + reserveAdv.toString());
                reserveAdv.remove(index);
            }


        }

        private String[][] plateauNordInitial(){
            return new String[][]{
                    {"oni", "sud", "moi", "0"}, {"kirin", "sud", "moi", "1"}, {"koropokkuru", "sud", "moi", "2"}, {"kirin", "sud", "moi", "3"}, {"oni", "sud", "moi", "4"},
                    {"v", "none", "neutre", "5"}, {"v", "none", "neutre", "6"}, {"v", "none", "neutre", "7"}, {"v", "none", "neutre", "8"}, {"v", "none", "neutre", "9"},
                    {"v", "none", "neutre", "10"}, {"kodama", "sud", "moi", "11"}, {"kodama", "sud", "moi", "12"}, {"kodama", "sud", "moi", "13"}, {"v", "none", "neutre", "14"},
                    {"v", "none", "neutre", "15"}, {"kodama", "nord", "adv", "16"}, {"kodama", "nord", "adv", "17"}, {"kodama", "nord", "adv", "18"}, {"v", "none", "neutre", "19"},
                    {"v", "none", "neutre", "20"}, {"v", "none", "neutre", "21"}, {"v", "none", "neutre", "22"}, {"v", "none", "neutre", "23"}, {"v", "none", "neutre", "24"},
                    {"oni", "nord", "adv", "25"}, {"kirin", "nord", "adv", "26"}, {"koropokkuru", "nord", "adv", "27"}, {"kirin", "nord", "adv", "28"}, {"oni", "nord", "adv", "29"}
            };
        }

        private String[][] plateauSudInitial(){
            return new String[][]{
                    {"oni", "sud", "adv", "0"}, {"kirin", "sud", "adv", "1"}, {"koropokkuru", "sud", "adv", "2"}, {"kirin", "sud", "adv", "3"}, {"oni", "sud", "adv", "4"},
                    {"v", "none", "neutre", "5"}, {"v", "none", "neutre", "6"}, {"v", "none", "neutre", "7"}, {"v", "none", "neutre", "8"}, {"v", "none", "neutre", "9"},
                    {"v", "none", "neutre", "10"}, {"kodama", "sud", "adv", "11"}, {"kodama", "sud", "adv", "12"}, {"kodama", "sud", "adv", "13"}, {"v", "none", "neutre", "14"},
                    {"v", "none", "neutre", "15"}, {"kodama", "nord", "moi", "16"}, {"kodama", "nord", "moi", "17"}, {"kodama", "nord", "moi", "18"}, {"v", "none", "neutre", "19"},
                    {"v", "none", "neutre", "20"}, {"v", "none", "neutre", "21"}, {"v", "none", "neutre", "22"}, {"v", "none", "neutre", "23"}, {"v", "none", "neutre", "24"},
                    {"oni", "nord", "moi", "25"}, {"kirin", "nord", "moi", "26"}, {"koropokkuru", "nord", "moi", "27"}, {"kirin", "nord", "moi", "28"}, {"oni", "nord", "moi", "29"}
            };
        }

        public String toString(){
            String all ="";
            for(int i=0; i<30;i++){
                all += Arrays.asList(plateau[i]).toString();
                if(i != 29){
                    all += ",";
                }
            }
            return all;
        }
    }
}
