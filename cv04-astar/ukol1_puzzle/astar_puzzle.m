function [reseni, pocet_expandovanych, cas] = astar_puzzle(pocatecni_stav, cilovy_stav, typ_heuristiky)
% ASTAR_PUZZLE Resi 8-puzzle algoritmem A*
% rychlejsi verze

    tic;

    start_key = stav2klic_num(pocatecni_stav);
    goal_key  = stav2klic_num(cilovy_stav);

    % open list
    open_states = zeros(100000, 9);
    open_g = inf(100000, 1);
    open_h = inf(100000, 1);
    open_f = inf(100000, 1);
    open_keys = zeros(100000, 1);

    h0 = heuristika_puzzle(pocatecni_stav, cilovy_stav, typ_heuristiky);

    open_count = 1;
    open_states(1, :) = pocatecni_stav;
    open_g(1) = 0;
    open_h(1) = h0;
    open_f(1) = h0;
    open_keys(1) = start_key;

    closed = containers.Map('KeyType', 'double', 'ValueType', 'logical');
    gScore = containers.Map('KeyType', 'double', 'ValueType', 'double');
    parentMap = containers.Map('KeyType', 'double', 'ValueType', 'double');
    stateMap = containers.Map('KeyType', 'double', 'ValueType', 'any');

    gScore(start_key) = 0;
    parentMap(start_key) = -1;
    stateMap(start_key) = pocatecni_stav;

    pocet_expandovanych = 0;
    reseni = {};

    while open_count > 0
        [~, idx_min] = min(open_f(1:open_count));

        current_stav = open_states(idx_min, :);
        current_g = open_g(idx_min);
        current_key = open_keys(idx_min);

        % odstraneni z open prohozenim s poslednim
        open_states(idx_min, :) = open_states(open_count, :);
        open_g(idx_min) = open_g(open_count);
        open_h(idx_min) = open_h(open_count);
        open_f(idx_min) = open_f(open_count);
        open_keys(idx_min) = open_keys(open_count);
        open_count = open_count - 1;

        if isKey(closed, current_key)
            continue;
        end

        if current_key == goal_key
            reseni = rekonstruuj_cestu(parentMap, stateMap, current_key);
            cas = toc;
            return;
        end

        closed(current_key) = true;
        pocet_expandovanych = pocet_expandovanych + 1;

        sousede = generuj_sousedy(current_stav);

        for i = 1:size(sousede, 1)
            soused_stav = sousede(i, :);
            soused_key = stav2klic_num(soused_stav);

            if isKey(closed, soused_key)
                continue;
            end

            nove_g = current_g + 1;

            if ~isKey(gScore, soused_key) || nove_g < gScore(soused_key)
                gScore(soused_key) = nove_g;
                parentMap(soused_key) = current_key;
                stateMap(soused_key) = soused_stav;

                h = heuristika_puzzle(soused_stav, cilovy_stav, typ_heuristiky);
                f = nove_g + h;

                open_count = open_count + 1;
                open_states(open_count, :) = soused_stav;
                open_g(open_count) = nove_g;
                open_h(open_count) = h;
                open_f(open_count) = f;
                open_keys(open_count) = soused_key;
            end
        end
    end

    cas = toc;
end

function cesta = rekonstruuj_cestu(parentMap, stateMap, goal_key)
    cesta = {};
    current = goal_key;

    while current ~= -1
        cesta = [{stateMap(current)}, cesta];
        current = parentMap(current);
    end
end

function sousede = generuj_sousedy(stav)
    idx0 = find(stav == 0);
    [r, c] = ind2sub([3,3], idx0);

    tahy = [-1 0; 1 0; 0 -1; 0 1];
    sousede = zeros(4, 9);
    count = 0;

    for i = 1:4
        nr = r + tahy(i, 1);
        nc = c + tahy(i, 2);

        if nr >= 1 && nr <= 3 && nc >= 1 && nc <= 3
            novy = stav;
            idx2 = sub2ind([3,3], nr, nc);
            novy(idx0) = novy(idx2);
            novy(idx2) = 0;
            count = count + 1;
            sousede(count, :) = novy;
        end
    end

    sousede = sousede(1:count, :);
end

function key = stav2klic_num(stav)
% unikatni cislo pro stav
    key = 0;
    for i = 1:9
        key = key * 10 + stav(i);
    end
end