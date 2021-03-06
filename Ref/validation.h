/*
 **********************************************************
 *
 *  Programme : validation.h
 *
 *  ecrit par : FB / VF
 *
 *  resume : entete pour la validation des coups
 *
 *  date :      25 / 02 / 19
 *  modifie :
 ***********************************************************
 */

#ifndef AIPROJECT_VALIDATION_H
#define AIPROJECT_VALIDATION_H

#include "protocolYokai.h"

/* Validation d'un coup :
 * parametres :
 *    le numero du joueur courant : 1 (le premier qui a commence a jouer) ou
 *                                  2 (le deuxieme)
 *    le coup (TCoupReq)
 * resultat : type bool (coup valide ou non)
 *            propriete du coup  (GAGNE, PERDU, NUL - le coup rend le joueur gagnant, perdant ou la partie est nulle, ou CONT si aucune des autres)
*/

bool validationCoup(int joueur, TCoupReq coup, TPropCoup* propCoup);

/* Initialiser une partie : au cas d'une fin de partie (gagnee, perdue ou nulle), informer du demarrage d'une nouvelle partie */

void initialiserPartie();

#endif
