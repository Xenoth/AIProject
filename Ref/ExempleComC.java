package fr.bailleux.executables;

import java.io.*;
import java.net.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Arrays;

import fr.bailleux.calculus_servus_protocol.*;
import fr.bailleux.calculus_servus_protocol.enums.EnumRequestCode;
import fr.bailleux.calculus_servus_protocol.enums.EnumReturnCode;
import fr.bailleux.calculus_servus_protocol.vo.VOOperationRequest;
import fr.bailleux.calculus_servus_protocol.vo.VORequestAnswer;
import fr.bailleux.utils.RequestHandler;

public class ServeurCalculWithCClient {

    public void runServer() throws IOException {
        ServerSocket serverSocket = new ServerSocket(Definitions.SERVER_PORT);

        while(true) {
            Socket connectionSocket = serverSocket.accept();
            DataInputStream dIn = new DataInputStream(connectionSocket.getInputStream());
            DataOutputStream dOut = new DataOutputStream(connectionSocket.getOutputStream());
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();

            boolean end = false;
            while(!end) {

                // Receiving Data
                int code = dIn.readInt();
                int opr1 = dIn.readInt();
                int opr2 = dIn.readInt();

                System.out.println("{code:" + code + ", opr1:" + opr1 + ", opr2:" + opr2 + "}");

                VOOperationRequest operationRequest= new VOOperationRequest(EnumRequestCode.fromInteger(code), opr1, opr2);

                // Processing Request
                VORequestAnswer answer = RequestHandler.processingRequest(operationRequest);


                // Converting Integers to bytes and changing byte order
                int ansCode = EnumReturnCode.toInteger(answer.code);
                int ansRes = answer.res;

                ByteBuffer buff = ByteBuffer.allocate(4);
                byte[] b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(ansCode).array();

                dOut.write(b);

                buff = ByteBuffer.allocate(4);
                b = buff.order(ByteOrder.LITTLE_ENDIAN).putInt(ansRes).array();

                dOut.write(b);

                end = (operationRequest.getCode() == EnumRequestCode.OP_END);
            }
        }
    }



    public static void main(String[] args) throws Exception {
        new ServeurCalculWithCClient().runServer();
    }

}
