function akce = naplanov_akci(svet, kb, percept)
% naplanov_akci - naplanuje dalsi akci agenta
% Vstup:  svet    - aktualni stav sveta
%         kb      - baze znalosti
%         percept - aktualni percepce
% Vystup: akce    - string: 'DOPREDU'|'VLEVO'|'VPRAVO'|'VZIT_ZLATO'|'KONEC'
%         (interně vraci cell array kroku pro provedeni cesty)

% 1. Pokud lesk -> sebrat zlato
if percept.lesk
    akce = 'VZIT_ZLATO';
    return;
end

N     = size(kb.bezpecna, 1);
start = svet.agent_pozice;

% 2. Pokud uz ma zlato -> jdi zpet na [1,1]
if svet.zlato_vzato
    akce = bfs_cesta(start, [1 1], kb.bezpecna | kb.navstivena, N);
    if isempty(akce)
        akce = 'KONEC';
    end
    return;
end

% 3. Najdi nejblizsi bezpecne NENAVSTIVENE pole pomoci BFS
% prochazime jen pres bezpecna pole
queue   = start;
visited = false(N);
visited(start(1), start(2)) = true;
parent  = cell(N);
cil     = [];

while ~isempty(queue)
    cur      = queue(1, :);
    queue(1, :) = [];

    % je cil: bezpecne a nenavstivene
    if kb.bezpecna(cur(1), cur(2)) && ~kb.navstivena(cur(1), cur(2))
        cil = cur;
        break;
    end

    sous = sousede4(cur, N);
    for k = 1:size(sous, 1)
        n = sous(k, :);
        if ~visited(n(1), n(2)) && kb.bezpecna(n(1), n(2))
            visited(n(1), n(2))    = true;
            parent{n(1), n(2)}     = cur;
            queue(end+1, :)        = n; %#ok<AGROW>
        end
    end
end

if isempty(cil)
    % Zadne bezpecne nenavstivene pole - pokus se jit na nejblizsi nenavstivene
    % (rizikovy tah - agent musi riskovat)
    cil2 = najdi_nenavstivene_bezpecnou_cestou(start, kb, N);
    if isempty(cil2)
        akce = 'KONEC';
    else
        akce = bfs_cesta(start, cil2, true(N), N); % pres libovolne pole
        if isempty(akce)
            akce = 'KONEC';
        end
    end
else
    akce = rekonstruuj_cestu(start, cil, parent);
    if isempty(akce)
        akce = 'KONEC';
    end
end
end

% ===== pomocne funkce =====

function sous = sousede4(p, N)
% vrati 4 sousedy pole p v mezich NxN
i    = p(1);
j    = p(2);
cand = [i-1 j; i+1 j; i j-1; i j+1];
sous = [];
for t = 1:4
    if cand(t,1) >= 1 && cand(t,1) <= N && cand(t,2) >= 1 && cand(t,2) <= N
        sous(end+1, :) = cand(t, :); %#ok<AGROW>
    end
end
end

function kroky = bfs_cesta(start, cil, pruchozi, N)
% BFS - najde cestu ze start do cil pres pole kde pruchozi==true
queue   = start;
visited = false(N);
visited(start(1), start(2)) = true;
parent  = cell(N);
nalezeno = false;

while ~isempty(queue)
    cur = queue(1, :);
    queue(1, :) = [];

    if isequal(cur, cil)
        nalezeno = true;
        break;
    end

    sous = sousede4(cur, N);
    for k = 1:size(sous, 1)
        n = sous(k, :);
        if ~visited(n(1), n(2)) && pruchozi(n(1), n(2))
            visited(n(1), n(2)) = true;
            parent{n(1), n(2)} = cur;
            queue(end+1, :)    = n; %#ok<AGROW>
        end
    end
end

if ~nalezeno
    kroky = [];
else
    kroky = rekonstruuj_cestu(start, cil, parent);
end
end

function kroky = rekonstruuj_cestu(start, cil, parent)
% slozi seznam kroku z BFS predchudcu
path = cil;
while ~isequal(path(1, :), start)
    pred = parent{path(1,1), path(1,2)};
    if isempty(pred)
        kroky = {};
        return;
    end
    path = [pred; path]; %#ok<AGROW>
end

kroky = {};
for idx = 1:size(path, 1)-1
    a = path(idx, :);
    b = path(idx+1, :);
    if     b(1) == a(1)-1,  kroky{end+1} = 'NAHORU';  %#ok<AGROW>
    elseif b(1) == a(1)+1,  kroky{end+1} = 'DOLU';    %#ok<AGROW>
    elseif b(2) == a(2)-1,  kroky{end+1} = 'DOLEVA';  %#ok<AGROW>
    elseif b(2) == a(2)+1,  kroky{end+1} = 'DOPRAVA'; %#ok<AGROW>
    end
end
end

function cil = najdi_nenavstivene_bezpecnou_cestou(start, kb, N)
% najde nejblizsi nenavstivene pole dostupne z aktualniho startu
queue   = start;
visited = false(N);
visited(start(1), start(2)) = true;
cil = [];

while ~isempty(queue)
    cur = queue(1, :);
    queue(1, :) = [];

    if ~kb.navstivena(cur(1), cur(2))
        cil = cur;
        return;
    end

    sous = sousede4(cur, N);
    for k = 1:size(sous, 1)
        n = sous(k, :);
        if ~visited(n(1), n(2))
            visited(n(1), n(2)) = true;
            queue(end+1, :)     = n; %#ok<AGROW>
        end
    end
end
end