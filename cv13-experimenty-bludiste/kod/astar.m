function [cesta, pocet_kroku, navstivene] = astar(bludiste, start, cil, heuristika)
%ASTAR Informovane prohledavani A* na mrizce.
%   Pouziva prioritni frontu dle f = g + h, kde g je skutecna vzdalenost
%   od startu a h je heuristicky odhad vzdalenosti do cile.
%
%   Vstup:
%     bludiste   - n x n (0 = volno, 1 = prekazka)
%     start      - [r, c] pocatecni pozice
%     cil        - [r, c] cilova pozice
%     heuristika - retezec: 'manhattan' | 'euclidean' | 'chebyshev' | 'nulova'
%                  (volitelne, vychozi je 'manhattan')
%
%   Vystup:
%     cesta       - Kx2 souradnice (vcetne start a cil), [] pokud nenalezena
%     pocet_kroku - pocet expandovanych uzlu
%     navstivene  - logicka matice n x n

% Vychozi heuristika je Manhattan -- nejcastejsi volba pro mrizky
if nargin < 4
    heuristika = 'manhattan';
end

n = size(bludiste, 1);
navstivene  = false(n, n);
pocet_kroku = 0;

% Kontrola ze start a cil nejsou prekazka
if bludiste(start(1), start(2)) == 1 || bludiste(cil(1), cil(2)) == 1
    cesta = [];
    return;
end

% g(r,c) = skutecna cena cesty ze startu do (r,c)
% Inicializujeme na Inf -- pole jesste nebyla navstivena
g = inf(n, n);
g(start(1), start(2)) = 0;

% Predchudci pro rekonstrukci cesty
prev_r = zeros(n, n);
prev_c = zeros(n, n);
prev_r(start(1), start(2)) = -1;
prev_c(start(1), start(2)) = -1;

% Prioritni fronta jako matice [f, r, c]
% f = g + h je celkove ohodnoceni uzlu
h_start = vypocti_heuristiku(start, cil, heuristika);
fronta = [h_start, start(1), start(2)];

moves = [-1 0; 1 0; 0 -1; 0 1]; % 4-sousedstvi (nahoru, dolu, vlevo, vpravo)
found = false;

while ~isempty(fronta)
    % Vyber uzel s nejnizsim f (prvni radek -- fronta je serazena)
    u = fronta(1, 2:3);
    fronta(1, :) = [];

    r0 = u(1);
    c0 = u(2);

    % Preskocit uz uzavrene uzly (mohly byt pridany vicekrat)
    if navstivene(r0, c0)
        continue;
    end

    navstivene(r0, c0) = true;
    pocet_kroku = pocet_kroku + 1;

    % Zkontrolovat jestli jsme dosli do cile
    if r0 == cil(1) && c0 == cil(2)
        found = true;
        break;
    end

    % Prozkoumej vsechny 4 sousedy
    for k = 1:4
        nr = r0 + moves(k, 1);
        nc = c0 + moves(k, 2);

        % Zkontrolovat hranice mrizky a zda neni prekazka
        if nr >= 1 && nr <= n && nc >= 1 && nc <= n
            if ~navstivene(nr, nc) && bludiste(nr, nc) == 0

                % Cena prechodu je vzdy 1 (pohyb o jedno pole)
                g_novy = g(r0, c0) + 1;

                % Aktualizovat pouze pokud jsme nasli lepsi cestu
                if g_novy < g(nr, nc)
                    g(nr, nc) = g_novy;
                    prev_r(nr, nc) = r0;
                    prev_c(nr, nc) = c0;

                    h = vypocti_heuristiku([nr, nc], cil, heuristika);
                    f = g_novy + h;

                    % Pridat do fronty a seradit podle f (nejmensi prvni)
                    fronta(end+1, :) = [f, nr, nc]; %#ok<AGROW>
                    fronta = sortrows(fronta, 1);
                end
            end
        end
    end
end

% Rekonstrukce cesty zpetne pres predchudce
cesta = [];
if found
    cesta_rev = zeros(n*n, 2);
    idx = 1;
    cur = cil;
    while true
        cesta_rev(idx, :) = cur;
        idx = idx + 1;

        pr = prev_r(cur(1), cur(2));
        pc = prev_c(cur(1), cur(2));

        if pr == -1 && pc == -1
            break;
        end
        cur = [pr, pc];
    end

    cesta_rev = cesta_rev(1:idx-1, :);
    cesta = flipud(cesta_rev);
end

end % konec funkce astar

% -------------------------------------------------------------------------
% Pomocna funkce pro vypocet heuristiky
% -------------------------------------------------------------------------
function h = vypocti_heuristiku(pos, cil, typ)
%VYPOCTI_HEURISTIKU Vypocte heuristicky odhad vzdalenosti pos -> cil.
%   Podporovane typy: manhattan, euclidean, chebyshev, nulova

dr = abs(pos(1) - cil(1)); % rozdil v radcich
dc = abs(pos(2) - cil(2)); % rozdil ve sloupcich

switch lower(typ)
    case 'manhattan'
        % Soucet absolutnich rozdilu -- pripustna heuristika pro 4-sousedstvi
        h = dr + dc;
    case 'euclidean'
        % Primocara vzdalenost -- pripustna, ale muze podcenit pro mrizku
        h = sqrt(dr^2 + dc^2);
    case 'chebyshev'
        % Maximum z rozdilu -- vhodne pro 8-sousedstvi, zde podceni vzdalenost
        h = max(dr, dc);
    case 'nulova'
        % Nulova heuristika -- A* se chova jako Dijkstra (prochazi vsechny uzly)
        h = 0;
    otherwise
        % Neznamy typ -- pouzij Manhattan jako bezpecnou volbu
        warning('Neznama heuristika "%s", pouzivam Manhattan.', typ);
        h = dr + dc;
end

end % konec funkce vypocti_heuristiku
