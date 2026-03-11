function h = heuristika_puzzle(stav, cilovy_stav, typ_heuristiky)
% HEURISTIKA_PUZZLE Vrati hodnotu zvolene heuristiky
% typ_heuristiky:
%   'manhattan'
%   'hamming'
%   'linearni_konflikt'

    switch lower(typ_heuristiky)
        case 'manhattan'
            h = manhattan_distance(stav, cilovy_stav);

        case 'hamming'
            h = hamming_distance(stav, cilovy_stav);

        case 'linearni_konflikt'
            h = linearni_konflikt(stav, cilovy_stav);

        otherwise
            error('Neznamy typ heuristiky: %s', typ_heuristiky);
    end
end

function h = manhattan_distance(stav, cilovy_stav)
    h = 0;

    for cislo = 1:8
        idx_stav = find(stav == cislo);
        idx_cil = find(cilovy_stav == cislo);

        [r1, c1] = ind2sub([3,3], idx_stav);
        [r2, c2] = ind2sub([3,3], idx_cil);

        h = h + abs(r1 - r2) + abs(c1 - c2);
    end
end

function h = hamming_distance(stav, cilovy_stav)
    mask = (stav ~= 0);
    h = sum(stav(mask) ~= cilovy_stav(mask));
end

function h = linearni_konflikt(stav, cilovy_stav)
% Manhattan + 2 za kazdy linearni konflikt

    h = manhattan_distance(stav, cilovy_stav);
    konflikty = 0;

    M = reshape(stav, 3, 3)';
    G = reshape(cilovy_stav, 3, 3)';

    % konflikty v radcich
    for r = 1:3
        row_vals = M(r, :);

        for i = 1:2
            for j = i+1:3
                a = row_vals(i);
                b = row_vals(j);

                if a == 0 || b == 0
                    continue;
                end

                goal_idx_a = find(cilovy_stav == a);
                goal_idx_b = find(cilovy_stav == b);

                [ga_r, ga_c] = ind2sub([3,3], goal_idx_a);
                [gb_r, gb_c] = ind2sub([3,3], goal_idx_b);

                if ga_r == r && gb_r == r && ga_c > gb_c
                    konflikty = konflikty + 1;
                end
            end
        end
    end

    % konflikty ve sloupcich
    for c = 1:3
        col_vals = M(:, c);

        for i = 1:2
            for j = i+1:3
                a = col_vals(i);
                b = col_vals(j);

                if a == 0 || b == 0
                    continue;
                end

                goal_idx_a = find(cilovy_stav == a);
                goal_idx_b = find(cilovy_stav == b);

                [ga_r, ga_c] = ind2sub([3,3], goal_idx_a);
                [gb_r, gb_c] = ind2sub([3,3], goal_idx_b);

                if ga_c == c && gb_c == c && ga_r > gb_r
                    konflikty = konflikty + 1;
                end
            end
        end
    end

    h = h + 2 * konflikty;
end