:- use_module(modulo1).

:- initialization(main).
main :-
    repeat,
    nl,
    writeln('====== LOGIEXPRESS - CONTORL DE VUELOS ======'),
    writeln('1. Modulo 1'),
    writeln('2. Modulo 2'),
    writeln('0. Salir'),
    write('Seleccione una opcion TIENES QUE P[ONER PUNTO AL FINAL: '),
    read(Sel),

    seleccion(Sel),

    Sel = 0,
    !.

seleccion(1) :-
    modulo1:menu.

seleccion(2) :-
    writeln('No hay').

seleccion(0) :-
    writeln('Terminando programa...').

seleccion(_) :-
    writeln('Opcion invalida.').