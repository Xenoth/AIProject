// importation des classes utiles à Jasper

import se.sics.jasper.*;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.HashMap;


public class JavaEngine {

    public static void main(String[] args) {

        if(args.length!=1){
            System.err.println("use : port");
            System.exit(-1);
        }

        int port = Integer.parseInt(args[0]);

        ServerSocket srv;
        Socket sockComm;
        InputStream in;
        OutputStream out;
        DataInputStream dis;
        DataOutputStream dos;


        SICStus sp;

        try {

            //lancement du serveur
            srv = new ServerSocket(port);
            sockComm = srv.accept();
            in = sockComm.getInputStream();
            dis = new DataInputStream(in);
            out = sockComm.getOutputStream();
            dos = new DataOutputStream(out);

            // Creation d'un object SICStus
            sp = new SICStus();

            // Chargement d'un fichier prolog .pl
            sp.load("src/prolog/Yokai.pl");

            deroulementPartie(sp,dis,dos);

        }
        // exception déclanchée par SICStus lors de la création de l'objet sp
        catch (SPException e) {
            System.err.println("Exception SICStus Prolog : " + e);
            e.printStackTrace();
            System.exit(-2);
        }
        catch (IOException e) {
            System.err.println("Exception dans la creation de la socket : " + e);
            e.printStackTrace();
            System.exit(-2);
        }

    }

    private static void deroulementPartie(SICStus sp, DataInputStream dis, DataOutputStream dos){

        YokaiJavaEngineProtocol.YJAskNextMoveAnswer nextMoveAnswer;
        YokaiJavaEngineProtocol.YJNewGameRequest newGameRequest;
        YokaiJavaEngineProtocol.YJNewGameAnswer newGameAnswer;
        YokaiJavaEngineProtocol.YJMoveAnswer moveAnswer;
        YokaiJavaEngineProtocol.YJSendPlaceRequest placeRequest;
        YokaiJavaEngineProtocol.YJPlaceAnswer placeAnswer;
        YJPlateau plateau = null;

        int id;

        try {
            do{
                id = dis.readInt();
                switch(YokaiJavaEngineProtocol.YJRequestID.values()[id]){
                    case YJ_NEW_GAME :
                        int sens = dis.readInt();
                        newGameRequest =  new YokaiJavaEngineProtocol.YJNewGameRequest(
                                YokaiJavaEngineProtocol.YJRequestID.values()[id],
                                YokaiJavaEngineProtocol.YJSensPiece.values()[sens]);
                        plateau = new YJPlateau(newGameRequest.sens);
                        newGameAnswer = new YokaiJavaEngineProtocol.YJNewGameAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);

                        sendInitAnswer(dos,newGameAnswer);
                        break;
                    case YJ_SEND_MOVE:
                        int moveType = dis.readInt();
                        if(YokaiJavaEngineProtocol.YJMoveType.values()[moveType] == YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE){//si c'est un movement
                            int fromCol = dis.readInt();
                            int fromLine = dis.readInt();
                            int toCol = dis.readInt();
                            int toLine = dis.readInt();

                            //System.out.println("Received move request from joueur : "+ fromCol + " " + fromLine + " " + toCol + " " + toLine);

                            YokaiJavaEngineProtocol.YJCase from = new YokaiJavaEngineProtocol.YJCase(fromCol,fromLine);
                            YokaiJavaEngineProtocol.YJCase to = new YokaiJavaEngineProtocol.YJCase(toCol,toLine);

                            if(plateau == null){
                                moveAnswer = new YokaiJavaEngineProtocol.YJMoveAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_UNDEFINED);
                                sendMoveAnswer(dos,moveAnswer);
                                System.err.println("Plateau non initialise");
                                System.exit(-2);
                            }
                            String oldPiece = plateau.plateau[fromLine * 5 + fromCol][0];
                            String oldSens = plateau.plateau[fromLine * 5 + fromCol][1];

                            plateau.plateauMove(from,to);

                            plateau.promotionPiece(oldPiece,oldSens,toCol,toLine);
                            //System.out.println("\n\nPIIIIIIIIIECE bougé : " + oldPiece + " devient => " + plateau[toLine * 5 + toCol][0]);

                            moveAnswer = new YokaiJavaEngineProtocol.YJMoveAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);
                            sendMoveAnswer(dos,moveAnswer);

                        }else{ //si c'est un placement
                            int piece = dis.readInt();
                            int sensP = dis.readInt();
                            int cellCol = dis.readInt();
                            int cellLine = dis.readInt();

                            //System.out.println("Received PLACE REQUEST\n");

                            YokaiJavaEngineProtocol.YJCase cell = new YokaiJavaEngineProtocol.YJCase(cellCol, cellLine);

                            placeRequest = new YokaiJavaEngineProtocol.YJSendPlaceRequest(
                                    YokaiJavaEngineProtocol.YJRequestID.values()[id],
                                    YokaiJavaEngineProtocol.YJMoveType.values()[moveType],
                                    YokaiJavaEngineProtocol.YJPiece.values()[piece],
                                    YokaiJavaEngineProtocol.YJSensPiece.values()[sensP],
                                    cell
                            );

                            if(plateau == null){
                                placeAnswer = new YokaiJavaEngineProtocol.YJPlaceAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);
                                sendPlaceAnswer(dos, placeAnswer);
                                System.err.println("Plateau non initialise");
                                System.exit(-2);
                            }
                            plateau.plateauPlace(placeRequest.sens, placeRequest.piece, placeRequest.cell);

                            placeAnswer = new YokaiJavaEngineProtocol.YJPlaceAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);
                            sendPlaceAnswer(dos, placeAnswer);
                        }
                        break;
                    case YJ_ASK_MOVE:
                        if(plateau == null){

                            YokaiJavaEngineProtocol.YJCase from = new YokaiJavaEngineProtocol.YJCase(0, 0);
                            YokaiJavaEngineProtocol.YJCase to = new YokaiJavaEngineProtocol.YJCase(0, 0);
                            nextMoveAnswer = new YokaiJavaEngineProtocol.YJAskNextMoveAnswer(
                                    YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SEND_MOVE,
                                    YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE,
                                    YokaiJavaEngineProtocol.YJPiece.YJ_ONI,
                                    YokaiJavaEngineProtocol.YJSensPiece.YJ_SUD,
                                    0,
                                    from,
                                    to);
                            sendNextCoupAnswer(dos, nextMoveAnswer);
                            System.err.println("Plateau non initialise");
                            System.exit(-2);
                        }
                        nextMoveAnswer = requestProlog(sp, plateau);
                        sendNextCoupAnswer(dos, nextMoveAnswer);
                        break;
                    case YJ_FIN:
                        ByteBuffer buff = ByteBuffer.allocate(4);
                        byte[] b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(convertReturnCode(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS.ordinal())).array();
                        dos.write(b);
                        break;
                }
            }while (YokaiJavaEngineProtocol.YJRequestID.values()[id] != YokaiJavaEngineProtocol.YJRequestID.YJ_FIN);
        }
        catch (IOException e) {
            System.err.println("Exception dans un send ou un recv : " + e);//plus tard fair une exception dans chaque send et recv
            e.printStackTrace();
            System.exit(-2);
        }
    }

    private static void sendInitAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJNewGameAnswer NewGameAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(convertReturnCode(NewGameAnswer.returnCode.ordinal()));
        dos.write(buff.array());
    }

    private static void sendMoveAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJMoveAnswer moveAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(convertReturnCode(moveAnswer.returnCode.ordinal()));
        dos.write(buff.array());

    }

    private static void sendPlaceAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJPlaceAnswer placeAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(convertReturnCode(placeAnswer.returnCode.ordinal()));
        dos.write(buff.array());

    }

    private static void sendNextCoupAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJAskNextMoveAnswer nextMoveAnswer) throws IOException{

        ByteBuffer Buff = ByteBuffer.allocate(36);
        Buff.order(ByteOrder.LITTLE_ENDIAN);
        //Envoi de l'ID de la requetes
        Buff.putInt(convertReturnCode(nextMoveAnswer.returnCode.ordinal()));
        //Envoie du type de movement
        Buff.putInt(nextMoveAnswer.moveType.ordinal());
        //Envoie de la piece
        Buff.putInt(nextMoveAnswer.piece.ordinal());
        //Envoie du sens de la piece
        Buff.putInt(nextMoveAnswer.sens.ordinal());
        //Envoie de si le coup capture ou non une autre pièce
        Buff.putInt(nextMoveAnswer.capture);
        //Envoie de la colonne de départ
        Buff.putInt(nextMoveAnswer.from.Col);
        //Envoie de la ligne de départ
        Buff.putInt(nextMoveAnswer.from.Line);
        //Envoie de la colonne d'arrivee
        Buff.putInt(nextMoveAnswer.to.Col);
        //Envoie de la ligne d'arrivee
        Buff.putInt(nextMoveAnswer.to.Line);
        dos.write(Buff.array());
        /*System.out.println("\tSending return code = " + convertReturnCode(nextMoveAnswer.returnCode.ordinal()));

        ByteBuffer buff = ByteBuffer.allocate(4);
        byte[] b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(convertReturnCode(nextMoveAnswer.returnCode.ordinal())).array();

        dos.write(b);

        System.out.println("\tSending moveType = " + nextMoveAnswer.moveType.ordinal());

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.moveType.ordinal()).array();

        dos.write(b);

        System.out.println("\tSending piece = " + nextMoveAnswer.piece.ordinal());

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.piece.ordinal()).array();

        dos.write(b);

        System.out.println("\tSending sens = " + nextMoveAnswer.sens.ordinal());

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.sens.ordinal()).array();

        dos.write(b);

        System.out.println("\tSending capture = " + nextMoveAnswer.capture);

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.capture).array();

        dos.write(b);

        System.out.println("\tSending fromCol = " + nextMoveAnswer.from.Col);

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.from.Col).array();

        dos.write(b);

        System.out.println("\tSending fromLine = " + nextMoveAnswer.from.Line);

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.from.Line).array();

        dos.write(b);

        System.out.println("\tSending toCol = " + nextMoveAnswer.to.Col);

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.to.Col).array();

        dos.write(b);


        System.out.println("\tSending toLine = " + nextMoveAnswer.to.Line);

        buff = ByteBuffer.allocate(4);
        b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(nextMoveAnswer.to.Line).array();

        dos.write(b);*/


        System.out.println("\tSend move done.");

    }

    private static int convertReturnCode(int returnCode){
        int codeConvert;

        switch(returnCode){
            case -1 : codeConvert=1;
                break;
            case -2 : codeConvert=2;
                break;
            case -3 : codeConvert=3;
                break;
            case -4 : codeConvert=4;
                break;
            case -5 : codeConvert=5;
                break;
            case 1 : codeConvert=-1;
                break;
            case 2 : codeConvert=-2;
                break;
            case 3 : codeConvert=-3;
                break;
            case 4 : codeConvert=-4;
                break;
            case 5 : codeConvert=-5;
                break;
            default : codeConvert = returnCode;
        }

        return codeConvert;
    }

    private static YokaiJavaEngineProtocol.YJAskNextMoveAnswer requestProlog(SICStus sp, YJPlateau plateau){
        //String test1 = plateau.reserveToString(true);
        //String test2 = plateau.reserveToString(false);

        //System.out.println("RESERVE MOI = [" + test1 + "] SIZE OF RESERVE = "+ plateau.reserveMoi.size());
        //System.out.println("RESERVE ADV = [" + test2 + "] SIZE OF RESERVE = "+ plateau.reserveAdv.size());

        //System.out.println("PLATEAU : " + plateau.toString());
        int from=-1;
        int to=-1;
        int gain = Integer.MIN_VALUE;
        // HashMap utilisé pour stocker les solutions
        HashMap results = new HashMap();
        Query qu;

        try {

            // Creation d'une requete (Query) Sicstus
            //   - instanciera results avec les résultats de la requète (from et to)
            qu = sp.openQuery("recuperer_meilleur_coup_v2([" + plateau.toString() + "],moi,From,To,Gain).", results);

            //System.out.println("\t\tTEST1");

            // parcours des solutions
            qu.nextSolution();

            //System.out.println("\t\tTEST2");

            from = Integer.valueOf(results.get("From").toString());
            to = Integer.valueOf(results.get("To").toString());
            gain = Integer.valueOf(results.get("Gain").toString());

            qu.close();

            //System.out.println("\t\tTEST3");

        }catch (SPException e) {
            System.err.println("Exception prolog\n" + e);
        }
        // autres exceptions levées par l'utilisation du Query.nextSolution()
        catch (Exception e) {
            System.err.println("Other exception : " + e);
        }

        String pieceOutput = "";
        int caseToPlaceOutput = -1;
        int valuePlaceOutput = Integer.MIN_VALUE;

        try{
            if(plateau.reserveMoi.size() != 0) {
                String sensInput = "sud";
                if(plateau.getSensActuel() == YokaiJavaEngineProtocol.YJSensPiece.YJ_NORD)
                    sensInput = "nord";

                String listePiecesInput = plateau.reserveToString(true);

                results = new HashMap();

                //System.out.println("\t\tTEST4");

                qu = sp.openQuery("recuperer_meilleur_placement_piece_v1([" + plateau.toString() + "],[" + listePiecesInput + "],moi," + sensInput + ",Piece,CaseToPlace,Value).",results);

                qu.nextSolution();

                pieceOutput = results.get("Piece").toString();
                caseToPlaceOutput = Integer.valueOf(results.get("CaseToPlace").toString());
                valuePlaceOutput = Integer.valueOf(results.get("Value").toString());

                qu.close();

            }

        }
        catch (SPException e) {
            System.err.println("Exception prolog\n" + e);
        }
        // autres exceptions levées par l'utilisation du Query.nextSolution()
        catch (Exception e) {
            System.err.println("Other exception : " + e);
        }
        //System.out.println("\t\tTEST5");

        YokaiJavaEngineProtocol.YJPiece piece = null;
        int capture = 0;
        YokaiJavaEngineProtocol.YJCase caseFrom;
        YokaiJavaEngineProtocol.YJCase caseTo;
        YokaiJavaEngineProtocol.YJMoveType moveType;

        if(valuePlaceOutput == Integer.MIN_VALUE && gain == Integer.MIN_VALUE){ //Ne devrait arriver que si les deux requète prolog plante
            return new YokaiJavaEngineProtocol.YJAskNextMoveAnswer(
                YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SEND_MOVE,
                YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE,
                YokaiJavaEngineProtocol.YJPiece.YJ_ONI,
                plateau.getSensActuel(),
                0,
                plateau.oneDimensionCaseTo2DimensionsCase(0),
                plateau.oneDimensionCaseTo2DimensionsCase(6));
        }
        if(valuePlaceOutput > gain) {
            caseFrom = new YokaiJavaEngineProtocol.YJCase(-1,-1);
            caseTo = plateau.oneDimensionCaseTo2DimensionsCase(caseToPlaceOutput);
            moveType = YokaiJavaEngineProtocol.YJMoveType.YJ_PLACE;
        } else {
            pieceOutput = plateau.plateau[from][0];
            if(!plateau.plateau[to][0].equals("v"))
                capture = 1;
            moveType = YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE;
            caseFrom = plateau.oneDimensionCaseTo2DimensionsCase(from);
            caseTo = plateau.oneDimensionCaseTo2DimensionsCase(to);
        }

        switch(pieceOutput){
                case "oni" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_ONI;
                    break;
                case "kirin" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KIRIN;
                    break;
                case "kodama" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KODAMA;
                    break;
                case "kodama_samourai" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KODAMA_SAMOURAI;
                    break;
                case "koropokkuru" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KOROPOKKURU;
                    break;
                case "super_oni" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_SUPER_ONI;
                    break;
        }

        return new YokaiJavaEngineProtocol.YJAskNextMoveAnswer(
                YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS,
                moveType,
                piece,
                plateau.getSensActuel(),
                capture,
                caseFrom,
                caseTo);

    }
}
