:- module(modulo1, [menu/0]).

:- dynamic vuelo/7.
:- dynamic tmc/1.

% los pasajerois esperan minimo 45 min entre la llegada de un vuelo y la salida otro
tmc(45).

cargar_vuelos(Archivo) :-
    retractall(vuelo(_,_,_,_,_,_,_)),
    open(Archivo, read, Flujo),
    leer_vuelos(Flujo),
    close(Flujo).

leer_vuelos(Flujo) :-
    read_line_to_string(Flujo, Linea),
    (
        Linea == end_of_file
        ->
        true
        ;
        (
            Linea \= "",
            parsear_vuelo(Linea)
            ->
            leer_vuelos(Flujo)
            ;
            leer_vuelos(Flujo)
        )
    ).

parsear_vuelo(Linea) :-
    split_string(Linea, "|", "", Campos),
    Campos = [
        Origen,
        Destino,
        Salida,
        Llegada,
        CostoTexto,
        Codigo,
        Dias
    ],
    number_string(Costo, CostoTexto),
    assertz(vuelo(
        Origen,
        Destino,
        Salida,
        Llegada,
        Costo,
        Codigo,
        Dias
    )).

configurar_tmc(Minutos) :-
    number(Minutos),
    Minutos >= 0,
    retractall(tmc(_)),
    assertz(tmc(Minutos)).


% Dada una ciudad C, generar la lista de todos los vuelos que salen de ella

vuelos_salida(Ciudad, Lista) :-
    findall(
        vuelo(O,D,S,L,C,Cod,Dia),
        vuelo(Ciudad,D,S,L,C,Cod,Dia),
        Lista
    ).

% Dada una ciudad C, generar la lista de todos los vuelos que llegan a ella

vuelos_llegada(Ciudad, Lista) :-
    findall(
        vuelo(O,Ciudad,S,L,C,Cod,Dia),
        vuelo(O,Ciudad,S,L,C,Cod,Dia),
        Lista
    ).

    

mostrar_vuelos([]).

mostrar_vuelos([
    vuelo(O,D,S,L,C,Cod,Dia)|Resto
]) :-
    format(
        '~nCodigo: ~w | ~w -> ~w | Salida: ~w | Llegada: ~w | Costo: ~w | Dias: ~w',
        [Cod,O,D,S,L,C,Dia]
    ),
    mostrar_vuelos(Resto).



%cli
menu :-
    repeat,
    nl,
    writeln('====== MODULO 1 ======'),
    writeln('1. Cargar vuelos'),
    writeln('2. Consultar vuelos de salida'),
    writeln('3. Consultar vuelos de llegada'),
    writeln('4. Configurar TMC'),
    writeln('0. Volver'),
    write('Seleccione una opcion: '),

    read(Sel),

    seleccion(Sel),

    Sel = 0,
    !.

seleccion(1) :-
    cargar_vuelos('vuelos.txt'),
    writeln('Vuelos cargados correctamente.').

seleccion(2) :-
    write('Ingrese la ciudad: '),
    read(Ciudad),
    vuelos_salida(Ciudad, Lista),
    mostrar_vuelos(Lista).

seleccion(3) :-
    write('Ingrese la ciudad: '),
    read(Ciudad),
    vuelos_llegada(Ciudad, Lista),
    mostrar_vuelos(Lista).

seleccion(4) :-
    write('Ingrese el TMC en minutos: '),
    read(Minutos),
    configurar_tmc(Minutos).

seleccion(0) :-
    writeln('A').

seleccion(_) :-
    writeln('Opcion invalida.').

vuelos_cargados(Lista) :-
    findall(
        vuelo(O,D,S,L,C,Cod,Dia),
        vuelo(O,D,S,L,C,Cod,Dia),
        Lista
    ).