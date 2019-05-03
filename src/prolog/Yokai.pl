:-use_module(library(plunit)).
:-use_module(library(lists)).

:- include('DeplacementPiecesYokai.pl').

% Exemple de plateau, d�but de partie.
plateau([
[oni, sud, moi, 0], [kirin, sud, moi, 1], [koropokkuru, sud, moi, 2], [kirin, sud, moi, 3], [oni, sud, moi, 4],
[v, none, neutre, 5], [v, none, neutre, 6], [kodoma, nord, adv, 7], [v, none, neutre, 8], [v, none, neutre, 9],
[v, none, neutre, 10], [kodoma, sud, moi, 11], [kodoma, sud, moi, 12], [kodoma, sud, moi, 13], [v, none, neutre, 14],
[v, none, neutre, 15], [kodoma, nord, adv, 16], [kodoma, nord, adv, 17], [kodoma, nord, adv, 18], [v, none, neutre, 19],
[v, none, neutre, 20], [v, none, neutre, 21], [v, none, neutre, 22], [v, none, neutre, 23], [v, none, neutre, 24],
[oni, nord, adv, 25], [kirin, nord, adv, 26], [koropokkuru, nord, adv, 27], [kirin, nord, adv, 28], [oni, nord, adv, 29]
]).

valeur_piece_sur_plateau(v, 0).
valeur_piece_sur_plateau(kodoma, 10).
valeur_piece_sur_plateau(oni, 25).
valeur_piece_sur_plateau(kodoma_samourai, 55).
valeur_piece_sur_plateau(super_oni, 55).
valeur_piece_sur_plateau(kirin, 80).
valeur_piece_sur_plateau(koropokkuru, 2000).

valeur_promotion(kodoma, 50).
valeur_promotion(oni, 50).

deplacer_piece_sur_plateau(Plateau, [kodoma, sud, Faction, FromCase], ToCase, Cout):-
    move(kodoma, sud, FromCase, ToCase),
    ToCase >= 20,
    nth0(ToCase, Plateau, [TypePiece, _, FactionPiece, _]),
    dif(FactionPiece, Faction),
    valeur_piece_sur_plateau(TypePiece, C1),
    valeur_promotion(kodoma, C2),
    Cout is C1 + C2.

deplacer_piece_sur_plateau(Plateau, [kodoma, nord, Faction, FromCase], ToCase, Cout):-
    move(kodoma, nord, FromCase, ToCase),
    ToCase < 10,
    nth0(ToCase, Plateau, [TypePiece, _, FactionPiece, _]),
    dif(FactionPiece, Faction),
    valeur_piece_sur_plateau(TypePiece, C1),
    valeur_promotion(kodoma, C2),
    Cout is C1 + C2.


deplacer_piece_sur_plateau(Plateau, [oni, sud, Faction, FromCase], ToCase, Cout):-
    move(oni, sud, FromCase, ToCase),
    ToCase >= 20,
    nth0(ToCase, Plateau, [TypePiece, _, FactionPiece, _]),
    dif(FactionPiece, Faction),
    valeur_piece_sur_plateau(TypePiece, C1),
    valeur_promotion(oni, C2),
    Cout is C1 + C2.

deplacer_piece_sur_plateau(Plateau, [oni, nord, Faction, FromCase], ToCase, Cout):-
    move(oni, nord, FromCase, ToCase),
    ToCase  < 10,
    nth0(ToCase, Plateau, [TypePiece, _, FactionPiece, _]),
    valeur_piece_sur_plateau(TypePiece, C1),
    dif(FactionPiece, Faction),
    valeur_promotion(oni, C2),
    Cout is C1 + C2.

deplacer_piece_sur_plateau(Plateau, [Type, Sens, Faction, FromCase], ToCase, Cout):-
    move(Type, Sens, FromCase, ToCase),
    nth0(ToCase, Plateau, [TypePiece, _, FactionPiece, _]),
    dif(FactionPiece, Faction),
    valeur_piece_sur_plateau(TypePiece, Cout).

test1(ToCase,Cout):-
    plateau(Plateau),
    deplacer_piece_sur_plateau(Plateau,[kirin,sud,moi,1],ToCase,Cout).

test2(ToCase,Cout):-
    plateau(Plateau),
    deplacer_piece_sur_plateau(Plateau,[kodoma,sud,moi,11], ToCase, Cout).


recuperer_piece_faction([[Piece,Sens,Faction,Case]|_], Faction, [Piece,Sens,Faction,Case]).

recuperer_piece_faction([_|Tail], Faction, Piece):-
    recuperer_piece_faction(Tail, Faction, Piece).

recuperer_pieces_faction(Plateau, Faction, ListePieces):-
    findall(Piece, recuperer_piece_faction(Plateau, Faction, Piece), ListePieces).

test3(ListePieces):-
    plateau(Plateau),
    recuperer_pieces_faction(Plateau, moi, ListePieces).

recuperer_tout_les_coups_piece(Plateau, Piece, ListeCoups):-
    findall([Piece, ToCase, Cout], deplacer_piece_sur_plateau(Plateau,Piece,ToCase,Cout), ListeCoups).

test4(ListeCoups):-
    plateau(Plateau),
    recuperer_tout_les_coups_piece(Plateau, [kirin,sud,moi,1],ListeCoups).

recuperer_meilleur_coup_piece_acc([],Acc,Acc).

recuperer_meilleur_coup_piece_acc([[Piece,ToCase,Cout]|Tail], [_,_,Cout1],Res):-
    Cout > Cout1,
    recuperer_meilleur_coup_piece_acc(Tail,[Piece, ToCase, Cout], Res).

recuperer_meilleur_coup_piece_acc([_|Tail],Acc,Res):-
    recuperer_meilleur_coup_piece_acc(Tail,Acc,Res).

recuperer_meilleur_coup_piece(ListeCoups,Res):-
    recuperer_meilleur_coup_piece_acc(ListeCoups,[_,_,-1],Res),!.

test5(Coup):-
    plateau(Plateau),
    recuperer_tout_les_coups_piece(Plateau, [kirin,sud,moi,1],ListeCoups),
    recuperer_meilleur_coup_piece(ListeCoups,Coup).


recuperer_meilleur_coup_pieces_acc(_,[], Acc, Acc).

recuperer_meilleur_coup_pieces_acc(Plateau,[Piece|Tail],[_,_,Cout1],Res):-
    recuperer_tout_les_coups_piece(Plateau,Piece,ListeCoups),
    recuperer_meilleur_coup_piece(ListeCoups,[Piece, ToCase, Cout]),
    Cout > Cout1,
    recuperer_meilleur_coup_pieces_acc(Plateau, Tail, [Piece, ToCase, Cout], Res).


recuperer_meilleur_coup_pieces_acc(Plateau, [_|Tail], Acc, Res):-
    recuperer_meilleur_coup_pieces_acc(Plateau, Tail, Acc, Res).

recuperer_meilleur_coup_pieces(Plateau, ListePieces, Coup):-
    recuperer_meilleur_coup_pieces_acc(Plateau, ListePieces,[_,_,-1], Coup),!.


test6(Coup):-
    plateau(Plateau),
    recuperer_pieces_faction(Plateau, moi, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, Coup).

% Predicat donnant le meilleur coup a jouer en jeu, � appeler depuis
% Jasper.
%
% Param Plateau : Plateau actuel, cf pr�dicat plateau() pour voir la
% structure
% Param Faction : moi | adv, devrait pour le moment etre mis � moi
% Return From Case : Case de 0 � 29
% Return To Case : Case de 0 � 29
recuperer_meilleur_coup_v1(Plateau, Faction, FromCase, ToCase):-
    recuperer_pieces_faction(Plateau, Faction, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, [[_,_,_,FromCase], ToCase,_]).

test7(FromCase, ToCase):-
    plateau(Plateau),
    recuperer_meilleur_coup(Plateau, moi, FromCase, ToCase).