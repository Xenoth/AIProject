#include <arpa/inet.h>
#include "fonctionsUDP.h"

SOCKET socketUDP(unsigned short nPort)
{

    SOCKET sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) {
        perror("(recepteur) erreur de socket");
        return SOCKET_ERROR;
    }

    SOCKADDR_IN adrRecep;

    adrRecep.sin_family = AF_INET;
    adrRecep.sin_port = htons(nPort);
    adrRecep.sin_addr.s_addr = INADDR_ANY;
    bzero(adrRecep.sin_zero, 8);

    //lose the perky "Address already in use" error message
    int option = 1;
    int res = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &option, sizeof(option));

    if(res < 0)
    {
        fprintf(stderr, "fonctionsUDP::socketUDP:\tUnable to set socket option\n");
        closeSocket(sock);
        return SOCKET_ERROR;
    }

    if (bind(sock, (struct sockaddr *)&adrRecep, (sizeof(SOCKADDR_IN))) < 0)
    {
        fprintf(stderr,"(recepteur) erreur sur le bind\n");
        closeSocket(sock);
        return SOCKET_ERROR;
    }

    return sock;
}

SOCKET adresseUDP(char *nomMachine, unsigned short nPort, SOCKADDR_IN *adr)
{
    adr->sin_family = AF_INET;
    if(inet_aton(nomMachine, &adr->sin_addr) == 0)
    {
        fprintf(stderr, "(emetteur) erreur obtention IP recepteur\n");
        return -1;
    }

    adr->sin_port = htons(nPort);
    bzero(adr->sin_zero, 8);

    return 0;
}
