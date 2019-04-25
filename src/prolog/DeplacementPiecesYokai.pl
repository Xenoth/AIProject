can_move_o(Case):-
    Mod is mod(Case, 5),
    dif(Mod, 0).

can_move_e(Case):-
    Mod is mod(Case + 1, 5),
    dif(Mod, 0).

can_move_n(Case):-
    Case >= 5.

can_move_s(Case):-
    Case <= 24.

can_move_no(Case):-
    can_move_n(Case),
    can_move_o(Case).

can_move_ne(Case):-
    can_move_n(Case),
    can_move_e(Case).

can_move_so(Case):-
    can_move_s(Case),
    can_move_o(Case).

can_move_se(Case):-
    can_move_s(Case),
    can_move_e(Case).

move_n(Case, NvCase):-
    can_move_n(Case),
    NvCase = Case - 5.

move_s(Case, NvCase):-
    can_move_s(Case),
    NvCase = Case + 5.

move_e(Case, NvCase):-
    can_move_e(Case),
    NvCase = Case + 1.

move_o(Case, NvCase):-
    can_move_o(Case),
    NvCase = Case - 1.

move_ne(Case, NvCase):-
    can_move_ne(Case),
    NvCase = Case - 4.

move_no(Case, NvCase):-
    can_move_no(Case),
    NvCase = Case - 6.

move_se(Case, NvCase):-
    can_move_se(Case),
    NvCase = Case + 6.

move_so(Case, NvCase):-
    can_move_so(Case),
    NvCase = Case + 4.

% Kodoma Sud
move(kodoma, sud, Case, NvCase):-
    move_s(Case, NvCase).

% Kodoma Nord
move(kodoma, nord, Case, NvCase):-
    move_n(Case, NvCase).

% Kodoma Samourai Sud
move(kodoma_samourai, sud, Case, NvCase):-
    move_s(Case, NvCase).

move(kodoma_samourai, sud, Case, NvCase):-
    move_se(Case, NvCase).

move(kodoma_samourai, sud, Case, NvCase):-
    move_so(Case, NvCase).

move(kodoma_samourai, sud, Case, NvCase):-
    move_e(Case, NvCase).

move(kodoma_samourai, sud, Case, NvCase):-
    move_o(Case, NvCase).

% Kodoma Samourai Nord
move(kodoma_samourai, nord, Case, NvCase):-
    move_n(Case, NvCase).

move(kodoma_samourai, nord, Case, NvCase):-
    move_ne(Case, NvCase).

move(kodoma_samourai, nord, Case, NvCase):-
    move_no(Case, NvCase).

move(kodoma_samourai, nord, Case, NvCase):-
    move_e(Case, NvCase).

move(kodoma_samourai, nord, Case, NvCase):-
    move_o(Case, NvCase).

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

% Koropokkuru Sud
move(koropokkuru, sud, Case, NvCase):-
    move_n(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_ne(Case, NvCase).

move(koropokkuru, sud, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

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
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

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

