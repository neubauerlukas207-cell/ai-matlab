function akce = naplanov_akci(svet, kb, percept)               % naplanuje dalsi akci agenta
if percept.lesk                                                % pokud agent vidi lesk
    akce = 'VZIT_ZLATO';                                       % ma sebrat zlato
    return;                                                    % a koncime planovani
end                                                            % konec podminky lesku

N = size(kb.bezpecna, 1);                                      % velikost mrizky
start = svet.agent_pozice;                                     % aktualni pozice agenta

if svet.zlato_vzato                                            % pokud agent uz ma zlato
    akce = bfs_cesta(start, [1 1], kb.bezpecna, N);            % najdeme cestu zpet na start
    if isempty(akce)                                           % pokud zadna cesta neni
        akce = 'KONEC';                                        % vratime konec
    end                                                        % konec kontroly prazdne cesty
    return;                                                    % koncime funkci
end                                                            % konec vetve pro navrat se zlatem

queue = start;                                                 % fronta pro BFS zacina aktualni pozici
visited = false(N);                                            % matice navstivenych poli v BFS
visited(start(1), start(2)) = true;                            % start oznacime jako navstiveny
parent = cell(N);                                              % sem budeme ukladat predchudce pro rekonstrukci cesty

cil = [];                                                      % zatim nemame zadny cil

while ~isempty(queue)                                          % dokud neni BFS fronta prazdna
    cur = queue(1,:);                                          % vezmeme prvni pole z fronty
    queue(1,:) = [];                                           % odebereme ho z fronty

    if kb.bezpecna(cur(1), cur(2)) && ~kb.navstivena(cur(1), cur(2)) % pokud je to bezpecne a zaroven jeste nenavstivene pole
        cil = cur;                                             % nasli jsme cil
        break;                                                 % ukoncime BFS
    end                                                        % konec kontroly ciloveho pole

    sous = sousede4(cur, N);                                   % zjistime 4 sousedy aktualniho pole
    for k = 1:size(sous,1)                                     % projdeme sousedy
        n = sous(k,:);                                         % konkretni soused
        if ~visited(n(1), n(2)) && kb.bezpecna(n(1), n(2))     % pokud soused jeste nebyl navstiven a je bezpecny
            visited(n(1), n(2)) = true;                        % oznacime ho jako navstiveny
            parent{n(1), n(2)} = cur;                          % ulozime predchudce pro rekonstrukci cesty
            queue(end+1,:) = n;                                % pridame souseda do fronty
        end                                                    % konec podminky pro pridani souseda
    end                                                        % konec cyklu sousedu
end                                                            % konec BFS smycky

if isempty(cil)                                                % pokud jsme nenasli zadny bezpecny nenavstiveny cil
    akce = 'KONEC';                                            % agent se zasekl
else                                                           % jinak
    akce = rekonstruuj_cestu(start, cil, parent);              % zrekonstruujeme cestu od startu do cile
end                                                            % konec rozhodnuti
end                                                            % konec hlavni funkce

function sous = sousede4(p, N)                                 % pomocna funkce vrati 4 sousedy pole
i = p(1);                                                      % radek pole
j = p(2);                                                      % sloupec pole

cand = [i-1 j;                                                 % kandidat nahoru
        i+1 j;                                                 % kandidat dolu
        i j-1;                                                 % kandidat doleva
        i j+1];                                                % kandidat doprava

sous = [];                                                     % prazdne pole pro platne sousedy
for t = 1:4                                                    % projdeme vsechny 4 kandidaty
    if cand(t,1) >= 1 && cand(t,1) <= N && cand(t,2) >= 1 && cand(t,2) <= N % pokud lezi uvnitr mrizky
        sous(end+1,:) = cand(t,:);                             % pridame ho mezi platne sousedy
    end                                                        % konec kontroly hranic
end                                                            % konec cyklu pres kandidaty
end                                                            % konec pomocne funkce

function kroky = bfs_cesta(start, cil, safe, N)                % pomocna BFS funkce najde cestu mezi dvema poli
queue = start;                                                 % fronta zacina startem
visited = false(N);                                            % matice navstivenych poli
visited(start(1), start(2)) = true;                            % start oznacime jako navstiveny
parent = cell(N);                                              % predchudci pro rekonstrukci
nalezeno = false;                                              % zatim jsme cil nenasli

while ~isempty(queue)                                          % dokud je co prohledavat
    cur = queue(1,:);                                          % vezmeme prvni pole z fronty
    queue(1,:) = [];                                           % odebereme ho

    if isequal(cur, cil)                                       % pokud jsme na cili
        nalezeno = true;                                       % oznacime nalezeni
        break;                                                 % ukoncime BFS
    end                                                        % konec kontroly cile

    sous = sousede4(cur, N);                                   % sousedi aktualniho pole
    for k = 1:size(sous,1)                                     % projdeme sousedy
        n = sous(k,:);                                         % konkretni soused
        if ~visited(n(1), n(2)) && safe(n(1), n(2))            % pokud neni navstiven a je bezpecny
            visited(n(1), n(2)) = true;                        % oznacime ho jako navstiveny
            parent{n(1), n(2)} = cur;                          % ulozime predchudce
            queue(end+1,:) = n;                                % a dame ho do fronty
        end                                                    % konec podminky pro pridani
    end                                                        % konec cyklu sousedu
end                                                            % konec BFS

if ~nalezeno                                                   % pokud jsme cil nenasli
    kroky = [];                                                % vratime prazdnou cestu
else                                                           % jinak
    kroky = rekonstruuj_cestu(start, cil, parent);             % slozime cestu
end                                                            % konec rozhodnuti
end                                                            % konec funkce bfs_cesta

function kroky = rekonstruuj_cestu(start, cil, parent)         % pomocna funkce slozi seznam kroku z BFS predchudcu
path = cil;                                                    % zacneme od cile

while ~isequal(path(1,:), start)                               % dokud prvni prvek cesty neni start
    pred = parent{path(1,1), path(1,2)};                       % najdeme predchudce prvniho prvku
    path = [pred; path];                                       % pridame predchudce na zacatek cesty
end                                                            % konec skladani cesty

kroky = {};                                                    % sem ulozime slovni kroky
for i = 1:size(path,1)-1                                       % projdeme dvojice po sobe jdoucich poli
    a = path(i,:);                                             % aktualni pole
    b = path(i+1,:);                                           % dalsi pole

    if b(1) == a(1)-1                                          % pokud se radek snizil o 1
        kroky{end+1} = 'NAHORU';                               % krok je nahoru
    elseif b(1) == a(1)+1                                      % pokud se radek zvysil o 1
        kroky{end+1} = 'DOLU';                                 % krok je dolu
    elseif b(2) == a(2)-1                                      % pokud se sloupec snizil o 1
        kroky{end+1} = 'DOLEVA';                               % krok je doleva
    elseif b(2) == a(2)+1                                      % pokud se sloupec zvysil o 1
        kroky{end+1} = 'DOPRAVA';                              % krok je doprava
    end                                                        % konec rozliseni smeru
end                                                            % konec cyklu pres cestu
end                                                            % konec funkce rekonstruuj_cestu