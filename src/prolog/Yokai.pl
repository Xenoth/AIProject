:-use_module(library(plunit)).
:-use_module(library(lists)).

:- include('DeplacementPiecesYokai.pl').

% Projet : Tournoi IA - Master 1 - UFC ST - Departement Info
% Auteur : Pol BAILLEUX
% Description : Fichier contenant les predicats pour recuperer le
% meilleurs coup a jouer.

% Exemple de plateau, debut de partie.
plateau([
[oni, sud, moi, 0], [kirin, sud, moi, 1], [koropokkuru, sud, moi, 2], [kirin, sud, moi, 3], [oni, sud, moi, 4],
[v, none, neutre, 5], [v, none, neutre, 6], [kodama, nord, adv, 7], [v, none, neutre, 8], [v, none, neutre, 9],
[v, none, neutre, 10], [kodama, sud, moi, 11], [kodama, sud, moi, 12], [kodama, sud, moi, 13], [v, none, neutre, 14],
[v, none, neutre, 15], [kodama, nord, adv, 16], [kodama, sud, moi, 17], [kodama, nord, adv, 18], [v, none, neutre, 19],
[v, none, neutre, 20], [v, none, neutre, 21], [v, none, neutre, 22], [v, none, neutre, 23], [v, none, neutre, 24],
[oni, nord, adv, 25], [kirin, nord, adv, 26], [koropokkuru, nord, adv, 27], [kirin, nord, adv, 28], [oni, nord, adv, 29]
]).

%% valeur_piece_sur_plateau(+TypePiece, -Valeur)
% Definit une Valeur en fonction du TypePiece donne.
valeur_piece_sur_plateau(v, 0).
valeur_piece_sur_plateau(kodama, 10).
valeur_piece_sur_plateau(oni, 25).
valeur_piece_sur_plateau(kodama_samourai, 55).
valeur_piece_sur_plateau(super_oni, 55).
valeur_piece_sur_plateau(kirin, 80).
valeur_piece_sur_plateau(koropokkuru, 2000).

%% valeur_promotion(+TypePiece, Valeur)
% Definit une Valeur pour promotion en fonction de TypePiece donne.
valeur_promotion(kodama, 50).
valeur_promotion(oni, 50).

%% coup_promotion(+TypePiece, +Sens, +ToCase, -Valeur)
% Retourne la Valeur si la TypePiece est promue lors du coup, si pas de
% promotion 0.
coup_promotion(kodama, sud, ToCase, Valeur):-
    ToCase >= 20,
    valeur_promotion(kodama, Valeur),!.

coup_promotion(kodama, nord, ToCase, Valeur):-
    ToCase < 10,
    valeur_promotion(kodama, Valeur),!.

coup_promotion(oni, sud, ToCase, Valeur):-
    ToCase >= 20,
    valeur_promotion(oni, Valeur),!.

coup_promotion(oni, nord, ToCase, Valeur):-
    ToCase < 10,
    valeur_promotion(oni, Valeur),!.

coup_promotion(_,_,_,0):-!.

%% perte_valeur_si_menace_a_arrivee(+Plateau, +Piece, +ToCase,
%% +ValeurPromotion, -Valeur)
% Retourne la Valeur a soustraire si la Piece est menacï¿½e a ToCase;
% Retourne 0 sinon.
perte_valeur_si_menace_a_arrivee(Plateau, [Type, _, Faction, _], ToCase, ValeurPromotion, Valeur):-
    faction_ennemie(Faction, FactionMenacante),
    recuperer_pieces_menacantes(Plateau, FactionMenacante, ToCase, ListePieces),
    length(ListePieces, Nb),
    dif(0, Nb),
    valeur_piece_sur_plateau(Type, Valeur1),
    Valeur is ValeurPromotion + Valeur1,!.

perte_valeur_si_menace_a_arrivee(_,_,_,_,0):-!.

%% deplacer_piece_sur_plateau(+Plateau, +Piece, -ToCase, -Valeur)
% Retourne ToCase la prochaine Case de la Piece et Valeur la valeur du
% deplacement.
deplacer_piece_sur_plateau(Plateau, [Type, Sens, Faction, FromCase], ToCase, Valeur):-
    move(Type, Sens, FromCase, ToCase),
    nth0(ToCase, Plateau, [TypePiece, _, FactionPiece, _]),
    dif(FactionPiece, Faction),
    coup_promotion(Type, Sens, ToCase, V2),
    valeur_piece_sur_plateau(TypePiece, V1),
    perte_valeur_si_menace_a_arrivee(Plateau, [Type, Sens, Faction, FromCase], ToCase, V2, V3),
    Valeur is V1 + V2 - V3.

%% recuperer_piece_faction(+Plateau, +Faction, -Piece)
% Trouve une Piece dans le Plateau appartenent a la Faction.
recuperer_piece_faction([[Piece,Sens,Faction,Case]|_], Faction, [Piece,Sens,Faction,Case]).

recuperer_piece_faction([_|Tail], Faction, Piece):-
    recuperer_piece_faction(Tail, Faction, Piece).

%% recuperer_pieces_faction(+Plateau, +Faction, -ListePiece)
% Retourne toutes les piece dans Plateau apparenent a Faction dans
% ListePieces.
recuperer_pieces_faction(Plateau, Faction, ListePieces):-
    findall(Piece, recuperer_piece_faction(Plateau, Faction, Piece), ListePieces).

%% recuperer_tout_les_coups_piece(+Plateau, +Piece, -ListeCoups)
% Retourne tout les Coups jouable par la Piece sur le Plateau.
recuperer_tout_les_coups_piece(Plateau, Piece, ListeCoups):-
    findall([Piece, ToCase, Cout], deplacer_piece_sur_plateau(Plateau,Piece,ToCase,Cout), ListeCoups).


recuperer_meilleur_coup_piece_acc([],Acc,Acc).

recuperer_meilleur_coup_piece_acc([[Piece,ToCase,Cout]|Tail], [_,_,Cout1],Res):-
    Cout > Cout1,
    recuperer_meilleur_coup_piece_acc(Tail,[Piece, ToCase, Cout], Res).

recuperer_meilleur_coup_piece_acc([_|Tail],Acc,Res):-
    recuperer_meilleur_coup_piece_acc(Tail,Acc,Res).

%% recuperer_meilleur_coup_piece(+ListeCoups, -Res)
% retourne Res le meilleur coup dans ListeCoups
recuperer_meilleur_coup_piece([],[]).

recuperer_meilleur_coup_piece([Coup|ListeCoups],Res):-
    recuperer_meilleur_coup_piece_acc(ListeCoups,Coup,Res),!.

recuperer_meilleur_coup_pieces_acc(_,[], Acc, Acc).

recuperer_meilleur_coup_pieces_acc(Plateau,[Piece|Tail],[_,_,Cout1],Res):-
    recuperer_tout_les_coups_piece(Plateau,Piece,ListeCoups),
    length(ListeCoups, Nb),
    Nb > 0,
    recuperer_meilleur_coup_piece(ListeCoups,[Piece, ToCase, Cout]),
    Cout > Cout1,
    recuperer_meilleur_coup_pieces_acc(Plateau, Tail, [Piece, ToCase, Cout], Res).


recuperer_meilleur_coup_pieces_acc(Plateau, [_|Tail], Acc, Res):-
    recuperer_meilleur_coup_pieces_acc(Plateau, Tail, Acc, Res).

%% recuperer_meilleur_coup_pieces(+Plateau, +ListePieces, -Coup)
% Retourne le meilleur coup de ListePieces sur le Plateau.
recuperer_meilleur_coup_pieces(Plateau, ListePieces, Coup):-
    recuperer_meilleur_coup_pieces_acc(Plateau, ListePieces,[_, _, -999999999999999], Coup),!.

:- begin_tests(recuperer_meilleur_coup).

test(coup_promotion_kodama_sud1, [true(R==V)]):-
    valeur_promotion(kodama, V),
    coup_promotion(kodama, sud, 20,R).

test(coup_promotion_kodama_sud2, [true(R==0)]):-
    valeur_promotion(kodama, _V),
    coup_promotion(kodama, sud, 0,R).

test(coup_promotion_kodama_sud3, [true(R==V)]):-
    valeur_promotion(kodama, V),
    coup_promotion(kodama, sud, 29,R).

test(coup_promotion_kodama_nord1, [true(R==V)]):-
    valeur_promotion(kodama, V),
    coup_promotion(kodama, nord, 9,R).

test(coup_promotion_kodama_nord2, [true(R==0)]):-
    valeur_promotion(kodama, _V),
    coup_promotion(kodama, nord, 27,R).

test(coup_promotion_kodama_nord3, [true(R==V)]):-
    valeur_promotion(kodama, V),
    coup_promotion(kodama, nord, 0,R).

test(coup_promotion_oni_nord, [true(R==V)]):-
    valeur_promotion(oni, V),
    coup_promotion(oni, nord, 9,R).

test_plateau([[v, none, neutre, 0],[v, none, neutre, 1],[v, none, neutre, 2],[v, none, neutre, 3],[v, none, neutre, 4],[v, none, neutre, 5],[kodama, sud, moi, 6],[kodama, sud, moi, 7],[kirin, sud, moi, 8],[oni, sud, moi, 9],[koropokkuru, sud, moi, 10],[oni, sud, moi, 11],[v, none, neutre, 12],[v, none, neutre, 13],[kirin, sud, moi, 14],[kodama, sud, moi, 15],[v, none, neutre, 16],[kodama, nord, adv, 17],[kodama, sud, moi, 18],[kodama, sud, moi, 19],[v, none, neutre, 20],[v, none, neutre, 21],[v, none, neutre, 22],[v, none, neutre, 23],[v, none, neutre, 24],[oni, nord, adv, 25],[kirin, nord, adv, 26],[koropokkuru, nord, adv, 27],[kirin, nord, adv, 28],[oni, nord, adv, 29]]).

test(recuperer_pieces_moi, [true(R==[[kodama,sud,moi,6],[kodama,sud,moi,7],[kirin,sud,moi,8],[oni,sud,moi,9],[koropokkuru,sud,moi,10],[oni,sud,moi,11],[kirin,sud,moi,14],[kodama,sud,moi,15],[kodama,sud,moi,18],[kodama,sud,moi,19]])]):-
    test_plateau(Plateau),
    recuperer_pieces_faction(Plateau, moi, R).

test(recuperer_pieces_adv, [true(R==[[kodama,nord,adv,17],[oni,nord,adv,25],[kirin,nord,adv,26],[koropokkuru,nord,adv,27],[kirin,nord,adv,28],[oni,nord,adv,29]])]):-
    test_plateau(Plateau),
    recuperer_pieces_faction(Plateau, adv, R).


test(recuperer_coups_piece1, [true(R==[[[kirin,sud,moi,1],5,0],[[kirin,sud,moi,1],2,0],[[kirin,sud,moi,1],0,0]])]):-
    test_plateau(Plateau),
    recuperer_tout_les_coups_piece(Plateau, [kirin,sud,moi,1],R).

test(recuperer_meilleur_coup_piece_vide, [true(R==[])]):-
    recuperer_meilleur_coup_piece([], R).

test(recuperer_tout_les_coup_piece_ne_pouvant_bouger, [true(R=[])]):-
    test_plateau(Plateau),
    recuperer_tout_les_coups_piece(Plateau, [kodama,sud,moi,29],R).

test(recuperer_meilleur_coup_pieces, [true(R==[[oni,sud,moi,11],17,10])]):-
    test_plateau(Plateau),
    recuperer_pieces_faction(Plateau, moi, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, R).

:- end_tests(recuperer_meilleur_coup).

%% recuperer_meilleur_coup_v1(+Plateau, +Faction, -FromCase, -ToCase)
% Predicat appele par Jasper.
% Retourne FromCase et ToCase le coup a jouer en deplacant une piece.
recuperer_meilleur_coup_v1(Plateau, Faction, FromCase, ToCase):-
    recuperer_pieces_faction(Plateau, Faction, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, [[_,_,_,FromCase], ToCase,_]).

%% recuperer_meilleur_coup_v2(+Plateau, +Faction, -FromCase, -ToCase,
% Gain)
% Predicat appele par Jasper.
% Retourne FromCase et ToCase le coup a jouer en deplacant une piece en
% renseignant la valeur. Amelioration de V1 en verifiant si koropokkuru
% est en echec et doit etre sauver.
recuperer_meilleur_coup_v2(Plateau, Faction, FromCase, ToCase, Gain):-
    koropokkuru_en_echec_coup(Plateau, Faction, [[_,_,_,FromCase], ToCase, Gain]),!.

recuperer_meilleur_coup_v2(Plateau, Faction, FromCase, ToCase, Gain):-
    recuperer_pieces_faction(Plateau, Faction, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, [[_,_,_,FromCase], ToCase,Gain]),!.

%% recuperer_piece_menancante(+Plateau, +FactionMenacante,
%% +CaseInDanger, -Piece)
% Retourne une Piece de la FactionMenancante pouvant se deplacer vers
% CaseInDanger.
recuperer_piece_menacante([[Piece,Sens,FactionMenacante,Case]|_], FactionMenacante, CaseInDanger, [Piece,Sens,FactionMenacante,Case]):-
    move(Piece,Sens,Case,CaseInDanger).

recuperer_piece_menacante([_|Tail], FactionMenacante, CaseInDanger, Piece):-
    recuperer_piece_menacante(Tail, FactionMenacante, CaseInDanger, Piece).

%% recuperer_piece_menancantes(+Plateau, +FactionMenacante,
%% +CaseInDanger, -ListePieces)
% Retourne une ListePieces de la FactionMenancante pouvant se deplacer
% vers CaseInDanger.
recuperer_pieces_menacantes(Plateau, FactionMenacante, CaseInDanger, ListePieces):-
    findall(Piece, recuperer_piece_menacante(Plateau, FactionMenacante, CaseInDanger, Piece), ListePieces).

%% recuperer_koropokkuru(+Plateau, +Faction, -Koropokkuru)
% Retourne la piece Koropokkuru de la Faction donne dans le Plateau.
recuperer_koropokkuru([[koropokkuru, Sens, Faction, Case]|_], Faction, [koropokkuru, Sens, Faction, Case]).

recuperer_koropokkuru([_|Tail], Faction, Piece):-
    recuperer_koropokkuru(Tail, Faction, Piece).

%% faction_ennemir(+Faction, -FactionEnnemie)
% Retourne la FactionEnnemie de Faction.
faction_ennemie(moi, adv).
faction_ennemie(adv, moi).

%% koropokkuru_en_danger(+Plateau, +Faction, -Koropokkuru, -ListePieces)
% Retourne Le Koropokkuru de la Faction donne et ListePieces les pieces
% le menacant.
koropokkuru_en_danger(Plateau, Faction, [Piece, Sens, Faction, Case], ListePieces):-
    recuperer_koropokkuru(Plateau, Faction, [Piece,Sens,Faction,Case]),
    faction_ennemie(Faction, FactionMenacante),
    recuperer_pieces_menacantes(Plateau, FactionMenacante, Case, ListePieces).

%% koropokkuru_en_echec_coup(+Plateau, +Faction, -Coup)
% Si le Koropokkuru est en danger on retourne un Coup pour le sauver.
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

%% koropokkuru_doit_bouger(+Plateau, +Koropokkuru, -Piece, -ToCase,
%% -Valeur)
% Retourne Piece identique a Koropokkuru se deplacant sur ToCase ou
% Koropokkuru sera sauve.
koropokkuru_doit_bouger(Plateau, Koropokkuru, [[Piece, Sens, Faction, FromCase], ToCase, Gain]):-
    recuperer_tout_les_coups_piece(Plateau, Koropokkuru, ListeCoups),
    recuperer_meilleur_coup_piece(ListeCoups, [[Piece, Sens, Faction, FromCase], ToCase, Gain]),
    faction_ennemie(Faction, FactionEnnemie),
    recuperer_pieces_menacantes(Plateau, FactionEnnemie, ToCase, ListePieces),
    length(ListePieces, Nb),
    Nb == 0.

%% koropokkuru_peut_etre_sauver_par_autre_piece(+Plateau, +Faction,
%% -Koropokkuru, -Coup)
% Retourne le Coup a jouer pour sauver le Koropokkuru de la Faction par
% une autre piece de sa faction.
koropokkuru_peut_etre_sauver_par_autre_piece(Plateau, Faction, [[_,_,_,Case]], [[Type, Sens, Faction, Case1], Case, Cout]):-
    recuperer_pieces_menacantes(Plateau, Faction, Case, ListePieces),
    recuperer_meilleur_coup_pieces(Plateau, ListePieces, [[Type, Sens, Faction, Case1],Case, Cout]),
    Cout >= 0.

:- begin_tests(sauver_koropokkuru).

test_plateau_danger([
[oni, sud, moi, 0], [kirin, sud, moi, 1], [kirin, sud, moi, 2], [kirin, sud, moi, 3], [oni, sud, moi, 4],
[v, none, neutre, 5], [koropokkuru, nord, adv, 6], [kodama, nord, adv, 7], [v, none, neutre, 8], [v, none, neutre, 9],
[v, none, neutre, 10], [v, none, neutre, 11], [oni, nord, adv, 12], [kodama, sud, moi, 13], [v, none, neutre, 14],
[v, none, neutre, 15], [koropokkuru, sud, moi, 16], [kodama, nord, adv, 17], [kodama, nord, adv, 18], [v, none, neutre, 19],
[v, none, neutre, 20], [kodama, sud, moi, 21], [kodama, nord, adv, 22], [v, none, neutre, 23], [v, none, neutre, 24],
[oni, nord, adv, 25], [kirin, nord, adv, 26], [koropokkuru, nord, adv, 27], [kirin, nord, adv, 28], [oni, nord, adv, 29]
]).

test(koropokkuru_en_echec_coup, [true(R==[[koropokkuru,sud,moi,16],15,0])]):-
    test_plateau_danger(Plateau),
    koropokkuru_en_echec_coup(Plateau, moi, R).

test(danger_koropokkuru, [true(R==[[oni,nord,adv,12]])]):-
    test_plateau_danger(Plateau),
    koropokkuru_en_danger(Plateau, moi,_, R).

test(pieces_menacantes, [true(R==[[kirin,nord,adv,26],[koropokkuru,nord,adv,27],[kirin,nord,adv,28]])]):-
    test_plateau_danger(Plateau),
    recuperer_pieces_menacantes(Plateau, adv, 22, R).

:- end_tests(sauver_koropokkuru).

recuperer_meilleur_piece_a_poser_acc([], Acc, Acc).

recuperer_meilleur_piece_a_poser_acc([Piece|Tail],Acc,Res):-
    valeur_piece_sur_plateau(Piece, V1),
    valeur_piece_sur_plateau(Acc, V2),
    V1 > V2,
    recuperer_meilleur_piece_a_poser_acc(Tail, Piece, Res).

recuperer_meilleur_piece_a_poser_acc([_|Tail],Acc,Res):-
    recuperer_meilleur_piece_a_poser_acc(Tail, Acc, Res).

%% recuperer_meilleur_piece_a_poser(+ListePiece, -Res)
% Retourne la meilleur piece disponible dans la liste : kodama < orin <
% kirin.
recuperer_meilleur_piece_a_poser([Piece|Tail],Res):-
    recuperer_meilleur_piece_a_poser_acc(Tail, Piece, Res),!.

%% recuperer_case_kodama_faction(+Plateau, +Faction, -Case)
% Retourne une case ou se trouve un kodama de la Faction dans le
% Plateau.
recuperer_case_kodama_faction([[kodama,_, Faction, Case]|_], Faction, Case).

recuperer_case_kodama_faction([_|Tail], Faction, Case):-
    recuperer_case_kodama_faction(Tail, Faction, Case).

%% recuperer_cases_kodama_faction(+Plateau, +Faction, -ListeCases)
% Retourne toute les cases ou se trouve les kodama de la Faction sur le
% Plateau.
recuperer_cases_kodama_faction(Plateau, Faction, ListeCases):-
    findall(Case, recuperer_case_kodama_faction(Plateau, Faction, Case), ListeCases).

%% cases_differente_colonne(+Case, +OtherCase)
% true si les cases ne sont pas sur la meme colonne.
cases_differente_colonne(Case, OtherCase):-
    C1 is mod(Case, 5),
    C2 is mod(OtherCase, 5),
    dif(C1,C2).

%% case_differente_colonne_liste_cases(+Case, +ListeCases)
% true si la Case n'est pas sur la meme colonne que les cases dans la
% ListeCases.
case_differente_colonne_liste_cases(_, []):-!.

case_differente_colonne_liste_cases(Case, [Head|Tail]):-
    cases_differente_colonne(Head, Case),
    case_differente_colonne_liste_cases(Case, Tail).

%% kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(+Plateau,
%% +Faction, +CaseToPlace)
% true si il n y a pas d autres kodama de la Faction sur le Plateau sur
% la colonne de CaseToPlace.
kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(Plateau, Faction, CaseToPlace):-
    recuperer_cases_kodama_faction(Plateau, Faction, ListeCases),
    case_differente_colonne_liste_cases(CaseToPlace, ListeCases).

%% kodama_ne_touche_pas_ligne_en_face(+Sens, +CaseToPlace)
% true si la CaseToPlace ou l on cherche a deposer notre kodama n est
% pas sur la derniere ligne en face de lui.
kodama_ne_touche_pas_ligne_en_face(sud, CaseToPlace):-
    CaseToPlace < 25,!.

kodama_ne_touche_pas_ligne_en_face(nord, CaseToPlace):-
    CaseToPlace > 4,!.

%% piece_peut_etre_pose(+Plateau, +Piece, +Sens, +Faction, +CaseToPlace)
% true si la CaseToPlace donnee remplie les conditions pour poser la
% Piece donnee.
piece_peut_etre_pose(Plateau, kodama, Sens, Faction, CaseToPlace):-
    !,kodama_ne_touche_pas_ligne_en_face(Sens, CaseToPlace),
    kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(Plateau, Faction, CaseToPlace),
    nth0(CaseToPlace, Plateau, [TypePiece, _, _, _]),
    valeur_piece_sur_plateau(TypePiece, V),
    V == 0,
    faction_ennemie(Faction, FactionMenacante),
    recuperer_pieces_menacantes(Plateau, FactionMenacante, CaseToPlace, ListePieces),
    length(ListePieces, Nb),
    Nb == 0.

piece_peut_etre_pose(Plateau,_,_, Faction, CaseToPlace):-
    nth0(CaseToPlace, Plateau, [TypePiece, _, _, _]),
    valeur_piece_sur_plateau(TypePiece, V),
    V == 0,
    faction_ennemie(Faction, FactionMenacante),
    recuperer_pieces_menacantes(Plateau, FactionMenacante, CaseToPlace, ListePieces),
    length(ListePieces, Nb),
    Nb == 0.

%% liste_num_case(+Sens, -ListeCases)
% Retourne la liste des cases desiree en fonction de l orientation.
% Si on est oriente sud on prefere agresser le joueur adv en posant le
% plus pres possible de lui, donc de 29 a 0.
liste_num_case(sud, [29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]).
liste_num_case(nord, [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29]).

%% trouver_placement_piece(+Plateau, +Piece, +Faction +Sens,
%% +ListeCases, -Case)
% Retourne une case viable pour poser la Piece donnée.
trouver_placement_piece(_Plateau, _Piece, _Faction, _Sens, [], Case):-
    Case is -1.

trouver_placement_piece(Plateau, Piece, Faction, Sens, [Case|_], Case):-
    piece_peut_etre_pose(Plateau, Piece, Sens, Faction, Case),!.

trouver_placement_piece(Plateau, Piece, Faction, Sens, [_|Tail], Case):-
    trouver_placement_piece(Plateau, Piece, Faction, Sens, Tail, Case).

%% recuperer_meilleur_placement_piece_v1(+Plateau,
%% +ListePiecesCapturees, +Faction, +Sens, -Piece, -CaseToPlace,
%% -Valeur)
% A appeler avec jasper pour connaitre la meilleur Piece a poser et sur
% quelle CaseToPlace.
recuperer_meilleur_placement_piece_v1(Plateau, ListePiecesCapturees, Faction, Sens, Piece, CaseToPlace, Valeur):-
    liste_num_case(Sens, ListeCases),
    recuperer_meilleur_piece_a_poser(ListePiecesCapturees, Piece),
    trouver_placement_piece(Plateau, Piece, Faction, Sens, ListeCases, CaseToPlace),
    valeur_piece_sur_plateau(Piece, Valeur).

:- begin_tests(poser).

test_plateau_poser([
[oni, sud, moi, 0], [kirin, sud, moi, 1], [kirin, sud, moi, 2], [kirin, sud, moi, 3], [oni, sud, moi, 4],
[v, none, neutre, 5], [v, none, neutre, 6], [kodama, sud, moi, 7], [v, none, neutre, 8], [v, none, neutre, 9],
[v, none, neutre, 10], [v, none, neutre, 11], [oni, nord, adv, 12], [kodama, sud, moi, 13], [v, none, neutre, 14],
[kodama, sud, moi, 15], [v, none, neutre, 16], [v, none, neutre, 17], [kodama, nord, adv, 18], [v, none, neutre, 19],
[v, none, neutre, 20], [kodama, sud, moi, 21], [kodama, nord, adv, 22], [v, none, neutre, 23], [v, none, neutre, 24],
[v, none, neutre, 25], [v, none, neutre, 26], [koropokkuru, nord, adv, 27], [kirin, nord, adv, 28], [oni, nord, adv, 29]
]).

test(kodama_ne_se_trouve_pas_sur_meme_colonne1, [fail]):-
    test_plateau_poser(Plateau),
    kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(Plateau, moi, 0).

test(kodama_ne_se_trouve_pas_sur_meme_colonne2, [fail]):-
    test_plateau_poser(Plateau),
    kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(Plateau, moi, 11).

test(kodama_ne_se_trouve_pas_sur_meme_colonne3, [fail]):-
    test_plateau_poser(Plateau),
    kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(Plateau, moi, 17).

test(kodama_ne_se_trouve_pas_sur_meme_colonne4, [fail]):-
    test_plateau_poser(Plateau),
    kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(Plateau, moi, 23).

test(kodama_ne_se_trouve_pas_sur_meme_colonne5, [true]):-
    test_plateau_poser(Plateau),
    kodama_ne_se_trouve_pas_sur_meme_colonne_que_autres(Plateau, moi, 14).


test(recuperer_meilleur_piece_a_poser1, [true(R==kirin)]):-
    recuperer_meilleur_piece_a_poser([kodama, kirin, oni], R).

test(recuperer_meilleur_piece_a_poser2, [true(R==oni)]):-
    recuperer_meilleur_piece_a_poser([kodama, oni], R).

test(recuperer_meilleur_piece_a_poser3, [true(R==kodama)]):-
    recuperer_meilleur_piece_a_poser([kodama], R).

test(piece_peut_etre_pose, [true]):-
    test_plateau_poser(Plateau),
    piece_peut_etre_pose(Plateau, kodama, sud, moi,14).

:- end_tests(poser).












