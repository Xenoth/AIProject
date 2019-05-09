#ifndef SERVER_H
#define SERVER_H


#include "../../lib/c/SCS-Lib/fonctionsTCP.h"
#include "../../../Ref/validation.h"
#include "../../../Ref/protocolYokai.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
#include <unistd.h>

#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define TIME_MAX 6

void receptReqPartie();
int sendRepPartie();
int jouerPartie();
int receptReqCoup(int joueur);
void inverserJoueur();
void ordreJoueurs();
void closeSock();

#endif
