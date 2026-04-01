function kb = aktualizuj_kb(kb, pozice, percept)               % aktualizuje knowledge base podle aktualni percepce
i = pozice(1);                                                 % radek aktualni pozice
j = pozice(2);                                                 % sloupec aktualni pozice
N = size(kb.navstivena,1);                                     % velikost mrizky podle KB

kb.navstivena(i,j) = true;                                     % aktualni pole je navstivene
kb.bezpecna(i,j) = true;                                       % aktualni pole je urcite bezpecne
kb.mozna_jama(i,j) = false;                                    % aktualni pole urcite neni mozna jama
kb.mozny_wumpus(i,j) = false;                                  % aktualni pole urcite neni mozny Wumpus

dirs = [-1 0; 1 0; 0 -1; 0 1];                                 % definice 4 sousedu

for k = 1:4                                                    % projdeme sousedni pole
    ni = i + dirs(k,1);                                        % radek souseda
    nj = j + dirs(k,2);                                        % sloupec souseda

    if ni < 1 || ni > N || nj < 1 || nj > N                    % pokud je soused mimo mrizku
        continue;                                              % preskocime ho
    end                                                        % konec kontroly hranic

    if ~percept.vanek                                          % pokud na aktualnim poli neni vanek
        kb.mozna_jama(ni,nj) = false;                          % soused nemuze byt jama
    else                                                       % jinak, kdyz vanek je
        if ~kb.navstivena(ni,nj) && ~kb.bezpecna(ni,nj)        % pokud soused neni navstiveny a neni oznacen jako bezpecny
            kb.mozna_jama(ni,nj) = true;                       % oznacime ho jako mozna jama
        end                                                    % konec podminky pro moznou jamu
    end                                                        % konec zpracovani vaneku

    if ~percept.zapach                                         % pokud na aktualnim poli neni zapach
        kb.mozny_wumpus(ni,nj) = false;                        % soused nemuze byt Wumpus
    else                                                       % jinak, kdyz zapach je
        if ~kb.navstivena(ni,nj) && ~kb.bezpecna(ni,nj)        % pokud soused neni navstiveny a neni bezpecny
            kb.mozny_wumpus(ni,nj) = true;                     % oznacime ho jako mozny Wumpus
        end                                                    % konec podminky pro mozneho Wumpuse
    end                                                        % konec zpracovani zapachu
end                                                            % konec cyklu pres sousedy

for r = 1:N                                                    % projdeme vsechna pole mrizky
    for c = 1:N                                                % projdeme vsechny sloupce
        if kb.navstivena(r,c)                                  % pokud je pole navstivene
            kb.bezpecna(r,c) = true;                           % je automaticky bezpecne
        elseif ~kb.mozna_jama(r,c) && ~kb.mozny_wumpus(r,c)    % pokud neni podezrele ani jako jama ani jako Wumpus
            kb.bezpecna(r,c) = true;                           % oznacime ho jako bezpecne
        else                                                   % jinak
            kb.bezpecna(r,c) = false;                          % neni bezpecne
        end                                                    % konec rozhodnuti o bezpecnosti
    end                                                        % konec cyklu sloupcu
end                                                            % konec cyklu radku
end                                                            % konec funkce