:-use_module(library(plunit)).
:-use_module(library(lists)).

:- [DeplacementPiecesYokai].

plateau([
oni_s, kirin_s, koropokkuru_s, kirin_s, oni_s,
v, v, v, v, v,
v, kodoma_s, kodoma_s, kodoma_s, v,
v, kodoma_n, kodoma_n, kodoma_n, v,
v, v, v, v, v,
oni_n, kirin_n, koropokkuru_n, kirin_n, oni_n
]).

valeur_sur_plateau(v, neutre, 0).
valeur_sur_plateau(kodoma, moi, 10).
valeur_sur_plateau(kodoma, adv, -10).
valeur_sur_plateau(oni, moi, 25).
valeur_sur_plateau(oni, adv, -25).
valeur_sur_plateau(kodoma_samourai, moi, 55).
valeur_sur_plateau(kodoma_samourai, adv, -55).
valeur_sur_plateau(super_oni, moi, 55).
valeur_sur_plateau(super_oni, adv, -55).
valeur_sur_plateau(kirin, moi, 80).
valeur_sur_plateau(kirin, adv, -80).
valeur_sur_plateau(koropokkuru, moi, 2000).
valeur_sur_plateau(koropokkuru, adv, -2000).

valeur_promotion(kodoma, 50).
valeur_promotion(oni, 50).

% Plateau = [v, PIECE, ...]
% Piece = [TYPE, SENS, FACTION]

deplacer_piece_avec_cout(Plateau, [kodoma, sud, moi], FromCase, ToCase, Cout):-
    move(kodoma, sud, FromCase, ToCase),
    ToCase >= 20,
    nth0(ToCase, Plateau, [TypePiece,FactionPiece,_]),
    dif(FactionPiece, moi),
    valeur_sur_plateau(TypePiece, FactionPiece, C1),
    valeur_promotion(kodoma, C2),
    Cout is C1 + C2.

deplacer_piece_avec_cout(Plateau, [kodoma, nord, moi], FromCase, ToCase, Cout):-
    move(kodoma, nord, FromCase, ToCase),
    ToCase < 10,
    nth0(ToCase, Plateau, [TypePiece,FactionPiece,_]),
    dif(FactionPiece, moi),
    valeur_sur_plateau(TypePiece, FactionPiece, C1),
    valeur_promotion(kodoma, C2),
    Cout is C1 + C2.


deplacer_piece_avec_cout(Plateau, [oni, sud, moi], FromCase, ToCase, Cout):-
    move(oni, sud, FromCase, ToCase),
    ToCase >= 20,
    nth0(ToCase, Plateau, [TypePiece,FactionPiece,_]),
    dif(FactionPiece, moi),
    valeur_sur_plateau(TypePiece, FactionPiece, C1),
    valeur_promotion(oni, C2),
    Cout is C1 + C2.

deplacer_piece_avec_cout(Plateau, [oni, nord, moi], FromCase, ToCase, Cout):-
    move(oni, nord, FromCase, ToCase),
    ToCase  < 10,
    nth0(ToCase, Plateau, [TypePiece,FactionPiece,_]),
    valeur_sur_plateau(TypePiece, FactionPiece, C1),
    dif(FactionPiece, moi),
    valeur_promotion(oni, C2),
    Cout is C1 + C2.

deplacer_piece_avec_cout(Plateau, [Type, Sens, Faction], FromCase, ToCase, Cout):-
    move(Type, Sens, FromCase, ToCase),
    nth0(ToCase, Plateau, [TypePiece,FactionPiece,_]),
    dif(FactionPiece, moi),
    valeur_sur_plateau(TypePiece, FactionPiece, Cout).


recuperer_piece_moi([[Type, _, Faction]|_], Case, [Type, Case]):-
    Faction == moi.

recuperer_piece_moi([_|Rest], Case, [Type, Case]):-
    CaseMinus1 is Case - 1,
    recuperer_piece_moi(Rest, CaseMinus1, [Type, Case]).

recuperer_pieces_moi(Plateau, Case, ListePieces):-
    findall(Piece, estPieceMoi(PLATEAU, PIECE), ListePieces).

recuperer_coup_piece()

calculer_liste_coups(Plateau, Coups):-
    recuperer_pieces_moi(Plateau, 0, Pieces),


recuperer_meilleur_coup(Coups, [Case, NvCase, Cout]):-


jouer_prochain_coup(Plateau, TypePiece, Case, NvCase):-
    calculer_liste_coups(Plateau, Coups),
    recuperer_meilleur_coup(Coups, [Case, NvCase, _]).
