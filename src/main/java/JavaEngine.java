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


        SICStus sp = null;

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
        YokaiJavaEngineProtocol.YJPlateau plateau = null;

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
                        plateau = new YokaiJavaEngineProtocol.YJPlateau(newGameRequest.sens);
                        newGameAnswer = new YokaiJavaEngineProtocol.YJNewGameAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);

                        sendInitAnswer(dos,newGameAnswer);
                        break;
                    case YJ_SEND_MOVE:
                        int moveType = dis.readInt();;
                        if(YokaiJavaEngineProtocol.YJMoveType.values()[moveType] == YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE){//si c'est un movement adverse
                            int fromCol = dis.readInt();
                            int fromLine = dis.readInt();
                            int toCol = dis.readInt();
                            int toLine = dis.readInt();

                            System.out.println("Received move request from joueur : "+ fromCol + " " + fromLine + " " + toCol + " " + toLine);

                            YokaiJavaEngineProtocol.YJCase from = new YokaiJavaEngineProtocol.YJCase(fromCol,fromLine);
                            YokaiJavaEngineProtocol.YJCase to = new YokaiJavaEngineProtocol.YJCase(toCol,toLine);

                            /*moveRequest = new YokaiJavaEngineProtocol.YJSendMoveRequest(
                                    YokaiJavaEngineProtocol.YJRequestID.values()[id],
                                    YokaiJavaEngineProtocol.YJMoveType.values()[moveType],
                                    from,
                                    to);*/

                            String oldPiece = plateau.plateau[fromLine * 5 + fromCol][0];
                            String oldSens = plateau.plateau[fromLine * 5 + fromCol][1];

                            plateau.plateauMove(from,to);

                            // promotion a passer en fonction
                            if(oldPiece == "oni" && oldSens == "sud" && toLine > 3)
                                plateau.plateau[toLine * 5 + toCol][0] = "super_oni";

                            else if(oldPiece == "oni" && oldSens == "nord" && toLine < 2)
                              plateau.plateau[toLine * 5 + toCol][0] = "super_oni";

                            else if(oldPiece == "kodama" && (toLine < 2 || toLine > 3))
                                plateau.plateau[toLine * 5 + toCol][0] = "kodama_samourai";

                            System.out.println("\n\nPIIIIIIIIIECE bougé : " + oldPiece + " devient => " + plateau.plateau[toLine * 5 + toCol][0]);

                            moveAnswer = new YokaiJavaEngineProtocol.YJMoveAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);
                            sendMoveAnswer(dos,moveAnswer);

                        }else{ //si c'est un placement adverse
                            int piece = dis.readInt();
                            int cellCol = dis.readInt();
                            int cellLine = dis.readInt();

                            YokaiJavaEngineProtocol.YJCase cell = new YokaiJavaEngineProtocol.YJCase(cellCol, cellLine);

                            placeRequest = new YokaiJavaEngineProtocol.YJSendPlaceRequest(
                                    YokaiJavaEngineProtocol.YJRequestID.values()[id],
                                    YokaiJavaEngineProtocol.YJMoveType.values()[moveType],
                                    YokaiJavaEngineProtocol.YJPiece.values()[piece],
                                    cell
                            );
                        }
                        break;
                    case YJ_ASK_MOVE:
                        nextMoveAnswer = requestProlog(sp, plateau);
                        sendNextCoupAnswer(dos, nextMoveAnswer);
                        break;
                    case YJ_FIN:
                        //Todo put in class and fuction ?
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

    public static void sendInitAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJNewGameAnswer NewGameAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(convertReturnCode(NewGameAnswer.returnCode.ordinal()));
        dos.write(buff.array());
    }

    public static void sendMoveAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJMoveAnswer moveAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(convertReturnCode(moveAnswer.returnCode.ordinal()));
        dos.write(buff.array());

    }

    public static void sendPlaceAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJPlaceAnswer placeAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(convertReturnCode(placeAnswer.returnCode.ordinal()));
        dos.write(buff.array());

    }

    public static void sendNextCoupAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJAskNextMoveAnswer nextMoveAnswer) throws IOException{


        System.out.println("\tSending return code = " + convertReturnCode(nextMoveAnswer.returnCode.ordinal()));

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

        dos.write(b);


        System.out.println("\tSend move done.");

    }

    public static int convertReturnCode(int returnCode){
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

    private static YokaiJavaEngineProtocol.YJAskNextMoveAnswer requestProlog(SICStus sp, YokaiJavaEngineProtocol.YJPlateau plateau){

        // HashMap utilisé pour stocker les solutions
        HashMap results = new HashMap();
        Query qu = null;

        try {

            // Creation d'une requete (Query) Sicstus
            //   - instanciera results avec les résultats de la requète (from et to)
            qu = sp.openQuery("recuperer_meilleur_coup_v2(["+plateau.toString()+"],moi,From,To,Gain).",results);

            // parcours des solutions
            qu.nextSolution();

            int from = Integer.valueOf(results.get("From").toString());
            int to = Integer.valueOf(results.get("To").toString());

            // Utile pour comparer meilleur deplacement piece ou alors deposer piece (plus tard)
            int gain = Integer.valueOf(results.get("Gain").toString());

            qu.close();

            YokaiJavaEngineProtocol.YJPiece piece = null;

            switch(plateau.plateau[from][0]){
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
            YokaiJavaEngineProtocol.YJCase caseFrom = plateau.plateauToCase(from);
            YokaiJavaEngineProtocol.YJCase caseTo = plateau.plateauToCase(to);

            System.out.println("Plateau : " + plateau.toString());

            int capture = 0;
            if(plateau.plateau[to][0] != "v")
              capture = 1;

            return new YokaiJavaEngineProtocol.YJAskNextMoveAnswer(
                    YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS,
                    YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE,
                    piece,
                    plateau.getSensActuel(),
                    capture,
                    caseFrom,
                    caseTo);
        }
        catch (SPException e) {
            System.err.println("Exception prolog\n" + e);
        }
        // autres exceptions levées par l'utilisation du Query.nextSolution()
        catch (Exception e) {
            System.err.println("Other exception : " + e);
        }
        return new YokaiJavaEngineProtocol.YJAskNextMoveAnswer(
                YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SEND_MOVE,
                null,
                null,
                null,
                0,
                null,
                null);
    }
}
