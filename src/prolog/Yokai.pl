:-use_module(library(plunit)).
:-use_module(library(lists)).

:- include('DeplacementPiecesYokai.pl').

% Exemple de plateau, d�but de partie.
plateau([
[oni, sud, moi, 0], [kirin, sud, moi, 1], [koropokkuru, sud, moi, 2], [kirin, sud, moi, 3], [oni, sud, moi, 4],
[v, none, neutre, 5], [v, none, neutre, 6], [kodama, nord, adv, 7], [v, none, neutre, 8], [v, none, neutre, 9],
[v, none, neutre, 10], [kodama, sud, moi, 11], [kodama, sud, moi, 12], [kodama, sud, moi, 13], [v, none, neutre, 14],
[v, none, neutre, 15], [kodama, nord, adv, 16], [kodama, sud, moi, 17], [kodama, nord, adv, 18], [v, none, neutre, 19],
[v, none, neutre, 20], [v, none, neutre, 21], [v, none, neutre, 22], [v, none, neutre, 23], [v, none, neutre, 24],
[oni, nord, adv, 25], [kirin, nord, adv, 26], [koropokkuru, nord, adv, 27], [kirin, nord, adv, 28], [oni, nord, adv, 29]
]).

valeur_piece_sur_plateau(v, 0).
valeur_piece_sur_plateau(kodama, 10).
valeur_piece_sur_plateau(oni, 25).
valeur_piece_sur_plateau(kodama_samourai, 55).
valeur_piece_sur_plateau(super_oni, 55).
valeur_piece_sur_plateau(kirin, 80).
valeur_piece_sur_plateau(koropokkuru, 2000).

valeur_promotion(kodama, 50).
valeur_promotion(oni, 50).

coup_promotion(kodama, sud, ToCase, Cout):-
    ToCase >= 20,
    valeur_promotion(kodama, Cout),!.

coup_promotion(kodama, nord, ToCase, Cout):-
    ToCase < 10,
    valeur_promotion(kodama, Cout),!.

coup_promotion(oni, sud, ToCase, Cout):-
    ToCase >= 20,
    valeur_promotion(kodama, Cout),!.

coup_promotion(oni, nord, ToCase, Cout):-
    ToCase < 10,
    valeur_promotion(kodama, Cout),!.

coup_promotion(_,_,_,0):-!.

perte_cout_si_menace_a_arrivee(Plateau, [Type, _, Faction, _], ToCase, C2, Cout):-
    faction_ennemie(Faction, FactionMenacante),
    recuperer_pieces_menacantes(Plateau, FactionMenacante, ToCase, ListePieces),
    length(ListePieces, Nb),
    dif(0, Nb),
    valeur_piece_sur_plateau(Type, C1),
    Cout is C2 + C1,!.

perte_cout_si_menace_a_arrivee(_,_,_,_,0):-!.

deplacer_piece_sur_plateau(Plateau, [Type, Sens, Faction, FromCase], ToCase, Cout):-
    move(Type, Sens, FromCase, ToCase),
    nth0(ToCase, Plateau, [TypePiece, _, FactionPiece, _]),
    dif(FactionPiece, Faction),
    coup_promotion(Type, Sens, ToCase, C2),
    valeur_piece_sur_plateau(TypePiece, C1),
    perte_cout_si_menace_a_arrivee(Plateau, [Type, Sens, Faction, FromCase], ToCase, C2, C3),
    Cout is C1 + C2 - C3.

test1(ToCase,Cout):-
    plateau(Plateau),
    deplacer_piece_sur_plateau(Plateau,[koropokkuru,nord,adv,27],ToCase,Cout).

test2(ToCase,Cout):-
    plateau(Plateau),
    deplacer_piece_sur_plateau(Plateau,[kodama,nord,adv,7], ToCase, Cout).


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
    recuperer_meilleur_coup_v1(Plateau, moi, FromCase, ToCase).


recuperer_meilleur_coup_v2(Plateau, Faction, FromCase, ToCase, Gain):-
    koropokkuru_en_echec_coup(Plateau, Faction, [[_,_,_,FromCase], ToCase, Gain]),!.

recuperer_meilleur_coup_v2(Plateau, Faction, FromCase, ToCase, Gain):-
    recuperer_pieces_faction(Plateau, Faction, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, [[_,_,_,FromCase], ToCase,Gain]),!.

test8(FromCase, ToCase, Cout):-
    plateau(Plateau),
    recuperer_meilleur_coup_v2(Plateau, moi, FromCase, ToCase, Cout).

%=== PIECE SAUVE ====

recuperer_piece_menacante([[Piece,Sens,FactionMenacante,Case]|_], FactionMenacante,CaseInDanger, [Piece,Sens,FactionMenacante,Case]):-
    move(Piece,Sens,Case,CaseInDanger).

recuperer_piece_menacante([_|Tail], FactionMenacante, CaseInDanger, Piece):-
    recuperer_piece_menacante(Tail, FactionMenacante, CaseInDanger, Piece).


recuperer_pieces_menacantes(Plateau, FactionMenacante, CaseInDanger, ListePieces):-
    findall(Piece, recuperer_piece_menacante(Plateau, FactionMenacante, CaseInDanger, Piece), ListePieces).

recuperer_koropokkuru([[koropokkuru, Sens, Faction, Case]|_], Faction, [koropokkuru, Sens, Faction, Case]).

recuperer_koropokkuru([_|Tail], Faction, Piece):-
    recuperer_koropokkuru(Tail, Faction, Piece).


faction_ennemie(moi, adv).
faction_ennemie(adv, moi).

koropokkuru_en_danger(Plateau, Faction, [Piece, Sens, Faction, Case], ListePieces):-
    recuperer_koropokkuru(Plateau, Faction, [Piece,Sens,Faction,Case]),
    faction_ennemie(Faction, FactionMenacante),
    recuperer_pieces_menacantes(Plateau, FactionMenacante, Case, ListePieces).

koropokkuru_en_echec_coup(Plateau, Faction, Coup):-
    koropokkuru_en_danger(Plateau, Faction, _, ListePieces),
    length(ListePieces, Nb),
    Nb == 1,
    koropokkuru_peut_etre_sauver_par_autre_piece(Plateau, Faction, ListePieces, Coup).

koropokkuru_en_echec_coup(Plateau, Faction, Coup):-
    koropokkuru_en_danger(Plateau, Faction, Koropokkuru, ListePieces),
    length(ListePieces, Nb),
    Nb > 0,
    koropokkuru_doit_bouger(Plateau, Koropokkuru, Coup).

koropokkuru_doit_bouger(Plateau, Koropokkuru, [[Piece, Sens, Faction, FromCase], ToCase, Gain]):-
    recuperer_tout_les_coups_piece(Plateau, Koropokkuru, ListeCoups),
    recuperer_meilleur_coup_piece(ListeCoups, [[Piece, Sens, Faction, FromCase], ToCase, Gain]),
    faction_ennemie(Faction, FactionEnnemie),
    recuperer_pieces_menacantes(Plateau, FactionEnnemie, ToCase, ListePieces),
    length(ListePieces, Nb),
    Nb == 0.

koropokkuru_peut_etre_sauver_par_autre_piece(Plateau, Faction, [[_,_,_,Case]], [[Type, Sens, Faction, Case1], Case, Cout]):-
    recuperer_pieces_menacantes(Plateau, Faction, Case, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, [[Type, Sens, Faction, Case1],Case, Cout]),
    Cout >= 0.

test_plateau_danger([
[oni, sud, moi, 0], [kirin, sud, moi, 1], [kirin, sud, moi, 2], [kirin, sud, moi, 3], [oni, sud, moi, 4],
[v, none, neutre, 5], [koropokkuru, nord, adv, 6], [kodama, nord, adv, 7], [v, none, neutre, 8], [v, none, neutre, 9],
[v, none, neutre, 10], [v, none, neutre, 11], [oni, nord, adv, 12], [kodama, sud, moi, 13], [v, none, neutre, 14],
[v, none, neutre, 15], [koropokkuru, sud, moi, 16], [kodama, nord, adv, 17], [kodama, nord, adv, 18], [v, none, neutre, 19],
[v, none, neutre, 20], [kodama, sud, moi, 21], [kodama, nord, adv, 22], [v, none, neutre, 23], [v, none, neutre, 24],
[oni, nord, adv, 25], [kirin, nord, adv, 26], [koropokkuru, nord, adv, 27], [kirin, nord, adv, 28], [oni, nord, adv, 29]
]).

test_koropokkuru_en_echec_coup(Coup):-
    test_plateau_danger(Plateau),
    koropokkuru_en_echec_coup(Plateau, moi, Coup).

test_danger_koropokkuru(ListePiecesMenacantes):-
    test_plateau_danger(Plateau),
    koropokkuru_en_danger(Plateau, moi,_, ListePiecesMenacantes).

test_danger_1(ListePiecesMenacantes):-
    test_plateau_danger(Plateau),
    recuperer_pieces_menacantes(Plateau, adv, 22, ListePiecesMenacantes).









