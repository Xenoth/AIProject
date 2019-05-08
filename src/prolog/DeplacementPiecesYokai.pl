:-use_module(library(plunit)).

% Projet : Tournoi IA - Master 1 - UFC ST - Departement Info
% Auteur : Pol BAILLEUX
% Description : Fichier contenant les predicats permettant de deplacer
% les differentes pieces du jeu Yokai no-mori

% can_move_o(+Case)
% Regarde si peut se deplacer a gauche depuis Case.
can_move_o(Case):-
    Mod is mod(Case, 5),
    dif(Mod, 0).

%% can_move_e(+Case)
% Regarde si peut se deplacer a droite depuis Case.
can_move_e(Case):-
    Mod is mod(Case + 1, 5),
    dif(Mod, 0).

%% can_move_n(+Case)
% Regarde si peut se deplacer en haut depuis Case.
can_move_n(Case):-
    Case >= 5.

%% can_move_s(+Case)
% Regarde si peut se deplacer en bas depuis Case.
can_move_s(Case):-
    Case =< 24.

%% can_move_no(+Case)
% Regarde si peut se deplacer en haut a gauche depuis Case.
can_move_no(Case):-
    can_move_n(Case),
    can_move_o(Case).

%% can_move_ne(+Case)
% Regarde si peut se deplacer en haut a droite depuis Case.
can_move_ne(Case):-
    can_move_n(Case),
    can_move_e(Case).

%% can_move_so(+Case)
% Regarde si peut se deplacer en bas a gauche depuis Case.
can_move_so(Case):-
    can_move_s(Case),
    can_move_o(Case).

%% can_move_se(+Case)
% Regarde si peut se deplacer en bas a droite depuis Case.
can_move_se(Case):-
    can_move_s(Case),
    can_move_e(Case).

%% move_n(+Case, -NvCase)
% Donne la NvCase en haut de Case.
move_n(Case, NvCase):-
    can_move_n(Case),
    NvCase is Case - 5.

%% move_s(+Case, -NvCase)
% Donne la NvCase en bas de Case.
move_s(Case, NvCase):-
    can_move_s(Case),
    NvCase is Case + 5.

%% move_e(+Case, -NvCase)
% Donne la NvCase a droite de Case.
move_e(Case, NvCase):-
    can_move_e(Case),
    NvCase is Case + 1.

%% move_o(+Case, -NvCase)
% Donne la NvCase a gauche de Case.
move_o(Case, NvCase):-
    can_move_o(Case),
    NvCase is Case - 1.

%% move_ne(+Case, -NvCase)
% Donne la NvCase en haut a droite de Case.
move_ne(Case, NvCase):-
    can_move_ne(Case),
    NvCase is Case - 4.

%% move_no(+Case, -NvCase)
% Donne la NvCase en haut a gauche de Case.
move_no(Case, NvCase):-
    can_move_no(Case),
    NvCase is Case - 6.

%% move_se(+Case, -NvCase)
% Donne la NvCase en bas a droite de Case.
move_se(Case, NvCase):-
    can_move_se(Case),
    NvCase is Case + 6.

%% move_so(+Case, -NvCase)
% Donne la NvCase en bas a gauche de Case.
move_so(Case, NvCase):-
    can_move_so(Case),
    NvCase is Case + 4.

%% move(+TypePiece, +Sens, -NvCase)
% Deplace un TypePiece en fonction de son Sens, et de la Case;
% Retourne la NvCase.
move(kodama, sud, Case, NvCase):-
    move_s(Case, NvCase).

% kodama Nord
move(kodama, nord, Case, NvCase):-
    move_n(Case, NvCase).

% kodama Samourai Sud
move(kodama_samourai, sud, Case, NvCase):-
    move_s(Case, NvCase).

move(kodama_samourai, sud, Case, NvCase):-
    move_se(Case, NvCase).

move(kodama_samourai, sud, Case, NvCase):-
    move_so(Case, NvCase).

move(kodama_samourai, sud, Case, NvCase):-
    move_e(Case, NvCase).

move(kodama_samourai, sud, Case, NvCase):-
    move_o(Case, NvCase).

move(kodama_samourai, sud, Case, NvCase):-
    move_s(Case, NvCase).

% kodama Samourai Nord
move(kodama_samourai, nord, Case, NvCase):-
    move_n(Case, NvCase).

move(kodama_samourai, nord, Case, NvCase):-
    move_ne(Case, NvCase).

move(kodama_samourai, nord, Case, NvCase):-
    move_no(Case, NvCase).

move(kodama_samourai, nord, Case, NvCase):-
    move_e(Case, NvCase).

move(kodama_samourai, nord, Case, NvCase):-
    move_o(Case, NvCase).

move(kodama_samourai, nord, Case, NvCase):-
    move_s(Case, NvCase).

% Kirin Sud
move(kirin, sud, Case, NvCase):-
    move_s(Case, NvCase).

move(kirin, sud, Case, NvCase):-
    move_se(Case, NvCase).

move(kirin, sud, Case, NvCase):-
    move_so(Case, NvCase).

move(kirin, sud, Case, NvCase):-
    move_e(Case, NvCase).

move(kirin, sud, Case, NvCase):-
    move_o(Case, NvCase).

move(kirin, sud, Case, NvCase):-
    move_n(Case, NvCase).

% Kirin Nord
move(kirin, nord, Case, NvCase):-
    move_n(Case, NvCase).

move(kirin, nord, Case, NvCase):-
    move_ne(Case, NvCase).

move(kirin, nord, Case, NvCase):-
    move_no(Case, NvCase).

move(kirin, nord, Case, NvCase):-
    move_e(Case, NvCase).

move(kirin, nord, Case, NvCase):-
    move_o(Case, NvCase).

move(kirin, nord, Case, NvCase):-
    move_s(Case, NvCase).

% Koropokkuru Sud
move(koropokkuru, sud, Case, NvCase):-
    move_n(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_ne(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_no(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_e(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_o(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_s(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_se(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_so(Case, NvCase).

% Koropokkuru Nord
move(koropokkuru, nord, Case, NvCase):-
    move_n(Case, NvCase).

move(koropokkuru, nord, Case, NvCase):-
    move_ne(Case, NvCase).

move(koropokkuru, nord, Case, NvCase):-
    move_no(Case, NvCase).

move(koropokkuru, nord, Case, NvCase):-
    move_e(Case, NvCase).

move(koropokkuru, nord, Case, NvCase):-
    move_o(Case, NvCase).

move(koropokkuru, nord, Case, NvCase):-
    move_s(Case, NvCase).

move(koropokkuru, nord, Case, NvCase):-
    move_se(Case, NvCase).

move(koropokkuru, nord, Case, NvCase):-
    move_so(Case, NvCase).

% Oni Sud
move(oni, sud, Case, NvCase):-
    move_s(Case, NvCase).

move(oni, sud, Case, NvCase):-
    move_se(Case, NvCase).

move(oni, sud, Case, NvCase):-
    move_so(Case, NvCase).

move(oni, sud, Case, NvCase):-
    move_ne(Case, NvCase).

move(oni, sud, Case, NvCase):-
    move_no(Case, NvCase).

% Oni Nord
move(oni, nord, Case, NvCase):-
    move_n(Case, NvCase).

move(oni, nord, Case, NvCase):-
    move_ne(Case, NvCase).

move(oni, nord, Case, NvCase):-
    move_no(Case, NvCase).

move(oni, nord, Case, NvCase):-
    move_se(Case, NvCase).

move(oni, nord, Case, NvCase):-
    move_so(Case, NvCase).

% Super Oni Sud
move(super_oni, sud, Case, NvCase):-
    move_n(Case, NvCase).

move(super_oni, sud, Case, NvCase):-
    move_o(Case, NvCase).

move(super_oni, sud, Case, NvCase):-
    move_e(Case, NvCase).

move(super_oni, sud, Case, NvCase):-
    move_se(Case, NvCase).

move(super_oni, sud, Case, NvCase):-
    move_so(Case, NvCase).

move(super_oni, sud, Case, NvCase):-
    move_s(Case, NvCase).

% Super Oni Nord
move(super_oni, nord, Case, NvCase):-
    move_s(Case, NvCase).

move(super_oni, nord, Case, NvCase):-
    move_o(Case, NvCase).

move(super_oni, nord, Case, NvCase):-
    move_e(Case, NvCase).

move(super_oni, nord, Case, NvCase):-
    move_ne(Case, NvCase).

move(super_oni, nord, Case, NvCase):-
    move_no(Case, NvCase).

move(super_oni, nord, Case, NvCase):-
    move_n(Case, NvCase).

:- begin_tests(move).

test(can_move_e, [true]):-
    can_move_e(0).

test(cannot_move_e, [fail]):-
    can_move_e(4).

test(can_move_o, [true]):-
    can_move_o(4).

test(cannot_move_o, [fail]):-
    can_move_o(0).

test(can_move_n, [true]):-
    can_move_n(5).

test(cannot_move_e, [fail]):-
    can_move_n(2).

test(can_move_s, [true]):-
    can_move_s(4).

test(cannot_move_s, [fail]):-
    can_move_s(27).

test(can_move_se, [true]):-
    can_move_se(3).

test(cannot_move_se, [fail]):-
    can_move_se(4).

test(can_move_so, [true]):-
    can_move_so(3).

test(cannot_move_so, [fail]):-
    can_move_so(25).

test(can_move_ne, [true]):-
    can_move_ne(17).

test(cannot_move_ne, [fail]):-
    can_move_ne(0).

test(can_move_no, [true]):-
    can_move_no(17).

test(cannot_move_no, [fail]):-
    can_move_no(25).

test(move_kodama_sud, [true(NvCase==20)]):-
    move(kodama, sud, 15, NvCase).

test(move_kodama_nord, [true(NvCase==0)]):-
    move(kodama, nord, 5, NvCase).

test(move_oni, [true(Moves==[20,21,11])]):-
    findall(N, move(oni, sud, 15, N), Moves).

test(move_kodoma_bloque, [true(Moves==[])]):-
    findall(N, move(kodoma, nord, 0, N), Moves).

test(move_oni_mid, [true(Moves==[22, 23, 21, 13, 11])]):-
    findall(N, move(oni, sud, 17, N), Moves).

test(move_oni_mid, [true(Moves==[12, 13, 11, 23, 21])]):-
    findall(N, move(oni, nord, 17, N), Moves).

test(move_kirin, [true(Moves==[12, 13, 11, 18, 16, 22])]):-
    findall(N, move(kirin, nord, 17, N), Moves).

test(move_kodama_samourai, [true(Moves==[12,13,11,18,16,22])]):-
    findall(N, move(kodama_samourai, nord, 17, N), Moves).

test(move_super_oni, [true(Moves==[22,16,18,13,11,12])]):-
    findall(N, move(super_oni, nord, 17, N), Moves).

test(move_koropokkuru, [true(Moves=[12, 13, 11, 18, 16, 22, 23, 21])]):-
    findall(N, move(koropokkuru, sud, 17, N), Moves).

test(move_koropokkuru_coin, [true(Moves==[20,21,26])]):-
    findall(N, move(koropokkuru, sud, 25, N), Moves).

:- end_tests(move).
