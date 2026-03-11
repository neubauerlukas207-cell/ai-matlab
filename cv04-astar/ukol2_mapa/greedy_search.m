function [cesta, delka_cesty, pocet_navstivenych] = greedy_search(matice_vzdalenosti, letecke_vzdalenosti, start, cil)
% GREEDY_SEARCH Greedy Best-First Search
% priorita f(n) = h(n)

    n = size(matice_vzdalenosti, 1);

    otevrene = start;
    closed = false(1, n);

    parent = zeros(1, n);
    g = inf(1, n);
    g(start) = 0;

    pocet_navstivenych = 0;

    while ~isempty(otevrene)
        % vyber uzel s nejmensim h
        [~, idx_local] = min(letecke_vzdalenosti(otevrene));
        aktualni = otevrene(idx_local);
        otevrene(idx_local) = [];

        if closed(aktualni)
            continue;
        end

        closed(aktualni) = true;
        pocet_navstivenych = pocet_navstivenych + 1;

        if aktualni == cil
            break;
        end

        sousedi = find(matice_vzdalenosti(aktualni, :) > 0);

        for s = sousedi
            if closed(s)
                continue;
            end

            if isinf(g(s))
                g(s) = g(aktualni) + matice_vzdalenosti(aktualni, s);
                parent(s) = aktualni;
            end

            if ~ismember(s, otevrene)
                otevrene(end+1) = s;
            end
        end
    end

    cesta = rekonstruuj_cestu(parent, start, cil);

    if isempty(cesta)
        delka_cesty = inf;
    else
        delka_cesty = spocitej_delku(cesta, matice_vzdalenosti);
    end
end

function cesta = rekonstruuj_cestu(parent, start, cil)
    if start == cil
        cesta = start;
        return;
    end

    if parent(cil) == 0
        cesta = [];
        return;
    end

    cesta = cil;
    while cesta(1) ~= start
        cesta = [parent(cesta(1)), cesta];
    end
end

function delka = spocitej_delku(cesta, adj)
    delka = 0;
    for i = 1:length(cesta)-1
        delka = delka + adj(cesta(i), cesta(i+1));
    end
end