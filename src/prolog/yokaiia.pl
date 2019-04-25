%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Projet:                                                 %
%       Tournoi d'intelligence artificielle (2018 - 2019)   %
%   Auteurs :                                               %
%       PIU Pierre-Alexandre                                %
%       Bailleux Paola                                      %
%   Fichier :                                               %
%       yokaiia.pl                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% librairies
:-use_module(library(plunit)).
:-use_module(library(lists)).

% Prédicat
% Nom : valeurPiece(PION, R)
% Utilité : savoir la valeur d'un pion
% Retourne : valeur d'une pièce du jeu
valeurPiece(vide, 0).

valeurPiece(kodamaAdv, 10).
valeurPiece(oniAdv, 35).
valeurPiece(kodamasamouraiAdv, 50).
valeurPiece(onisuperAdv, 50).
valeurPiece(kirinAdv, 70).
valeurPiece(koropokkuruAdv, 1000).

valeurPiece(kodamaMoi, -10).
valeurPiece(oniMoi, -35).
valeurPiece(kodamasamouraiMoi, -50).
valeurPiece(onisuperMoi, -50).
valeurPiece(kirinMoi, -70).
valeurPiece(koropokkuruMoi, -1000).


% Prédicat
% Nom : coordCorrect([X,Y])
% Utilité : savoir si une coordonnée est correcte (équivalente à une case du tableau)
% Retourne : si la coordonnée passé en paramètre est correcte
coordCorrect([X,Y]) :-
    X > -1,
    X < 5,
    Y > -1,
    Y < 6.

% Prédicat
% Nom : deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], PIECE)
% Utilité : savoir si le mouvent d'une pièce d'une position de départ à une autre est possible (on ne s'occupe pas ici de savoir si elle est occupé ou non)
% Retourne : si le mouvent passé en paramètre est correcte pour la pièce indiqué
deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamaAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamaAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiAdv) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiAdv) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiAdv) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiAdv) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamaMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamaMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiMoi) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiMoi) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,kodamasamouraiMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiMoi) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiMoi) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,kodamasamouraiMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinMoi) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinMoi) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinMoi) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinMoi) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).


deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinAdv) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinAdv) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, kirinAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinAdv) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinAdv) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, kirinAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,oniMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,oniMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,oniMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,oniMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,oniMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,oniMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,oniMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,oniMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,oniMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,oniMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperMoi) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperMoi) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperMoi) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperMoi) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, oniAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, oniAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, oniAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, oniAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud, oniAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, oniAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, oniAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord, oniAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,oniAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,oniAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperAdv) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperAdv) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetesud,onisuperAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperAdv) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperAdv) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], tetenord,onisuperAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruMoi) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY + 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY,
    TOX is FROMX - 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY,
    TOX is FROMX + 1,
    coordCorrect([TOX,TOY]).

deplacementCorrectPiece([FROMX,FROMY], [TOX,TOY], _,koropokkuruAdv) :-
    TOY is FROMY - 1,
    TOX is FROMX,
    coordCorrect([TOX,TOY]).


% Prédicat
% Nom : pieceACoord(PLATEAU,[X,Y], PIECE)
% Utilité : connaître la pièce qui présente sur une case du plateau
% Retourne : pièce au coordonnée (x,y)
pieceACoord([], _, vide):- !.

pieceACoord([[X,Y, _,PIECE] | _], [X,Y], PIECE):- !.

pieceACoord([_| L], [X,Y], PIECE):-
    pieceACoord(L, [X,Y], PIECE).

% Prédicat
% Nom : deplacementPieceAvecGain(PLATEAU,[XFROM,YFROM, PIECEFROM], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN])
% Utilité : savoir s'il est possible de se déplacer d'une coordonné à une autre et connaître la pièce présente sur la coordonnée de destination
% Retourne : retourne la pièce associé à la case où l'on souhaite se déplacer
deplacementPieceAvecGain(PLATEAU, [FROMX,2,tetenord,oniMoi], [FROMX,2,oniMoi,TOX,1,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 2], [TOX, 1], tetenord,oniMoi),
    pieceACoord(PLATEAU,[TOX,1], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 65.

deplacementPieceAvecGain(PLATEAU, [FROMX,1,tetenord,oniMoi], [FROMX,1,oniMoi,TOX,0,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 1], [TOX, 0], tetenord,oniMoi),
    pieceACoord(PLATEAU,[TOX,0], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 65.

deplacementPieceAvecGain(PLATEAU, [FROMX,2,tetenord,kodamaMoi], [FROMX,2,kodamaMoi,TOX,1,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 2], [TOX, 1], tetenord,kodamaMoi),
    pieceACoord(PLATEAU,[TOX,1], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 90.

deplacementPieceAvecGain(PLATEAU, [FROMX,1,tetenord,kodamaMoi], [FROMX,1,kodamaMoi,TOX,0,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 1], [TOX, 0], tetenord,kodamaMoi),
    pieceACoord(PLATEAU,[TOX,0], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 90.

deplacementPieceAvecGain(PLATEAU, [FROMX,3,tetesud,oniMoi], [FROMX,3,oniMoi,TOX,4,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 3], [TOX, 4], tetesud,oniMoi),
    pieceACoord(PLATEAU,[TOX,4], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 65.

deplacementPieceAvecGain(PLATEAU, [FROMX,3,tetesud,oniMoi], [FROMX,3,oniMoi,TOX,4,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 3], [TOX, 4], tetesud,oniMoi),
    pieceACoord(PLATEAU,[TOX,4], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 65.

deplacementPieceAvecGain(PLATEAU, [FROMX,3,tetesud,kodamaMoi], [FROMX,3,kodamaMoi,TOX,4,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 3], [TOX, 4], tetesud,kodamaMoi),
    pieceACoord(PLATEAU,[TOX,4], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 90.

deplacementPieceAvecGain(PLATEAU, [FROMX,4,tetesud,kodamaMoi], [FROMX,4,kodamaMoi,TOX,5,TOPIECE,GAINTOTAL]):-
    deplacementCorrectPiece([FROMX, 4], [TOX, 5], tetesud,kodamaMoi),
    pieceACoord(PLATEAU,[TOX,5], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0,
    GAINTOTAL is GAIN + 90.

deplacementPieceAvecGain(PLATEAU, [FROMX,FROMY,TETESENS,FROMPIECE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]):-
    deplacementCorrectPiece([FROMX, FROMY], [TOX, TOY], TETESENS,FROMPIECE),
    pieceACoord(PLATEAU,[TOX,TOY], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN >= 0.


% Prédicat
% Nom : recupererDeplacementsPieceAvecGain(PLATEAU, [FROMX,FROMY, FROMPIECE], R)
% Utilité : récupérer tous les coups possible depuis les coordonnées fournies en fonction de la pièce.
% Retourne : retourne tous les coups possible de la pièce
recupererDeplacementsPieceAvecGain(PLATEAU, [FROMX,FROMY, TETESENS,FROMPIECE], R):-
   findall(COUPS, deplacementPieceAvecGain(PLATEAU, [FROMX,FROMY,TETESENS,FROMPIECE], COUPS), R).

% Prédicat
% Nom : recupererMeilleurDeplacementV1(LISTEDECOUPS, COURMEILLEURSRESULTAT, MEILLEURRESULTAT)
% Utilité : récupérer le meilleur coup dans une liste de coup
% Retourne : retourne le coup à jouer v1

recupererMeilleurDeplacementV1([], COURMEILLEURCOUP, COURMEILLEURCOUP).

recupererMeilleurDeplacementV1([[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,_,_,_,_,COURMEILLEURGAIN],  R) :-
    COURGAIN > COURMEILLEURGAIN,
    recupererMeilleurDeplacementV1(L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], R).

recupererMeilleurDeplacementV1([[_,_,_,_,_,_,COURGAIN] | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    COURMEILLEURGAIN > COURGAIN,
    recupererMeilleurDeplacementV1(L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).

recupererMeilleurDeplacementV1([[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,COURMEILLEURFROMPIECE,_,_,_,COURMEILLEURGAIN],  R) :-
    COURMEILLEURGAIN is COURGAIN,
    valeurPiece(COURFROMPIECE, COURVALEURPIECE),
    valeurPiece(COURMEILLEURFROMPIECE, COURMEILLEURVALEURPIECE),
    COURMEILLEURVALEURPIECE > COURVALEURPIECE,
    recupererMeilleurDeplacementV1(L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], R).

recupererMeilleurDeplacementV1([_ | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    recupererMeilleurDeplacementV1(L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).

% Prédicat
% Nom : estPieceMoi(PLATEAU, PIECEAMOI)
%       recupererPiecesMoi(PLATEAU, PIECESAMOI)
% Utilité : récupérer l'ensemble des pieces qui nous appartiennent sur le plateau
% Retourne : retourne les pièces avec lesquelles nous pouvons jouer
estPieceMoi([[COURX,COURY,TETESENS,COURPIECE]| _], [COURX,COURY,TETESENS,COURPIECE]):-
    valeurPiece(COURPIECE,GAIN),
    0 > GAIN.

estPieceMoi([_| L], R):-
    estPieceMoi(L, R).

recupererPiecesMoi(PLATEAU, R):-
    findall(PIECEMOI, estPieceMoi(PLATEAU, PIECEMOI), R).

% Prédicat
% Nom : recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, ACC, R)
% Utilité : récupérer tous les coups possible de nos pièces qui apporte un gain de minimum +0.
% Retourne : retourne tous les coups possible de nos pièces
recupererDeplacementsPiecesAvecGain(_, [], ACC, ACC):- !.
recupererDeplacementsPiecesAvecGain(PLATEAU, [COURPIECE | L], ACC, R):-
    recupererDeplacementsPieceAvecGain(PLATEAU, COURPIECE, DEPLACEMENTSCOURPIECE),
    append(DEPLACEMENTSCOURPIECE, ACC, NEWACC),
    recupererDeplacementsPiecesAvecGain(PLATEAU, L, NEWACC, R).

% Prédicat
% Nom : recupererCoupV1(PLATEAU, COUPAJOUER)
% Utilité : choisir le coup à jouer dans la version 1 de l'IA
% Retourne : retourne le coup à jouer dans la version 1 de l'IA
recupererCoupV1(PLATEAU, COUPAJOUER):-
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, _, [COURMEILLEUR | AUTRESDEPLACEMENTSPIECES]),
    recupererMeilleurDeplacementV1(AUTRESDEPLACEMENTSPIECES, COURMEILLEUR, COUPAJOUER).

% Prédicat
% Nom : recupererKoropokkuru(PLATEAU, PIECERECHERCHER).
% Utilité : récupérer les coordonnées de notre koropokkuru
% Retourne : Retourne les coordonnées de notre koropokkuru
recupererKoropokkuru([], _):- !, fail.
recupererKoropokkuru([[X,Y, TETESENS,koropokkuruMoi]|_], [X,Y, TETESENS,koropokkuruMoi]).
recupererKoropokkuru([_|L], R):-
    recupererKoropokkuru(L, R).

% Prédicat
% Nom : recupererMonOrientation(PLATEAU, TETESENS).
% Utilité : récupérer mon orientation
% Retourne : Retourne mon orientation
recupererMonOrientation([], _):- !, fail.
recupererMonOrientation([[_,_, TETESENS,_]|_], TETESENS).

% Prédicat
% Nom : dangerPourMaPiece(PLATEAU, MAPIECE, PIECEADVDANGER]):-
%       dangersPourMaPiece(PLATEAU, MESPIECES, PIECESADVDANGER)
% Utilité : savoir si notre piece est en sécurité
% Retourne : Retourne la liste des pièces qui menace notre pièce
dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [X,NEWY,tetesud,PIECEADVDANGER]):-
    NEWY is Y - 1,
    coordCorrect([X, NEWY]),
    pieceACoord(PLATEAU,[X, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 10. %Oni / Kirin / KodamaSamourai / SuperOni / Koropokkuru / Kodama

dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [NEWX,NEWY,tetesud,PIECEADVDANGER]):-
    NEWY is Y - 1,
    NEWX is X - 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [NEWX,NEWY,tetesud,PIECEADVDANGER]):-
    NEWY is Y - 1,
    NEWX is X + 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [NEWX,NEWY,tetesud,PIECEADVDANGER]):-
    NEWY is Y + 1,
    NEWX is X + 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [NEWX,NEWY,tetesud,PIECEADVDANGER]):-
    NEWY is Y + 1,
    NEWX is X - 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [NEWX,Y,tetesud,PIECEADVDANGER]):-
    NEWX is X - 1,
    coordCorrect([NEWX, Y]),
    pieceACoord(PLATEAU,[NEWX, Y], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 50. %Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [NEWX,Y,tetesud,PIECEADVDANGER]):-
    NEWX is X + 1,
    coordCorrect([NEWX, Y]),
    pieceACoord(PLATEAU,[NEWX, Y], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 50. %Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetenord, _], [X,NEWY,tetesud,PIECEADVDANGER]):-
    NEWY is Y + 1,
    coordCorrect([X, NEWY]),
    pieceACoord(PLATEAU,[X, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 50. %Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetesud, _], [X,NEWY,tetenord,PIECEADVDANGER]):-
    NEWY is Y + 1,
    coordCorrect([X, NEWY]),
    pieceACoord(PLATEAU,[X, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 10. %Oni / Kirin / KodamaSamourai / SuperOni / Koropokkuru / Kodama

dangerPourMaPiece(PLATEAU, [X,Y, tetesud, _], [NEWX,NEWY,tetenord,PIECEADVDANGER]):-
    NEWY is Y + 1,
    NEWX is X - 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetesud, _], [NEWX,NEWY,tetenord,PIECEADVDANGER]):-
    NEWY is Y + 1,
    NEWX is X + 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetesud, _], [NEWX,NEWY,tetenord,PIECEADVDANGER]):-
    NEWY is Y - 1,
    NEWX is X + 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetesud, _], [NEWX,NEWY,tetenord,PIECEADVDANGER]):-
    NEWY is Y - 1,
    NEWX is X - 1,
    coordCorrect([NEWX, NEWY]),
    pieceACoord(PLATEAU,[NEWX, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 35. %Oni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetesud,_], [NEWX,Y,tetenord,PIECEADVDANGER]):-
    NEWX is X - 1,
    coordCorrect([NEWX, Y]),
    pieceACoord(PLATEAU,[NEWX, Y], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 50. %Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetesud,_], [NEWX,Y,tetenord,PIECEADVDANGER]):-
    NEWX is X + 1,
    coordCorrect([NEWX, Y]),
    pieceACoord(PLATEAU,[NEWX, Y], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 50. %Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangerPourMaPiece(PLATEAU, [X,Y, tetesud,_], [X,NEWY,tetenord,PIECEADVDANGER]):-
    NEWY is Y - 1,
    coordCorrect([X, NEWY]),
    pieceACoord(PLATEAU,[X, NEWY], PIECEADVDANGER),
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN >= 50. %Kirin / KodamaSamourai / SuperOni / Koropokkuru

dangersPourMaPiece(PLATEAU, MAPIECE, PIECESADVDANGER):-
    findall(PIECEADVDANGER, dangerPourMaPiece(PLATEAU, MAPIECE, PIECEADVDANGER), PIECESADVDANGER).

% Prédicat
% Nom : dangerMinimum(PIECESADVDANGER, CURMINDANGER, R).
% Utilité : savoir quel est la plus petite pièce qui peut me capturer permet de calculer quel est le meilleur coup à jouer à partir de la v2 de l'ia
% Retourne : Retourne la valeur minimale de la pièce qui peut me capturer
dangerMinimum([], CURMINDANGER, CURMINDANGER).

dangerMinimum([[_,_,_,PIECEADVDANGER]| L], CURMINGAIN, R):-
    valeurPiece(PIECEADVDANGER,GAIN),
    CURMINGAIN > GAIN,
    dangerMinimum(L, GAIN,R), !.

dangerMinimum([_| L], GAIN, R):-
    dangerMinimum(L, GAIN,R).

% Prédicat
% Nom : dangerMaximum(PIECESADVDANGER, CURMAXDANGER, R).
% Utilité : savoir quel est la plus petite pièce qui peut me capturer permet de calculer quel est le meilleur coup à jouer à partir de la v2 de l'ia
% Retourne : Retourne la valeur minimale de la pièce qui peut me capturer
dangerMaximum([], CURMAXDANGER, CURMAXDANGER).

dangerMaximum([[_,_,_,PIECEADVDANGER]| L], CURMAXDANGER, R):-
    valeurPiece(PIECEADVDANGER,GAIN),
    GAIN > CURMAXDANGER,
    dangerMinimum(L, GAIN,R), !.

dangerMaximum([_| L], CURMAXDANGER, R):-
    dangerMinimum(L, CURMAXDANGER,R).

% Prédicat
% Nom : recupererListeDeplacementAvecCapture(DEPLACEMENTEBNCOURS, LISTEDEPLACEMENTSPOSSIBLE, ACC, R)
% Utilité : Permet de trié la liste pour ne garder que les déplacements différents de celui dont on réalise l'heuristique + ceux vide
% Retourne : Liste des autres déplacement avec pièces adversaire
recupererListeDeplacementAvecCapture(_, [],ACC, ACC).

recupererListeDeplacementAvecCapture([COURFROMX, COURFROMY, COURFROMPIECE,COURTOX, COURTOY,COURTOPIECE, GAIN], [[_, _, _,COURTOX, COURTOY,COURTOPIECE, GAIN] | L],ACC, R):-
    recupererListeDeplacementAvecCapture([COURFROMX, COURFROMY, COURFROMPIECE,COURTOX, COURTOY,COURTOPIECE, GAIN], L, ACC, R).

recupererListeDeplacementAvecCapture([COURFROMX, COURFROMY, COURFROMPIECE,COURTOX, COURTOY, COURTOPIECE, GAIN], [[_,_,_, _, _, vide, _] | L],ACC, R):-
    recupererListeDeplacementAvecCapture([COURFROMX, COURFROMY, COURFROMPIECE,COURTOX, COURTOY,COURTOPIECE, GAIN], L, ACC, R).

recupererListeDeplacementAvecCapture([COURFROMX, COURFROMY, COURFROMPIECE,COURTOX, COURTOY,COURTOPIECE, GAIN], [CURDEPLACEMENT | L],ACC, R):-
    recupererListeDeplacementAvecCapture([COURFROMX, COURFROMY, COURFROMPIECE,COURTOX, COURTOY,COURTOPIECE, GAIN], L, [CURDEPLACEMENT | ACC], R).

% Prédicat
% Nom : recupererPiecesAdvDifDansListeDeplacementAvecCapture(LISTEDEPLACEMENTAVECCAPTURE, ACC, R)
% Utilité : Permet de réucpérer les différentes pièces de l'adversaire que l'on peut capturer
% Retourne : Liste de pièce de l'adversaire
recupererPiecesAdvDifDansListeDeplacementAvecCapture([],ACC, ACC).

recupererPiecesAdvDifDansListeDeplacementAvecCapture([[_,_,_,XADV,YADV,PIECEADV,_] | L ],ACC, R):-
    nonmember([XADV, YADV, PIECEADV], ACC),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(L,[[XADV,YADV,PIECEADV]|ACC], R).

recupererPiecesAdvDifDansListeDeplacementAvecCapture([ _ | L ],ACC, R):-
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(L,ACC, R).

% Prédicat
% Nom : deplacementPieceAvecGainPourAdv(PLATEAU, PIECEADV, COUPPOSSIBLEPOURADV)
% Utilité : Permet de réucpérer un coup de l'adversaire avec une de ses pièces qui lui rapporte un gain
% Retourne : Coup de l'adversaire
deplacementPieceAvecGainPourAdv(PLATEAU, [FROMX,FROMY,TETESENS,FROMPIECE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]):-
    deplacementCorrectPiece([FROMX, FROMY], [TOX, TOY], TETESENS,FROMPIECE),
    pieceACoord(PLATEAU,[TOX,TOY], TOPIECE),
    valeurPiece(TOPIECE,GAIN),
    GAIN < 0.


% Prédicat
% Nom : recupererDeplacementsPiecesAdversaireAvecGain(PLATEAU, [FROMX,FROMY, FROMPIECE], R)
% Utilité : récupérer tous les coups possible depuis les coordonnées fournies en fonction de la pièce de l'adversaire.
% Retourne : retourne tous les coups possible de la pièce de l'adversaire
recupererDeplacementsPiecesAdversaireAvecGain(PLATEAU, [FROMX,FROMY, TETESENS,FROMPIECE], R):-
   findall(COUPS, deplacementPieceAvecGainPourAdv(PLATEAU, [FROMX,FROMY,TETESENS,FROMPIECE], COUPS), R).

% Prédicat
% Nom : recupererMeilleurDeplacementPourAdvV1(LISTEDECOUP, MEILLEURCOUP, R)
% Utilité : récupérer le meilleur coup que peux faire l'adversaire depuis une liste de coup
% Retourne : retourne tous le meilleur coup pour l'adversaire
recupererMeilleurDeplacementPourAdvV1([], COURMEILLEURCOUP, COURMEILLEURCOUP).

recupererMeilleurDeplacementPourAdvV1([[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,_,_,_,_,COURMEILLEURGAIN],  R) :-
    COURGAIN < COURMEILLEURGAIN,
    recupererMeilleurDeplacementPourAdvV1(L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], R).

recupererMeilleurDeplacementPourAdvV1([[_,_,_,_,_,_,COURGAIN] | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    COURMEILLEURGAIN < COURGAIN,
    recupererMeilleurDeplacementPourAdvV1(L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).

recupererMeilleurDeplacementPourAdvV1([[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,COURMEILLEURFROMPIECE,_,_,_,COURMEILLEURGAIN],  R) :-
    COURMEILLEURGAIN is COURGAIN,
    valeurPiece(COURFROMPIECE, COURVALEURPIECE),
    valeurPiece(COURMEILLEURFROMPIECE, COURMEILLEURVALEURPIECE),
    COURMEILLEURVALEURPIECE > COURVALEURPIECE,
    recupererMeilleurDeplacementPourAdvV1(L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], R).

recupererMeilleurDeplacementPourAdvV1([_ | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    recupererMeilleurDeplacementPourAdvV1(L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).

% Prédicat
% Nom : sommeDesDangers(PLATEAU, TETESENSADV, LISTEPIECEADV, ACC, R))
% Utilité : récupérer le meilleur coup des pièces et ajouter le gain gagné à la somme max des dangers
% Retourne : retourne tous le meilleur coup pour l'adversairesommeDesDangers(_, _,[], ACC, ACC).
sommeDesDangers(_, _,[], ACC, ACC).
sommeDesDangers(PLATEAU, TETESENSADV, [[XADV,YADV, PIECEADV] | L], ACC, R):-
    recupererDeplacementsPieceAdversaireAvecGain(PLATEAU, [XADV,YADV, TETESENSADV,PIECEADV], [COURMEILLEUR | AUTRESDEPLACEMENTSPIECES]),
    recupererMeilleurDeplacementPourAdvV1(AUTRESDEPLACEMENTSPIECES, COURMEILLEUR, [_,_,_,_,_,_,GAINMAX]),
    NEWACC is ACC + GAINMAX,
    sommeDesDangers(PLATEAU, TETESENSADV, L, NEWACC, R).


% Prédicat
% Nom : heurisitqueV2(PLATEAU, COURGAIN, MAPIECE, HEURISTIQUE)
% Utilité : récupérer le résultat de l'heuristiquev2 :
%           - On récupère les pièces de l'adversaire qui peuvent capturer notre pièce
%           - Si aucune peut la capturer alors on retourne directement le gain associer au coup
%           - Sinon heuristique = GAIN - MAPIECE - DANGERMIN
% Retourne : retourne l'heuristique pour l'ia de version 2
heurisitqueV2(PLATEAU, TETESENS, COURGAIN, [COURTOX,COURTOY,COURFROMPIECE], COURGAIN):-
    dangersPourMaPiece(PLATEAU, [COURTOX,COURTOY,TETESENS,COURFROMPIECE], []).

heurisitqueV2(PLATEAU, TETESENS, COURGAIN, [COURTOX,COURTOY,COURFROMPIECE], HEURISTIQUE):-
    dangersPourMaPiece(PLATEAU, [COURTOX,COURTOY,TETESENS,COURFROMPIECE], PIECESADVDANGER),
    dangerMinimum(PIECESADVDANGER, 200, DANGERMIN),
    valeurPiece(COURFROMPIECE, VALEUR),
    ABSVALEUR is abs(VALEUR),
    HEURISTIQUE is COURGAIN - ABSVALEUR - DANGERMIN.



% Prédicat
% Nom : heurisitqueV3(PLATEAU, COURGAIN, MAPIECE, HEURISTIQUE)
% Utilité : récupérer le résultat de l'heuristiquev3 :
%           - On récupère les pièces de l'adversaire qui peuvent capturer notre pièce
%           - Si aucune peut la capturer alors heuristique = GAIN - SOMMEDESDANGERS
%           - Sinon heuristique = GAIN - MAPIECE - DANGERMIN - SOMMEDESDANGERS
% Retourne : retourne l'heuristique pour l'ia de version 4
heurisitqueV3(PLATEAU, DEPLACEMENTSPOSSIBLES, tetenord, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], HEURISTIQUE):-
    dangersPourMaPiece(PLATEAU, [COURTOX,COURTOY,tetenord,COURFROMPIECE], []),
    recupererListeDeplacementAvecCapture([COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], DEPLACEMENTSPOSSIBLES, [], DEPLACEMENTSAVECAPTURES),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(DEPLACEMENTSAVECAPTURES, [], DEPLACEMENTSADV),
    sommeDesDangers(PLATEAU, tetesud, DEPLACEMENTSADV, 0, SOMMEDESDANGERS),
    HEURISTIQUE is COURGAIN - SOMMEDESDANGERS.

heurisitqueV3(PLATEAU, DEPLACEMENTSPOSSIBLES, tetesud, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], HEURISTIQUE):-
    dangersPourMaPiece(PLATEAU, [COURTOX,COURTOY,tetesud,COURFROMPIECE], []),
    recupererListeDeplacementAvecCapture([COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], DEPLACEMENTSPOSSIBLES, [], DEPLACEMENTSAVECAPTURES),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(DEPLACEMENTSAVECAPTURES, [], DEPLACEMENTSADV),
    sommeDesDangers(PLATEAU, tetenord, DEPLACEMENTSADV, 0, SOMMEDESDANGERS),
    HEURISTIQUE is COURGAIN - SOMMEDESDANGERS.

heurisitqueV3(PLATEAU, DEPLACEMENTSPOSSIBLES, tetenord, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], HEURISTIQUE):-
    dangersPourMaPiece(PLATEAU, [COURTOX,COURTOY,tetenord,COURFROMPIECE], PIECESADVDANGER),
    dangerMinimum(PIECESADVDANGER, 200, DANGERMIN),
    valeurPiece(COURFROMPIECE, VALEUR),
    ABSVALEUR is abs(VALEUR),
    recupererListeDeplacementAvecCapture([COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], DEPLACEMENTSPOSSIBLES, [], DEPLACEMENTSAVECAPTURES),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(DEPLACEMENTSAVECAPTURES, [], DEPLACEMENTSADV),
    sommeDesDangers(PLATEAU, tetesud, DEPLACEMENTSADV, 0, SOMMEDESDANGERS),
    HEURISTIQUE is COURGAIN - ABSVALEUR - DANGERMIN - SOMMEDESDANGERS.

heurisitqueV3(PLATEAU, DEPLACEMENTSPOSSIBLES, tetesud, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], HEURISTIQUE):-
    dangersPourMaPiece(PLATEAU, [COURTOX,COURTOY,tetesud,COURFROMPIECE], PIECESADVDANGER),
    dangerMinimum(PIECESADVDANGER, 200, DANGERMIN),
    valeurPiece(COURFROMPIECE, VALEUR),
    ABSVALEUR is abs(VALEUR),
    recupererListeDeplacementAvecCapture([COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], DEPLACEMENTSPOSSIBLES, [], DEPLACEMENTSAVECAPTURES),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(DEPLACEMENTSAVECAPTURES, [], DEPLACEMENTSADV),
    sommeDesDangers(PLATEAU, tetenord, DEPLACEMENTSADV, 0, SOMMEDESDANGERS),
    HEURISTIQUE is COURGAIN - ABSVALEUR - DANGERMIN - SOMMEDESDANGERS.

% Prédicat
% Nom : recupererMeilleurDeplacementV2(LISTEDECOUPS, COURMEILLEURSRESULTAT, MEILLEURRESULTAT)
% Utilité : récupérer le meilleur coup dans une liste de coup en fonction de l'heuristiquev2
% Retourne : retourne le coup à jouer v2
recupererMeilleurDeplacementV2(_, _, [], COURMEILLEURCOUP, COURMEILLEURCOUP).

recupererMeilleurDeplacementV2(_, _, [[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,koropokkuruAdv,COURGAIN] | _], _,  [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,koropokkuruAdv,COURGAIN]).

recupererMeilleurDeplacementV2(PLATEAU, TETESENS, [[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,_,_,_,_,COURMEILLEURGAIN],  R) :-
    heurisitqueV2(PLATEAU, TETESENS, COURGAIN, [COURTOX,COURTOY,COURFROMPIECE], HEURISTIQUE),
    HEURISTIQUE > COURMEILLEURGAIN,
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,HEURISTIQUE], R).

recupererMeilleurDeplacementV2(PLATEAU, TETESENS, [[_,_,COURFROMPIECE,COURTOX,COURTOY,_,COURGAIN] | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    heurisitqueV2(PLATEAU, TETESENS, COURGAIN, [COURTOX,COURTOY,COURFROMPIECE], HEURISTIQUE),
    COURMEILLEURGAIN > HEURISTIQUE,
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).

recupererMeilleurDeplacementV2(PLATEAU, TETESENS, [[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,COURMEILLEURFROMPIECE,_,_,_,COURMEILLEURGAIN],  R) :-
    heurisitqueV2(PLATEAU, TETESENS, COURGAIN, [COURTOX,COURTOY,COURFROMPIECE], HEURISTIQUE),
    COURMEILLEURGAIN is HEURISTIQUE,
    valeurPiece(COURFROMPIECE, COURVALEURPIECE),
    valeurPiece(COURMEILLEURFROMPIECE, COURMEILLEURVALEURPIECE),
    COURMEILLEURVALEURPIECE > COURVALEURPIECE,
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], R).

recupererMeilleurDeplacementV2(PLATEAU, TETESENS, [_ | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).

% Prédicat
% Nom : recupererMeilleurDeplacementV2(LISTEDECOUPS, COURMEILLEURSRESULTAT, MEILLEURRESULTAT)
% Utilité : récupérer le meilleur coup dans une liste de coup en fonction de l'heuristiquev3
% Retourne : retourne le coup à jouer v4
recupererMeilleurDeplacementV3(_, _, _,[], COURMEILLEURCOUP, COURMEILLEURCOUP).

recupererMeilleurDeplacementV3(_, _, _,[[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,koropokkuruAdv,COURGAIN] | _], _,  [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,koropokkuruAdv,COURGAIN]).

recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,_,_,_,_,COURMEILLEURGAIN],  R) :-
    heurisitqueV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], HEURISTIQUE),
    HEURISTIQUE > COURMEILLEURGAIN,
    recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,HEURISTIQUE], R).

recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    heurisitqueV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], HEURISTIQUE),
    COURMEILLEURGAIN > HEURISTIQUE,
    recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).

recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [[COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN] | L], [_,_,COURMEILLEURFROMPIECE,_,_,_,COURMEILLEURGAIN],  R) :-
    heurisitqueV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], HEURISTIQUE),
    COURMEILLEURGAIN is HEURISTIQUE,
    valeurPiece(COURFROMPIECE, COURVALEURPIECE),
    valeurPiece(COURMEILLEURFROMPIECE, COURMEILLEURVALEURPIECE),
    COURMEILLEURVALEURPIECE > COURVALEURPIECE,
    recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, L, [COURFROMX,COURFROMY,COURFROMPIECE,COURTOX,COURTOY,COURTOPIECE,COURGAIN], R).

recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [_ | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
    recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, L, [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN], R).


% Prédicat
% Nom : recupererCoupV2(PLATEAU, COUPAJOUER)
% Utilité : choisir le coup à jouer dans la version 2 de l'IA
%           On prend désormais en compte le coup joué par l'adversaire en retour (Basé sur le Min/Max)
% Retourne : retourne le coup à jouer dans la version 2 de l'IA
recupererCoupV2(PLATEAU, COUPAJOUER):-
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererMonOrientation(MESPIECES, TETESENS),
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, _, [COURMEILLEUR | AUTRESDEPLACEMENTSPIECES]),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, COURMEILLEUR, COUPAJOUER).

% Prédicat
% Nom : longueur(LISTE, ACC, R)
% Utilité : connaître la taille d'une liste
% Retourne : retourne la taille d'une liste
longueur([],LONGUEUR,LONGUEUR).
longueur([_|L],LONGUEUR,R):-
	LONGUEURTMP is LONGUEUR + 1,
	longueur(L,LONGUEURTMP,R).

% Prédicat
% Nom : recupererUniquementCaptureDanger(LISTEDEPLACEMENTS, PIECEACAPTURER, ACC, R)
% Utilité : connaître tous les déplacements permettant de capturer une pièce en particulier
% Retourne : retourne la liste des déplacements possibles
recupererUniquementCaptureDanger([[FROMX,FROMY,FROMPIECE,XDANGER,YDANGER,PIECEADVDANGER,GAIN]|_], [XDANGER,YDANGER,_,PIECEADVDANGER], [FROMX,FROMY,FROMPIECE,XDANGER,YDANGER,PIECEADVDANGER,GAIN]):- !.
recupererUniquementCaptureDanger([_|L], [XDANGER,YDANGER,_,PIECEADVDANGER], R):-
    recupererUniquementCaptureDanger(L, [XDANGER,YDANGER,_,PIECEADVDANGER], R).

recupererUniquementCapturesDanger(DEPLACEMENTSPOSSIBLES, [XDANGER,YDANGER,TETESENS,PIECEADVDANGER], R):-
    findall(CAPTUREDANGER, recupererUniquementCaptureDanger(DEPLACEMENTSPOSSIBLES, [XDANGER,YDANGER,TETESENS,PIECEADVDANGER], CAPTUREDANGER), R).

% Prédicat
% Nom : recupererCoupV3(PLATEAU, COUPAJOUER)
% Utilité : choisir le coup à jouer dans la version 3 de l'IA
%           On vérifie désormais en début de tour si le koropokkuru est en danger, si c'esst le cas alors :
%               - Un seul danger : on cherche à l'éliminer
%               - Sinon on cherche à déplacer le koropokkuru
% Retourne : retourne le coup à jouer dans la version 3 de l'IA
recupererCoupV3(PLATEAU, COUPAJOUER):- %Plusieurs dangers on déplace le koropokkuru en sécurité
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, DANGERS),
    longueur(DANGERS, 0, NOMBREDANGERS),
    NOMBREDANGERS > 1,
    !,
    recupererDeplacementsPiecesAvecGain(PLATEAU, [KOROPOKKURU], _, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], COUPAJOUER).

recupererCoupV3(PLATEAU, [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]):- %Un danger on cherche à l'éliminé
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, [PREMIERDANGER | AUTRESDANGERS]),
    longueur([PREMIERDANGER | AUTRESDANGERS], 0, NOMBREDANGERS),
    NOMBREDANGERS == 1,
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, _, TOUSDEPLACEMENTS),
    recupererUniquementCapturesDanger(TOUSDEPLACEMENTS, PREMIERDANGER, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]),
    GAIN > 0.

recupererCoupV3(PLATEAU, COUPAJOUER):- % Si cela est impossible sans avoir un gain négatif alors on déplace le koropokkuru en sécurité
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, DANGERS),
    longueur(DANGERS, 0, NOMBREDANGERS),
    NOMBREDANGERS == 1,
    !,
    recupererDeplacementsPiecesAvecGain(PLATEAU, [KOROPOKKURU], _, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], COUPAJOUER).

recupererCoupV3(PLATEAU, COUPAJOUER):- % Si le koropokkuru n'est pas en danger on joue normalement
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererMonOrientation(MESPIECES, TETESENS),
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, _, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], COUPAJOUER).

% Prédicat
% Nom : recupererCoupV32(PLATEAU, COUPAJOUER)
% Utilité : permettre de retourner facilement avec jasper les informations du coup à jouer en version 3
% Retourne : retourne le coup à jouer dans la version 3 de l'IA
recupererCoupV32(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- %Plusieurs dangers on déplace le koropokkuru en sécurité
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, DANGERS),
    longueur(DANGERS, 0, NOMBREDANGERS),
    NOMBREDANGERS > 1,
    !,
    recupererDeplacementsPiecesAvecGain(PLATEAU, [KOROPOKKURU], [], [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]).

recupererCoupV32(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- %Un danger on cherche à l'éliminé
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, [PREMIERDANGER | AUTRESDANGERS]),
    longueur([PREMIERDANGER | AUTRESDANGERS], 0, NOMBREDANGERS),
    NOMBREDANGERS == 1,
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, [], TOUSDEPLACEMENTS),
    recupererUniquementCapturesDanger(TOUSDEPLACEMENTS, PREMIERDANGER, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]),
    GAIN > 0.

recupererCoupV32(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- % Si cela est impossible sans avoir un gain négatif alors on déplace le koropokkuru en sécurité
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, DANGERS),
    longueur(DANGERS, 0, NOMBREDANGERS),
    NOMBREDANGERS == 1,
    !,
    recupererDeplacementsPiecesAvecGain(PLATEAU, [KOROPOKKURU], [], [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]).

recupererCoupV32(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- % Si le koropokkuru n'est pas en danger on joue normalement
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererMonOrientation(MESPIECES, TETESENS),
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, [], [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    heurisitqueV2(PLATEAU, TETESENS, CMGAIN, [CMTOX,CMTOY,CMFROMPIECE], CMHEURISTIQUE),
    recupererMeilleurDeplacementV2(PLATEAU, TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]).


% Prédicat
% Nom : recupererCoupV4(PLATEAU, COUPAJOUER)
% Utilité : choisir le coup à jouer dans la version 4 de l'IA
%           On vérifie désormais en début de tour si le koropokkuru est en danger, si c'est le cas alors :
%               - Un seul danger : on cherche à l'éliminer
%               - Sinon on cherche à déplacer le koropokkuru
%           + On cherche à vérifier si le fait de jouer un coup n'entraine pas le fait qu'un de nos pièces plus importante soit en danger d'être capturée
% Retourne : retourne le coup à jouer dans la version 4 de l'IA

%recupererMeilleurDeplacementV3(PLATEAU, DEPLACEMENTSPOSSIBLES, TETESENS, [_ | L], [COURMEILLEURFROMX,COURMEILLEURFROMY,COURMEILLEURFROMPIECE,COURMEILLEURTOX,COURMEILLEURTOY,COURMEILLEURTOPIECE,COURMEILLEURGAIN],  R) :-
recupererCoupV4(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- %Plusieurs dangers on déplace le koropokkuru en sécurité
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, DANGERS),
    longueur(DANGERS, 0, NOMBREDANGERS),
    NOMBREDANGERS > 1,
    !,
    recupererDeplacementsPiecesAvecGain(PLATEAU, [KOROPOKKURU], [], [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN], CMHEURISTIQUE),
    recupererMeilleurDeplacementV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]).

recupererCoupV4(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- %Un danger on cherche à l'éliminé
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, [PREMIERDANGER | AUTRESDANGERS]),
    longueur([PREMIERDANGER | AUTRESDANGERS], 0, NOMBREDANGERS),
    NOMBREDANGERS == 1,
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, [], TOUSDEPLACEMENTS),
    recupererUniquementCapturesDanger(TOUSDEPLACEMENTS, PREMIERDANGER, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN], CMHEURISTIQUE),
    recupererMeilleurDeplacementV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]),
    GAIN > 0.

recupererCoupV4(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- % Si cela est impossible sans avoir un gain négatif alors on déplace le koropokkuru en sécurité
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererKoropokkuru(MESPIECES, KOROPOKKURU),
    dangersPourMaPiece(PLATEAU, KOROPOKKURU, DANGERS),
    longueur(DANGERS, 0, NOMBREDANGERS),
    NOMBREDANGERS == 1,
    !,
    recupererDeplacementsPiecesAvecGain(PLATEAU, [KOROPOKKURU], [], [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    recupererMonOrientation(MESPIECES, TETESENS),
    heurisitqueV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN], CMHEURISTIQUE),
    recupererMeilleurDeplacementV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]).

recupererCoupV4(PLATEAU, FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN):- % Si le koropokkuru n'est pas en danger on joue normalement
    recupererPiecesMoi(PLATEAU, MESPIECES),
    recupererMonOrientation(MESPIECES, TETESENS),
    recupererDeplacementsPiecesAvecGain(PLATEAU, MESPIECES, [], [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES]),
    heurisitqueV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN], CMHEURISTIQUE),
    recupererMeilleurDeplacementV3(PLATEAU, [[CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE,CMGAIN] | AUTRESDEPLACEMENTSPIECES], TETESENS, AUTRESDEPLACEMENTSPIECES, [CMFROMX,CMFROMY,CMFROMPIECE,CMTOX,CMTOY,CMTOPIECE, CMHEURISTIQUE], [FROMX,FROMY,FROMPIECE,TOX,TOY,TOPIECE,GAIN]).

% Tests unitaires
:-begin_tests(yokaiia).

% test(s) pour le prédicat caseCorrecte
test('caseCorrecte([-1,-1])',[fail]):-
	coordCorrect([-1,-1]).
test('caseCorrecte([0,0])',[true]):-
	coordCorrect([0,0]).
test('caseCorrecte([5,5])',[fail]):-
	coordCorrect([5,5]).
test('caseCorrecte([4,5])',[true]):-
   	coordCorrect([4,5]).

% test(s) pour le prédicat deplacementCorrectPiece
test('deplacementCorrectPiece([2,2], [0,0], tetesud,onisuperMoi)',[fail]):-
   	deplacementCorrectPiece([2,2], [0,0], tetesud,onisuperMoi).
test('deplacementCorrectPiece([2,2], [1,1], tetesud,onisuperMoi)',[fail]):-
   	deplacementCorrectPiece([2,2], [1,1], tetesud,onisuperMoi).
test('deplacementCorrectPiece([2,2], [2,1], tetesud,onisuperMoi)',[true]):-
   	deplacementCorrectPiece([2,2], [2,1], tetesud,onisuperMoi).

% test(s) pour le prédicat pieceACoord
test('pieceACoord([[3,3,_,vide], [1,1,tetesud,oniMoi]], [3,3],PIECE)',[true(PIECE==vide)]):-
   	pieceACoord([[3,3,_,vide], [1,1,tetesud,oniMoi]], [3,3], PIECE).
test('pieceACoord([[3,3,_,vide], [1,1,tetesud,oniMoi]], [1,1],PIECE)',[true(PIECE==oniMoi)]):-
   	pieceACoord([[3,3,_,vide], [1,1,tetesud,oniMoi]], [1,1], PIECE).
test('pieceACoord([[3,3,_,vide], [1,1,tetesud,oniMoi]], [2,2], PIECE)',[true(PIECE==vide)]):-
   	pieceACoord([[3,3,_,vide], [1,1,tetesud,oniMoi]], [2,2], PIECE).

% test(s) pour le prédicat deplacementPieceAvecGain
test('deplacementPieceAvecGain([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],[2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],[3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]], [2,2,tetesud,koropokkuruMoi], R)',[true(R==[2,2,koropokkuruMoi,2,3,koropokkuruAdv,1000])]):-
  	deplacementPieceAvecGain([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],
                               [2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],
                               [3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]],
                              [2,2,tetesud,koropokkuruMoi],
   	                          R).

% test(s) pour le prédicat recupererDeplacementsPieceAvecGain
test('recupererDeplacementsPieceAvecGain([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],[2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],[3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]], [2,2,tetesud,koropokkuruMoi], R)',[true(R==[[2,2,koropokkuruMoi,2,3,koropokkuruAdv,1000],[2,2,koropokkuruMoi,3,3,oniAdv,35],[2,2,koropokkuruMoi,1,3,oniAdv,35],[2,2,koropokkuruMoi,1,1,vide,0],[2,2,koropokkuruMoi,3,1,vide,0],[2,2,koropokkuruMoi,3,2,oniAdv,35]])]):-
  	recupererDeplacementsPieceAvecGain([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],
                                        [2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],
                                        [3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]],
                                        [2,2,tetesud,koropokkuruMoi], R).

% test(s) pour le prédicat recupererPiecesMoi
test('recupererPiecesMoi([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],[2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],[3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]], R)',[true(R==[[1,2,tetesud,oniMoi],[2,1,tetesud,oniMoi],[2,2,tetesud,koropokkuruMoi]])]):-
    recupererPiecesMoi([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],
                        [2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],
                        [3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]], R).

% test (s) pour le prédicat recupererDeplacementsPiecesAvecGain
test('recupererDeplacementsPiecesAvecGain([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],[2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],[3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]], [[1,2,tetesud,oniMoi],[2,1,tetesud,oniMoi],[2,2,tetesud,koropokkuruMoi]], _, R)',[true(R==[[2,2,koropokkuruMoi,2,3,koropokkuruAdv,1000],[2,2,koropokkuruMoi,3,3,oniAdv,35],[2,2,koropokkuruMoi,1,3,oniAdv,35],[2,2,koropokkuruMoi,1,1,vide,0],[2,2,koropokkuruMoi,3,1,vide,0],[2,2,koropokkuruMoi,3,2,oniAdv,35],[2,1,oniMoi,3,2,oniAdv,35],[2,1,oniMoi,1,0,vide,0],[2,1,oniMoi,3,0,vide,0],[1,2,oniMoi,1,3,oniAdv,35],[1,2,oniMoi,2,3,koropokkuruAdv,1000],[1,2,oniMoi,0,3,vide,0],[1,2,oniMoi,0,1,vide,0]])]):-
   recupererDeplacementsPiecesAvecGain([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],
                                        [2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],
                                        [3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]], [[1,2,tetesud,oniMoi],[2,1,tetesud,oniMoi],[2,2,tetesud,koropokkuruMoi]], [], R).

% test (s) pour le prédicat recupererCoupV1
test('recupererCoupV1([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3, tetenord,koropokkuruAdv], [2,1, tetesud,oniMoi], [2,2, tetesud,oniMoi], [2,3, tetesud,oniMoi], [3,1, _,vide], [3,2, tetenord,oniAdv], [3,3, tetenord,oniAdv]],R).  ',[true(R==[2,2,oniMoi,1,3,koropokkuruAdv,1000])]):-
    recupererCoupV1([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3, tetenord,koropokkuruAdv], [2,1, tetesud,oniMoi], [2,2, tetesud,oniMoi], [2,3, tetesud,oniMoi], [3,1, _,vide], [3,2, tetenord,oniAdv], [3,3, tetenord,oniAdv]],R).

% test (s) pour le prédicat dangersPourMaPiece
test('dangersPourMaPiece([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],[2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],[3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]], [2,2,tetesud,koropokkuruMoi], R)',[true(R==[[2,3,tetenord,koropokkuruAdv],[1,3,tetenord,oniAdv],[3,3,tetenord,oniAdv]])]):-
   dangersPourMaPiece([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3,tetenord,oniAdv],
                      [2,1,tetesud,oniMoi], [2,2,tetesud,koropokkuruMoi], [2,3,tetenord,koropokkuruAdv],
                      [3,1, _,vide], [3,2,tetenord,oniAdv], [3,3,tetenord,oniAdv]],[2,2,tetesud,koropokkuruMoi], R).

test('dangersPourMaPiece([[1,1,tetesud,koropokkuruAdv], [1,2,tetesud,oniAdv], [1,3,tetenord,oniMoi],[2,1,tetesud,oniAdv], [2,2,tetenord,koropokkuruMoi], [2,3,tetesud,koropokkuruAdv],[3,1, _,vide], [3,2,tetenord,oniMoi], [3,3,tetesud,oniAdv]], [2,2,tetenord,koropokkuruMoi], R)',[true(R==[[2,1,tetesud,oniAdv],[1,1,tetesud,koropokkuruAdv],[3,3,tetesud,oniAdv],[2,3,tetesud,koropokkuruAdv]])]):-
   dangersPourMaPiece([[1,1,tetesud,koropokkuruAdv], [1,2,tetesud,oniAdv], [1,3,tetenord,oniMoi],[2,1,tetesud,oniAdv], [2,2,tetenord,koropokkuruMoi], [2,3,tetesud,koropokkuruAdv],[3,1, _,vide], [3,2,tetenord,oniMoi], [3,3,tetesud,oniAdv]], [2,2,tetenord,koropokkuruMoi], R).

% test (s) pour le prédicat recupererKoropokkuru
test('recupererKoropokkuru([[1,2,tetesud,oniMoi],[2,1,tetesud,oniMoi],[2,2,tetesud,koropokkuruMoi]],R).',[true(R==[2,2,tetesud,koropokkuruMoi])]):-
    recupererKoropokkuru([[1,2,tetesud,oniMoi],[2,1,tetesud,oniMoi],[2,2,tetesud,koropokkuruMoi]],R).

test('recupererKoropokkuru([[1,2,tetesud,oniMoi],[2,1,tetesud,oniMoi]],_)',[fail]):-
    recupererKoropokkuru([[1,2,tetesud,oniMoi],[2,1,tetesud,oniMoi]],_).

% test (s) pour le prédicat dangerMinimum
test('dangerMinimum([[1,2,tetesud,koropokkuruAdv],[2,1,tetesud,kodamaAdv],[2,2,tetesud,onisuperAdv]],200,R).',[true(R==10)]):-
    dangerMinimum([[1,2,tetesud,koropokkuruAdv],[2,1,tetesud,kodamaAdv],[2,2,tetesud,onisuperAdv]],200,R).

% test (s) pour le prédicat recupererMonOrientation
 test('recupererMonOrientation([[2,1,tetesud,koropokkuruMoi],[2,2,tetesud,onisuperMoi]],R).',[true(R == tetesud)]):-
     recupererMonOrientation([[2,1,tetesud,koropokkuruMoi],[2,2,tetesud,onisuperMoi]],R).

% test (s) pour le prédicat recupererCoupV2
test('recupererCoupV2([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3, tetenord,koropokkuruAdv], [2,1, tetesud,oniMoi], [2,2, tetesud,oniMoi], [2,3, tetesud,oniMoi], [3,1, _,vide], [3,2, tetenord,oniAdv], [3,3, tetenord,oniAdv]],R).  ',[true(R==[2,2,oniMoi,1,3,koropokkuruAdv,1000])]):-
    recupererCoupV2([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3, tetenord,koropokkuruAdv], [2,1, tetesud,oniMoi], [2,2, tetesud,oniMoi], [2,3, tetesud,oniMoi], [3,1, _,vide], [3,2, tetenord,oniAdv], [3,3, tetenord,oniAdv]],R).

test('recupererCoupV2([[1,1,tetesud, kirinAdv],[1,2,_,vide], [3,2,tetesud,koropokkuruAdv], [2,1,_,vide],[2,2,_,vide],[2,3,tetesud,kodamasamouraiAdv], [3,1,tetesud,kodamaAdv], [3,2,tetesud,onisuperAdv], [3,3,tetenord,koropokkuruMoi]], COUPAJOUER).', [true(COUPAJOUER==[3,3,koropokkuruMoi,3,2,koropokkuruAdv,1000])]):-
    recupererCoupV2([[1,1,tetesud, kirinAdv],[1,2,_,vide], [3,2,tetesud,koropokkuruAdv], [2,1,_,vide],[2,2,_,vide],[2,3,tetesud,kodamasamouraiAdv], [3,1,tetesud,kodamaAdv], [3,2,tetesud,onisuperAdv], [3,3,tetenord,koropokkuruMoi]], COUPAJOUER).


test('recupererCoupV2([[1,1,tetesud, kirinAdv],[2,1,_,vide], [3,1,tetesud,kodamaAdv], [1,2,_,vide],[2,2,tetenord,koropokkuruMoi],[3,2,tetesud,onisuperAdv], [1,3,tetesud,kodamasamouraiAdv], [2,3,_,vide], [3,3,tetenord,kirinMoi]], COUPAJOUER).', [true(COUPAJOUER==[2,2,koropokkuruMoi,1,1,kirinAdv,70])]):-
    recupererCoupV2([[1,1,tetesud, kirinAdv],[2,1,_,vide], [3,1,tetesud,kodamaAdv], [1,2,_,vide],[2,2,tetenord,koropokkuruMoi],[3,2,tetesud,onisuperAdv], [1,3,tetesud,kodamasamouraiAdv], [2,3,_,vide], [3,3,tetenord,kirinMoi]], COUPAJOUER).

test('recupererCoupV2([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,oniAdv],[3,2,tetesud,oniAdv], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).', [true(COUPAJOUER==[2,3,koropokkuruMoi,3,2,oniAdv,35])]):-
    recupererCoupV2([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,oniAdv],[3,2,tetesud,oniAdv], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).

test('recupererCoupV2([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,kodamaAdv],[3,2,_,vide], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).', [true(COUPAJOUER\=[2,3,koropokkuruMoi,2,2,kodamaAdv,_])]):-
    recupererCoupV2([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,kodamaAdv],[3,2,_,vide], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).

% test (s) pour le prédicat longueur
test('longueur([a,b,c],0,R)',[true(R==3)]):-
    longueur([a,b,c],0,R).

test('longueur([],0,R)',[true(R==0)]):-
    longueur([],0,R).

% test (s) pour le prédicat recupererCoupV3
test('recupererCoupV3([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3, tetenord,koropokkuruAdv], [2,1, tetesud,oniMoi], [2,2, tetesud,oniMoi], [2,3, tetesud,oniMoi], [3,1, _,vide], [3,2, tetenord,oniAdv], [3,3, tetenord,oniAdv]],R).  ',[true(R==[2,2,oniMoi,1,3,koropokkuruAdv,1000])]):-
    recupererCoupV3([[1,1,_,vide], [1,2,tetesud,oniMoi], [1,3, tetenord,koropokkuruAdv], [2,1, tetesud,oniMoi], [2,2, tetesud,oniMoi], [2,3, tetesud,oniMoi], [3,1, _,vide], [3,2, tetenord,oniAdv], [3,3, tetenord,oniAdv]],R).

test('recupererCoupV3([[1,1,tetesud, kirinAdv],[1,2,_,vide], [3,2,tetesud,koropokkuruAdv], [2,1,_,vide],[2,2,_,vide],[2,3,tetesud,kodamasamouraiAdv], [3,1,tetesud,kodamaAdv], [3,2,tetesud,onisuperAdv], [3,3,tetenord,koropokkuruMoi]], COUPAJOUER).', [true(COUPAJOUER==[3,3,koropokkuruMoi,3,2,koropokkuruAdv,1000])]):-
    recupererCoupV3([[1,1,tetesud, kirinAdv],[1,2,_,vide], [3,2,tetesud,koropokkuruAdv], [2,1,_,vide],[2,2,_,vide],[2,3,tetesud,kodamasamouraiAdv], [3,1,tetesud,kodamaAdv], [3,2,tetesud,onisuperAdv], [3,3,tetenord,koropokkuruMoi]], COUPAJOUER).

test('recupererCoupV3([[1,1,tetesud, kirinAdv],[2,1,_,vide], [3,1,tetesud,kodamaAdv], [1,2,_,vide],[2,2,tetenord,koropokkuruMoi],[3,2,tetesud,onisuperAdv], [1,3,tetesud,kodamasamouraiAdv], [2,3,_,vide], [3,3,tetenord,kirinMoi]], COUPAJOUER).', [true(COUPAJOUER==[2,2,koropokkuruMoi,1,1,kirinAdv,70])]):-
    recupererCoupV3([[1,1,tetesud, kirinAdv],[2,1,_,vide], [3,1,tetesud,kodamaAdv], [1,2,_,vide],[2,2,tetenord,koropokkuruMoi],[3,2,tetesud,onisuperAdv], [1,3,tetesud,kodamasamouraiAdv], [2,3,_,vide], [3,3,tetenord,kirinMoi]], COUPAJOUER).

test('recupererCoupV3([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,oniAdv],[3,2,tetesud,oniAdv], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).', [true(COUPAJOUER==[2,3,koropokkuruMoi,3,2,oniAdv,35])]):-
    recupererCoupV3([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,oniAdv],[3,2,tetesud,oniAdv], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).

test('recupererCoupV3([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,oniAdv],[3,2,tetesud,oniAdv], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).', [true(COUPAJOUER==[2,3,koropokkuruMoi,3,2,oniAdv,35])]):-
    recupererCoupV3([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,oniAdv],[3,2,tetesud,oniAdv], [1,3,tetenord,kadamasamouraiMoi], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).

test('recupererCoupV3([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,kodamaAdv],[3,2,_,vide], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).', [true(COUPAJOUER\=[2,3,koropokkuruMoi,2,2,kodamaAdv,_])]):-
   recupererCoupV3([[1,1,_, vide],[2,1,tetesud,kodamaAdv], [3,1,_,vide], [1,2,_,vide],[2,2,tetesud,kodamaAdv],[3,2,_,vide], [1,3,_,vide], [2,3,tetenord,koropokkuruMoi], [3,3,_,vide]], COUPAJOUER).

% test(s) pour le prédicat recupererListeDeplacementAvecCapture
test('recupererListeDeplacementAvecCapture([2,2,koropokkuruMoi,2,2,kodamaAdv,10], [[3,4, kodamasamouraiMoi, 4,4, oniAdv],[2,2,koropokkuruMoi,2,2,kodamaAdv, 10],[2,3,koropokkuruMoi,2,3,vide, 0], [2,2,koropokkuruMoi,1,1,kirinAdv, 70], [2,2,koropokkuruMoi,3,3,kodamaAdv, 10], [2,2,koropokkuruMoi,2,1,vide, 0]], [], R).', [true(R=[[2,2,koropokkuruMoi,3,3,kodamaAdv,10],[2,2,koropokkuruMoi,1,1,kirinAdv,70], [3,4, kodamasamouraiMoi, 4,4, oniAdv]])]):-
recupererListeDeplacementAvecCapture([2,2,koropokkuruMoi,2,2,kodamaAdv,10], [[3,4, kodamasamouraiMoi, 4,4, oniAdv],[2,2,koropokkuruMoi,2,2,kodamaAdv, 10],[2,3,koropokkuruMoi,2,3,vide, 0], [2,2,koropokkuruMoi,1,1,kirinAdv, 70], [2,2,koropokkuruMoi,3,3,kodamaAdv, 10], [2,2,koropokkuruMoi,2,1,vide, 0]], [], R).

% test (s) pour l'heuristique v4 et recupererCoupv4
test('sommeDesDangers1', [true(R== -70)]):-
    PLATEAU = [[1,0, tetesud, kirinAdv],[2,0, tetesud, koropokkuruAdv], [3,0,tetesud, kirinAdv], [2,2,tetenord,kodamaMoi], [3,4, tetesud,kodamaAdv],[2,5,tetenord,koroppokuruMoi], [3,5, tetenord, kirinMoi], [4,5, tetenord,oniMoi]],
    recupererPiecesMoi(PLATEAU, MESPIECES),
    %recupererMonOrientation(MESPIECES, TETESENS),
    recupererDeplacementsPiecesAvecGain(PLATEAU,MESPIECES, [], DEPLACEMENTS),
    recupererListeDeplacementAvecCapture([2,2,kodamaMoi,2,1,vide,90],DEPLACEMENTS, [], DEPLACEMENTSAVECAPTURES),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(DEPLACEMENTSAVECAPTURES, [], DEPLACEMENTSADV),
    sommeDesDangers(PLATEAU, tetesud, DEPLACEMENTSADV, 0, R).

test('sommeDesDangers2', [true(R== -80)]):-
    PLATEAU = [[1,0, tetesud, kirinAdv],[2,0, tetesud, koropokkuruAdv], [3,0,tetesud, kirinAdv], [2,2,tetenord,kodamaMoi], [3,4, tetesud,kodamaAdv],[1,4, tetesud, oniAdv],[1,5, tetenord, kodamaMoi],[2,5,tetenord,koroppokuruMoi], [3,5, tetenord, kirinMoi], [4,5, tetenord,oniMoi]],
    recupererPiecesMoi(PLATEAU, MESPIECES),
    %recupererMonOrientation(MESPIECES, TETESENS),
    recupererDeplacementsPiecesAvecGain(PLATEAU,MESPIECES, [], DEPLACEMENTS),
    recupererListeDeplacementAvecCapture([2,2,kodamaMoi,2,1,vide,90],DEPLACEMENTS, [], DEPLACEMENTSAVECAPTURES),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(DEPLACEMENTSAVECAPTURES, [], DEPLACEMENTSADV),
    sommeDesDangers(PLATEAU, tetesud, DEPLACEMENTSADV, 0, R).

test('sommeDesDangers3', [true(R== 0)]):-
    PLATEAU = [[1,0, tetesud, kirinAdv],[2,0, tetesud, koropokkuruAdv], [3,0,tetesud, kirinAdv], [2,2,tetenord,kodamaMoi], [3,4, tetesud,kodamaAdv],[2,5,tetenord,koroppokuruMoi], [3,5, tetenord, kirinMoi], [4,5, tetenord,oniMoi]],
    recupererPiecesMoi(PLATEAU, MESPIECES),
    %recupererMonOrientation(MESPIECES, TETESENS),
    recupererDeplacementsPiecesAvecGain(PLATEAU,MESPIECES, [], DEPLACEMENTS),
    recupererListeDeplacementAvecCapture([4,5, oniMoi,3,4,kodamaAdv,10],DEPLACEMENTS, [], DEPLACEMENTSAVECAPTURES),
    recupererPiecesAdvDifDansListeDeplacementAvecCapture(DEPLACEMENTSAVECAPTURES, [], DEPLACEMENTSADV),
    sommeDesDangers(PLATEAU, tetesud, DEPLACEMENTSADV, 0, R).

:-end_tests(yokaiia).

