#ifndef TP1_FONCTIONSTCP_H
#define TP1_FONCTIONSTCP_H

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>

#include "Definitions.h"

/**
 * Create Connexion socket, accepting and
 *
 * @param nPort
 * @return
 */
SOCKET socketServeur(unsigned short nPort);

/**
 *
 * @param nomMachine
 * @param nPort
 * @return
 */
SOCKET socketClient(char *nomMachine, unsigned short nPort);

#endif
