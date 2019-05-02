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

        byte[] b = new byte[24];
        ByteBuffer buff = ByteBuffer.wrap(b);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        int id;

        try {
            do{
                dis.read(b);
                id = buff.getInt();
                switch(YokaiJavaEngineProtocol.YJRequestID.values()[id]){
                    case YJ_NEW_GAME :
                        int sens = buff.getInt(4);
                        newGameRequest =  new YokaiJavaEngineProtocol.YJNewGameRequest(
                                YokaiJavaEngineProtocol.YJRequestID.values()[id],
                                YokaiJavaEngineProtocol.YJSensPiece.values()[sens]);
                        plateau = new YokaiJavaEngineProtocol.YJPlateau(newGameRequest.sens);
                        newGameAnswer = new YokaiJavaEngineProtocol.YJNewGameAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);

                        sendInitAnswer(dos,newGameAnswer);
                        break;
                    case YJ_SEND_MOVE:
                        int moveType = buff.getInt(4);
                        if(YokaiJavaEngineProtocol.YJMoveType.values()[moveType] == YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE){//si c'est un movement adverse
                            int fromCol = buff.getInt(8);
                            int fromLine = buff.getInt(12);
                            int toCol = buff.getInt(16);
                            int toLine = buff.getInt(20);
                            YokaiJavaEngineProtocol.YJCase from = new YokaiJavaEngineProtocol.YJCase(fromCol,fromLine);
                            YokaiJavaEngineProtocol.YJCase to = new YokaiJavaEngineProtocol.YJCase(toCol,toLine);

                            /*moveRequest = new YokaiJavaEngineProtocol.YJSendMoveRequest(
                                    YokaiJavaEngineProtocol.YJRequestID.values()[id],
                                    YokaiJavaEngineProtocol.YJMoveType.values()[moveType],
                                    from,
                                    to);*/

                            plateau.plateauMove(from,to);
                            moveAnswer = new YokaiJavaEngineProtocol.YJMoveAnswer(YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS);
                            sendMoveAnswer(dos,moveAnswer);

                        }else{ //si c'est un placement adverse
                            int piece = buff.getInt(8);
                            int cellCol = buff.getInt(12);
                            int cellLine = buff.getInt(16);

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
                }
            }while (YokaiJavaEngineProtocol.YJRequestID.values()[id] == YokaiJavaEngineProtocol.YJRequestID.YJ_FIN);
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
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(convertReturnCode(nextMoveAnswer.returnCode.ordinal()));
        buff.putInt(nextMoveAnswer.moveType.ordinal());
        buff.putInt(nextMoveAnswer.piece.ordinal());
        buff.putInt(nextMoveAnswer.sens.ordinal());
        buff.putInt(nextMoveAnswer.capture);
        buff.putInt(nextMoveAnswer.from.Col);
        buff.putInt(nextMoveAnswer.from.Line);
        buff.putInt(nextMoveAnswer.to.Col);
        buff.putInt(nextMoveAnswer.to.Line);
        dos.write(buff.array());

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

        try {

            // Creation d'une requete (Query) Sicstus
            //   - instanciera results avec les résultats de la requète (from et to)
            Query qu = sp.openQuery("recuperer_meilleur_coup_v1(["+plateau.toString()+"],moi,From,To).",results);

            qu.close();
            // parcours des solutions
            qu.nextSolution();
            int from = (int)results.get("From");
            int to = (int)results.get("To");
            YokaiJavaEngineProtocol.YJPiece piece = null;
            switch(plateau.plateau[from][0]){
                case "oni" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_ONI;
                    break;
                case "kirin" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KIRIN;
                    break;
                case "kodama" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KODAMA;
                    break;
                case "kodamasamourai" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KODAMA_SAMOURAI;
                    break;
                case "koropokkuru" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_KOROPOKKURU;
                    break;
                case "superoni" : piece = YokaiJavaEngineProtocol.YJPiece.YJ_SUPER_ONI;
                    break;
            }
            YokaiJavaEngineProtocol.YJCase caseFrom = plateau.plateauToCase(from);
            YokaiJavaEngineProtocol.YJCase caseTo = plateau.plateauToCase(to);
            plateau.plateauMove(from,to);
            return new YokaiJavaEngineProtocol.YJAskNextMoveAnswer(
                    YokaiJavaEngineProtocol.YJReturnCode.YJ_ERR_SUCCESS,
                    YokaiJavaEngineProtocol.YJMoveType.YJ_MOVE,
                    piece,
                    plateau.getSensActuel(),
                    0,
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

    public static String saisieClavier() {

        // declaration du buffer clavier
        BufferedReader buff = new BufferedReader(new InputStreamReader(System.in));

        try {
            return buff.readLine();
        }
        catch (IOException e) {
            System.err.println("IOException " + e);
            e.printStackTrace();
            System.exit(-1);
        }
        return ("halt.");
    }
}
