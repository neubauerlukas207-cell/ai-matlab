function [cesta, delka_cesty, pocet_navstivenych] = dijkstra(matice_vzdalenosti, letecke_vzdalenosti, start, cil)
% DIJKSTRA Dijkstruv algoritmus
% priorita f(n) = g(n)

    %#ok<INUSD> % letecke_vzdalenosti se zde nepouzivaji, ale rozhrani musi byt stejne

    n = size(matice_vzdalenosti, 1);

    otevrene = start;
    closed = false(1, n);

    g = inf(1, n);
    g(start) = 0;

    parent = zeros(1, n);

    pocet_navstivenych = 0;

    while ~isempty(otevrene)
        % vyber uzel s nejmensim g
        [~, idx_local] = min(g(otevrene));
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

            nova_g = g(aktualni) + matice_vzdalenosti(aktualni, s);

            if nova_g < g(s)
                g(s) = nova_g;
                parent(s) = aktualni;
            end

            if ~ismember(s, otevrene)
                otevrene(end+1) = s;
            end
        end
    end

    delka_cesty = g(cil);
    cesta = rekonstruuj_cestu(parent, start, cil);
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