function kb = aktualizuj_kb(kb, pozice, percept)
% aktualizuj_kb - aktualizuje knowledge base podle aktualni percepce
% Vstup:  kb      - aktualni baze znalosti (struct)
%         pozice  - aktualni pozice agenta [i, j]
%         percept - vystup z vnimej()
% Vystup: kb      - aktualizovana baze znalosti

i = pozice(1);                       % radek aktualni pozice
j = pozice(2);                       % sloupec aktualni pozice
N = size(kb.navstivena, 1);          % velikost mrizky

% aktualni pole je navstivene a bezpecne
kb.navstivena(i, j)   = true;
kb.bezpecna(i, j)     = true;
kb.mozna_jama(i, j)   = false;
kb.mozny_wumpus(i, j) = false;

dirs = [-1 0; 1 0; 0 -1; 0 1];      % 4 sousede

for k = 1:4
    ni = i + dirs(k, 1);
    nj = j + dirs(k, 2);

    if ni < 1 || ni > N || nj < 1 || nj > N
        continue;                    % mimo mrizku - preskoc
    end

    % zpracovani vaneku (jamy)
    if ~percept.vanek
        % zadny vanek -> soused URCITE neni jama
        kb.mozna_jama(ni, nj) = false;
    else
        % vanek -> soused MOZNA je jama (jen pokud neni overene bezpecny)
        if ~kb.navstivena(ni, nj) && ~kb.bezpecna(ni, nj)
            kb.mozna_jama(ni, nj) = true;
        end
    end

    % zpracovani zapachu (Wumpus)
    if ~percept.zapach
        % zadny zapach -> soused URCITE neni Wumpus
        kb.mozny_wumpus(ni, nj) = false;
    else
        % zapach -> soused MOZNA je Wumpus
        if ~kb.navstivena(ni, nj) && ~kb.bezpecna(ni, nj)
            kb.mozny_wumpus(ni, nj) = true;
        end
    end
end

% aktualizuj matici bezpecnych poli na zaklade KB
for r = 1:N
    for c = 1:N
        if kb.navstivena(r, c)
            % navstivene pole je vzdy bezpecne
            kb.bezpecna(r, c) = true;
        elseif ~kb.mozna_jama(r, c) && ~kb.mozny_wumpus(r, c)
            % neni podezrele -> bezpecne
            kb.bezpecna(r, c) = true;
        else
            % podezrele pole -> neni bezpecne
            kb.bezpecna(r, c) = false;
        end
    end
end
end