// importation des classes utiles à Jasper

import se.sics.jasper.Query;
import se.sics.jasper.SICStus;
import se.sics.jasper.SPException;

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



        }
        // exception déclanchée par SICStus lors de la création de l'objet sp
        catch (SPException e) {
            System.err.println("Exception SICStus Prolog : " + e);
            e.printStackTrace();
            System.exit(-2);
        }
        catch (IOException e) {
            System.err.println("Exception SICStus Prolog : " + e);
            e.printStackTrace();
            System.exit(-2);
        }

    }

    public static YokaiJavaEngineProtocol.YJNewGameRequest recvInitRequest(DataInputStream dis) throws IOException{
        byte[] b = new byte[8];
        dis.read(b);
        ByteBuffer buff = ByteBuffer.wrap(b);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        int id = buff.getInt();
        int sens = buff.getInt();

        return new YokaiJavaEngineProtocol.YJNewGameRequest(
                YokaiJavaEngineProtocol.YJRequestID.values()[id],
                YokaiJavaEngineProtocol.YJSensPiece.values()[sens]);
    }

    public static void sendInitAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJNewGameAnswer NewGameAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(NewGameAnswer.returnCode.ordinal());
        dos.write(buff.array());
    }

    public static YokaiJavaEngineProtocol.YJSendMoveRequest recvMoveRequest(DataInputStream dis) throws IOException{
        byte[] b = new byte[24];
        dis.read(b);
        ByteBuffer buff = ByteBuffer.wrap(b);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        int id = buff.getInt();
        int moveType = buff.getInt(4);
        int fromCol = buff.getInt(8);
        int fromLine = buff.getInt(12);
        int toCol = buff.getInt(16);
        int toLine = buff.getInt(20);

        YokaiJavaEngineProtocol.YJCase from = new YokaiJavaEngineProtocol.YJCase(fromCol,fromLine);
        YokaiJavaEngineProtocol.YJCase to = new YokaiJavaEngineProtocol.YJCase(toCol,toLine);

        return new YokaiJavaEngineProtocol.YJSendMoveRequest(
                YokaiJavaEngineProtocol.YJRequestID.values()[id],
                YokaiJavaEngineProtocol.YJMoveType.values()[moveType],
                from,
                to);
    }

    public static void sendMoveAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJMoveAnswer moveAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(moveAnswer.returnCode.ordinal());
        dos.write(buff.array());

    }

    public static YokaiJavaEngineProtocol.YJSendPlaceRequest recvPlaceRequest(DataInputStream dis) throws IOException{
        byte[] b = new byte[20];
        dis.read(b);
        ByteBuffer buff = ByteBuffer.wrap(b);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        int id = buff.getInt();
        int moveType = buff.getInt(4);
        int piece = buff.getInt(8);
        int cellCol = buff.getInt(12);
        int cellLine = buff.getInt(16);

        YokaiJavaEngineProtocol.YJCase cell = new YokaiJavaEngineProtocol.YJCase(cellCol, cellLine);

        return new YokaiJavaEngineProtocol.YJSendPlaceRequest(
                YokaiJavaEngineProtocol.YJRequestID.values()[id],
                YokaiJavaEngineProtocol.YJMoveType.values()[moveType],
                YokaiJavaEngineProtocol.YJPiece.values()[piece],
                cell
        );
    }

    public static void sendPlaceAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJPlaceAnswer placeAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(placeAnswer.returnCode.ordinal());
        dos.write(buff.array());

    }

    public static YokaiJavaEngineProtocol.YJAskNextMoveRequest recvNextCoupRequest(DataInputStream dis) throws IOException{
        byte[] b = new byte[4];
        dis.read(b);
        ByteBuffer buff = ByteBuffer.wrap(b);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        int id = buff.getInt();

        return new YokaiJavaEngineProtocol.YJAskNextMoveRequest(
                YokaiJavaEngineProtocol.YJRequestID.values()[id]
        );
    }

    public static void sendNextCoupAnswer(DataOutputStream dos, YokaiJavaEngineProtocol.YJAskNextMoveAnswer nextMoveAnswer) throws IOException{
        ByteBuffer buff = ByteBuffer.allocate(4);
        buff.order(ByteOrder.LITTLE_ENDIAN);
        buff.putInt(nextMoveAnswer.returnCode.ordinal());
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

    public static void requetProlog(SICStus sp){

        String saisie = new String("");
        // lecture au clavier d'une requète Prolog
        System.out.print("| ?- ");
        saisie = saisieClavier();

        // boucle pour saisir les informations
        while (! saisie.equals("halt.")) {

            // HashMap utilisé pour stocker les solutions
            HashMap results = new HashMap();

            try {

                // Creation d'une requete (Query) Sicstus
                //   - en fonction de la saisie de l'utilisateur
                //   - instanciera results avec les résultats de la requète
                Query qu = sp.openQuery(saisie,results);

                // parcours des solutions
                boolean moreSols = qu.nextSolution();

                // on ne boucle que si la liste des instanciations de variables est non vide
                boolean continuer = !(results.isEmpty());

                while (moreSols && continuer) {

                    // chaque solution est sockée dans un HashMap
                    // sous la forme : VariableProlog -> Valeur
                    System.out.print(results + " ? ");

                    // demande à l'utilisateur de continuer ...
                    saisie = saisieClavier();
                    if (saisie.equals(";")) {
                        // solution suivante --> results contient la nouvelle solution
                        moreSols = qu.nextSolution();
                    }
                    else {
                        continuer = false;
                    }
                }

                if (moreSols) {
                    // soit :
                    //  - il y a encore des solutions et (continuer == false)
                    //  - le prédicat a réussi mais (results.isEmpty() == true)
                    System.out.println("yes");
                }
                else {
                    // soit :
                    //    - on est à la fin des solutions
                    //    - il n'y a pas de solutions (le while n'a pas été exécuté)
                    System.out.println("no");
                }

                // fermeture de la requète
                System.err.println("Fermeture requete");
                qu.close();

            }
            catch (SPException e) {
                System.err.println("Exception prolog\n" + e);
            }
            // autres exceptions levées par l'utilisation du Query.nextSolution()
            catch (Exception e) {
                System.err.println("Other exception : " + e);
            }

            System.out.print("| ?- ");
            // lecture au clavier
            saisie = saisieClavier();
        }
        System.out.println("End of jSicstus");
        System.out.println("Bye bye");
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
