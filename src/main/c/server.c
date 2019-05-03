/*#include "../../lib/c/SCS-Lib/fonctionsTCP.h"
#include "../../protocol/c/validation.h"
#include "../../protocol/c/protocoleYokai.h"*/
#include "src/lib/c/SCS-Lib/fonctionsTCP.h"
#include "Ref/validation.h"
#include "src/protocol/c/protocoleYokai.h"

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

int ndfs,
	port,
	numPartie,
	firstSend = 0,
	err,
	jG1,
	jG2,
	sock_cont,
	sock_transJ1,
	sock_transJ2, *joueur1, *joueur2;
static fd_set readSet;
char	nomJ1[T_NOM],nomJ2[T_NOM];

struct sockaddr_in nom_transmis;	/* adresse de la socket de transmission */

TPartieReq	parReqJ1, parReqJ2;
TPartieRep	parRepJ1, parRepJ2;
TCoupReq	coupReq;
TCoupRep	coupRep;
socklen_t	size_addr_trans;

int main(int argc, char **argv)
{
    	if (argc != 2) {
    		printf ("usage : serveur no_port\n");
    		return 1;
    	}

    	port = atoi(argv[1]);

    	/*
    	* creation de la socket, protocole TCP
    	*/
    	printf("(serveur) creation de la socket sur %d\n", port);
    	sock_cont = socketServeur(port);
    	if (sock_cont < 0) {
    		perror("serveur : erreur socketServeur");
    		return 1;
    	}
    	/*
    	*  initialisation de la taille de l'adresse d'une socket
    	*/
    	size_addr_trans = sizeof(struct sockaddr_in);
    	/*
    	* attente de connexion
    	*/
    	sock_transJ1 = accept(sock_cont, (struct sockaddr *)&nom_transmis, &size_addr_trans);
    	if (sock_transJ1 < 0) {
    		perror("serveur :  erreur sur accept (sock_transJ1)");
    		close(sock_cont);
    		return 2;
    	}
    	printf("Connexion J1\n");
    	sock_transJ2 = accept(sock_cont,(struct sockaddr *)&nom_transmis, &size_addr_trans);
    	if (sock_transJ2 < 0) {
    		perror("serveur :  erreur sur accept (sock_transJ2)");
    		shutdown(sock_transJ1, SHUT_RDWR); close(sock_transJ1);
    		close(sock_cont);
    		return 3;
    	}
    	printf("Connexion J2\n");
    	FD_ZERO(&readSet);
    	FD_SET(sock_transJ1, &readSet);
    	FD_SET(sock_transJ2, &readSet);
     	ndfs = sizeof(&readSet)*2;

     	//recupération des deux requète partieReq
     	receptReqPartie();
     	//ordre des joueurs
     	if(firstSend == 1){
            joueur1=&sock_transJ1;
            joueur2=&sock_transJ2;
        }else{
            joueur2=&sock_transJ1;
            joueur1=&sock_transJ2;
        }
     	//envoie réponse pour les demande de partie
     	sendRepPartie();

     	//debut première partie
    	printf("-------------------------Début de la 1er partie-------------------------\n");
     	initialiserPartie();
     	jouerPartie();

     	inverserJoueur();

     	//debut deuxième partie
    	printf("-------------------------Début de la 2eme partie-------------------------\n");
     	initialiserPartie();
     	jouerPartie();

     	closeSock();
     	return 0;
}

void receptReqPartie(){
	int recved = 0;
	err = select(ndfs, &readSet, NULL, NULL, NULL);
	if(err<0){closeSock();}
	//Reception de la première requête Partie
	if(FD_ISSET(sock_transJ1,&readSet) != 0){
	    if(firstSend == 0){
	        firstSend = 1;
	    }
        while(recved < sizeof(TPartieReq)){
            err = recv(sock_transJ1, &parReqJ1, sizeof(TPartieReq), 0);
            if (err < 0) {
                perror("serveur: erreur dans la reception (J1 : sock_transJ1)");
                closeSock();
            }
            recved += err;
            printf("recu partie j1 : %d/%ld\n",recved,sizeof(TPartieReq));
        }
    }
	recved = 0;
	//Reception de la deuxième requête Partie
	if(FD_ISSET(sock_transJ2,&readSet) != 0){
	    if(firstSend == 0){
	        firstSend = 2;
	    }
        while(recved < sizeof(TPartieReq)){
            err = recv(sock_transJ2, &parReqJ2, sizeof(TPartieReq), 0);
            if (err < 0 && parReqJ1.idReq == PARTIE) {
                perror("serveur: erreur dans la reception (J2 : sock_transJ2)");
                closeSock();
            }
            recved += err;
            printf("recu partie j2 : %d/%ld\n",recved,sizeof(TPartieReq));
        }
    }
}

int sendRepPartie(){
	//Création des réponses Partie
	if (parReqJ1.idReq != PARTIE || parReqJ2.idReq != PARTIE){
		parRepJ2.nomAdvers[0] = '\0';
		parRepJ2.validSensTete = KO;
		parRepJ1.nomAdvers[0] = '\0';
		parRepJ1.validSensTete = KO;
        parRepJ2.err = ERR_TYP;
        parRepJ1.err = ERR_TYP;
	    if(parReqJ1.idReq != PARTIE){
            parRepJ2.err = ERR_PARTIE;
        }
	    if(parReqJ2.idReq != PARTIE){
            parRepJ1.err = ERR_PARTIE;
        }
	}else{
	    //création reponse j1
		parRepJ1.err = ERR_OK;
		printf("nom J2 : %s\n",parReqJ2.nomJoueur);
		strcpy(nomJ2, parReqJ2.nomJoueur);
		strcpy(parRepJ1.nomAdvers, nomJ2);
		parRepJ1.validSensTete = OK;
	    //création reponse j2
		parRepJ2.err = ERR_OK;
		printf("nom J1 : %s\n",parReqJ1.nomJoueur);
		strcpy(nomJ1, parReqJ1.nomJoueur);
		strcpy(parRepJ2.nomAdvers, nomJ1);
		parRepJ2.validSensTete = KO;
	}

	//Envoie des réponse Partie
	err = send(*joueur1, &parRepJ1, sizeof(TPartieRep),0);
	if (err != sizeof(TPartieRep)){
		perror("Serveur : Erreur sur l'envoie de la réponse de la partie à J1");
		closeSock();
		return 13;
	}
	err = send(*joueur2, &parRepJ2, sizeof(TPartieRep),0);
	if (err != sizeof(TPartieRep)){
		perror("Serveur : Erreur sur l'envoie de la réponse de la partie à J2");
		closeSock();
		return 13;
	}
	return 0;
}

int jouerPartie(){
	//Début de la partie
	bool finPartie = false;
	int joueur = 1;
	while(!finPartie){
		FD_ZERO(&readSet);
		FD_SET(sock_transJ1, &readSet);
		FD_SET(sock_transJ2, &readSet);

		joueur = receptReqCoup(joueur);

		if(coupRep.validCoup == TIMEOUT || coupRep.validCoup == TRICHE || coupRep.propCoup != CONT){
			finPartie = true;
		}
		err=send(*joueur1, &coupRep, sizeof(TCoupRep),0);
		if (err != sizeof(TCoupRep)){
			perror("Serveur : Erreur sur l'envoie de la réponse du coup à J1");
			closeSock();
			return 13;
		}
		err=send(*joueur2, &coupRep, sizeof(TCoupRep),0);
		if (err != sizeof(TCoupRep)){
			perror("Serveur : Erreur sur l'envoie de la réponse du coup à J2");
			closeSock();
			return 13;
		}
		if(!finPartie){
			if(joueur == 2){
				err=send(*joueur2, &coupReq, sizeof(TCoupReq),0);
				if (err != sizeof(TCoupReq)){
					perror("Serveur : Erreur sur l'envoie du coup à J2");
					closeSock();
					return 13;
				}
			}else{
				err=send(*joueur1, &coupReq, sizeof(TCoupReq),0);
				if (err != sizeof(TCoupReq)){
					perror("Serveur : Erreur sur l'envoie du coup à J1");
					closeSock();
					return 13;
				}
			}
		}
	}
	return 0;
}

int receptReqCoup(int joueur){
	bool valide;
	int recved = 0;
	struct timeval timeout = {TIME_MAX,0};
	err = select(ndfs, &readSet, NULL, NULL, &timeout);
	if (err < 0) {
			perror("serveur: erreur dans la selection de la socket (coup)");
			closeSock();
			return 4;
	}else if(err == 0){
			perror("serveur: erreur dans la selection de la socket (timeout)");
			coupRep.err = ERR_COUP;
			coupRep.validCoup = TIMEOUT;
	}
	if(FD_ISSET(*joueur1, &readSet)!=0){
		while(recved < sizeof(TCoupReq)){
			err = recv(*joueur1, &coupReq, sizeof(TCoupReq), 0);
			if (err < 0) {
				perror("serveur: erreur dans la reception (J1)");
				closeSock();
				return 5;
			}
			recved += err;
			printf("recu coup j1 : %d/%ld\n",recved,sizeof(TCoupReq));
		}
		//Validation du coup
		valide = validationCoup(joueur, coupReq, &coupRep.propCoup);
		coupRep.err = ERR_OK;
		if(valide){
			coupRep.validCoup = VALID;
		}else{
			coupRep.validCoup = TRICHE;
		}
		joueur = 2;
	}
	if(FD_ISSET(*joueur2, &readSet)!=0){
		while(recved < sizeof(TCoupReq)){
			err = recv(*joueur2, &coupReq, sizeof(TCoupReq), 0);
			if (err < 0) {
				perror("serveur: erreur dans la reception (J2)");
				closeSock();
				return 5;
			}
			recved += err;
			printf("recu coup j2 : %d/%ld\n",recved,sizeof(TCoupReq));
		}
		//Validation du coup
		valide = validationCoup(joueur, coupReq, &coupRep.propCoup);
	    coupRep.err = ERR_OK;
		if(valide){
			coupRep.validCoup = VALID;
		}else{
			coupRep.validCoup = TRICHE;
		}
		joueur = 1;
	}
	return joueur;
}

void inverserJoueur(){
	int *joueurtmp = joueur1;
	joueur1 = joueur2;
	joueur2 = joueurtmp;
}

void closeSock(){
	shutdown(sock_transJ1, SHUT_RDWR); close(sock_transJ1);
	shutdown(sock_transJ2, SHUT_RDWR); close(sock_transJ2);
	close(sock_cont);
}