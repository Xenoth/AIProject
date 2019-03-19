#include "fonctionsTCP.h"

SOCKET socketServeur(unsigned short nPort)
{
    SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);

    if(sock < 0)
    {
        fprintf(stderr, "fonctionsTCP::socketServeur:\tUnable to create the socket\n");
        return SOCKET_ERROR;

    }

    SOCKADDR_IN adrServ;
    adrServ.sin_family = AF_INET;
    adrServ.sin_addr.s_addr = INADDR_ANY;
    adrServ.sin_port = htons(nPort);
    bzero(adrServ.sin_zero, 8);

    //lose the perky "Address already in use" error message
    int option = 1;
    int res = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));

    if(res < 0)
    {
        fprintf(stderr, "fonctionsTCP::socketServeur:\tUnable to set socket option\n");
        closeSocket(sock);
        return SOCKET_ERROR;
    }


    if (bind(sock, (SOCKADDR *) &adrServ, sizeof(SOCKADDR_IN)) < 0)
    {
        fprintf(stderr, "fonctionsTCP::socketServeur:\tUnable to bind the socket\n");
        closeSocket(sock);
        return SOCKET_ERROR;
    }

    if(listen(sock, 1) < 0)
    {
        fprintf(stderr, "fonctionsTCP::socketServeur: \tError while listen()\n");
        closeSocket(sock);
        return SOCKET_ERROR;
    }

    return sock;
}


SOCKET socketClient(char *nomMachine, unsigned short nPort)
{
    SOCKADDR_IN serv_addr;

    SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);
    if(sock == SOCKET_ERROR)
    {
        fprintf(stderr, "fonctionsTCP::socketClient:\tUnable to create the socket\n");
        return SOCKET_ERROR;
    }

    /*
    int sizeAddr = sizeof();


    server = gethostbyname(nomMachine);
    if (server == NULL)
    {
        fprintf(stderr, "fonctionsTCP::socketClient:\tUnknown host \"%s\"\n", nomMachine);
        closeSocket(sock);
        return SOCKET_ERROR;
    }
    */

    //serv_addr.sin_addr = *(struct in_addr *) server->h_addr;

    serv_addr.sin_family = AF_INET;

    if(inet_aton(nomMachine, &serv_addr.sin_addr) == 0)
    {
        fprintf(stderr, "fonctionsTCP::socketClient:\tUnable to find server from ip\n");
        closeSocket(sock);
        return SOCKET_ERROR;
    }

    serv_addr.sin_port = htons(nPort);
    bzero(serv_addr.sin_zero, 8);

    if (connect(sock,(SOCKADDR *) &serv_addr,sizeof(SOCKADDR_IN)) < 0)
    {
        fprintf(stderr, "fonctionsTCP::socketClient:\tUnable to connect to the server \"%s\"\n", nomMachine);
        closeSocket(sock);
        return SOCKET_ERROR;
    }

    return sock;
}

