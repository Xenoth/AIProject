#ifndef TP1_FONCTIONSUDP_H
#define TP1_FONCTIONSUDP_H

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <netdb.h>

#include "Definitions.h"

/**
 *
 * @param nPort
 * @return
 */
SOCKET socketUDP(unsigned short nPort);

/**
 *
 * @param nomMachine
 * @param nPort
 * @param addr
 * @return
 */
SOCKET adresseUDP(char *nomMachine, unsigned short nPort, SOCKADDR_IN *adr);



#endif
