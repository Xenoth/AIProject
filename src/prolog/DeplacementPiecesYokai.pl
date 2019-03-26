case_valide(Case, NvCase):-
    NvCase >= Case - 6,
    NvCase =< Case - 4.

case_valide(Case, NvCase):-
    NvCase >= Case - 1,
    NvCase =< Case + 1,
    dif(NvCase,Case).

case_valide(Case, NvCase):-
    NvCase >= Case + 4,
    NvCase =< Case + 6.

move_n(Case, NvCase):-
    NvCase = Case - 5.

move_s(Case, NvCase):-
    NvCase = Case + 5.

move_e(Case, NvCase):-
    NvCase = Case + 1.

move_o(Case, NvCase):-
    NvCase = Case - 1.

move_ne(Case, NvCase):-
    NvCase = Case - 4.

move_no(Case, NvCase):-
    NvCase = Case - 6.

move_se(Case, NvCase):-
    NvCase = Case + 6.

move_so(Case, NvCase):-
    NvCase = Case + 4.

% Kodoma Sud
move(kodoma_s, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case, NvCase).

% Kodoma Nord
move(kodoma_n, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case, NvCase).

% Kodoma Samourai Sud
move(kodoma_samourai_s, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_s, Case, NvCase):-
    move_se(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_s, Case, NvCase):-
    move_so(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_s, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_s, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

% Kodoma Samourai Nord
move(kodoma_samourai_n, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_n, Case, NvCase):-
    move_ne(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_n, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_n, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(kodoma_samourai_n, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

% Kirin Sud
move(kirin_s, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_s, Case, NvCase):-
    move_se(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_s, Case, NvCase):-
    move_so(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_s, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_s, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

% Kirin Nord
move(kirin_n, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_n, Case, NvCase):-
    move_ne(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_n, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_n, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(kirin_n, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

% Koropokkuru Sud
move(koropokkuru_s, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_s, Case, NvCase):-
    move_ne(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_s, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_s, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_s, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_s, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_s, Case, NvCase):-
    move_se(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_s, Case, NvCase):-
    move_so(Case, NvCase),
    case_valide(Case,NvCase).

% Koropokkuru Nord
move(koropokkuru_n, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_n, Case, NvCase):-
    move_ne(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_n, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_n, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_n, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_n, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_n, Case, NvCase):-
    move_se(Case, NvCase),
    case_valide(Case,NvCase).

move(koropokkuru_n, Case, NvCase):-
    move_so(Case, NvCase),
    case_valide(Case,NvCase).

% Oni Sud
move(oni_s, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_s, Case, NvCase):-
    move_se(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_s, Case, NvCase):-
    move_so(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_s, Case, NvCase):-
    move_ne(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_s, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

% Oni Nord
move(oni_n, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_n, Case, NvCase):-
    move_ne(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_n, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_n, Case, NvCase):-
    move_se(Case, NvCase),
    case_valide(Case,NvCase).

move(oni_n, Case, NvCase):-
    move_so(Case, NvCase),
    case_valide(Case,NvCase).

% Super Oni Sud
move(super_oni_s, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_s, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_s, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_s, Case, NvCase):-
    move_se(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_s, Case, NvCase):-
    move_so(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_s, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case,NvCase).

% Super Oni Nord
move(super_oni_n, Case, NvCase):-
    move_s(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_n, Case, NvCase):-
    move_o(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_n, Case, NvCase):-
    move_e(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_n, Case, NvCase):-
    move_ne(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_n, Case, NvCase):-
    move_no(Case, NvCase),
    case_valide(Case,NvCase).

move(super_oni_n, Case, NvCase):-
    move_n(Case, NvCase),
    case_valide(Case,NvCase).