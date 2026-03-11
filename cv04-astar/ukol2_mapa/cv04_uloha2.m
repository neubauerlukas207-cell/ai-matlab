clear;
clc;
close all;

if ~exist('vysledky', 'dir')
    mkdir('vysledky');
end

[mesta, matice_vzdalenosti, letecke_vzdalenosti, start, cil, pozice] = mapa_mest();

[cesta_dijkstra, delka_dijkstra, navstiveno_dijkstra] = dijkstra(matice_vzdalenosti, letecke_vzdalenosti, start, cil);
[cesta_greedy,   delka_greedy,   navstiveno_greedy]   = greedy_search(matice_vzdalenosti, letecke_vzdalenosti, start, cil);
[cesta_astar,    delka_astar,    navstiveno_astar]    = astar_mapa(matice_vzdalenosti, letecke_vzdalenosti, start, cil);

fprintf('===============================================\n');
fprintf('CV04 - Ukol 2 - Dijkstra vs Greedy vs A*\n');
fprintf('===============================================\n\n');

fprintf('%-12s | %-40s | %-5s | %-10s\n', 'Algoritmus', 'Cesta', 'Delka', 'Navstiveno');
fprintf('%s\n', repmat('-', 1, 78));
fprintf('%-12s | %-40s | %-5d | %-10d\n', 'Dijkstra', cesta_na_text(cesta_dijkstra, mesta), delka_dijkstra, navstiveno_dijkstra);
fprintf('%-12s | %-40s | %-5d | %-10d\n', 'Greedy',   cesta_na_text(cesta_greedy,   mesta), delka_greedy,   navstiveno_greedy);
fprintf('%-12s | %-40s | %-5d | %-10d\n', 'A*',       cesta_na_text(cesta_astar,    mesta), delka_astar,    navstiveno_astar);

fprintf('\nOTAZKY DO README:\n');
fprintf('1) Nejkratsi cestu nasel: %s\n', urci_nejkratsi(delka_dijkstra, delka_greedy, delka_astar));
fprintf('2) Nejmene uzlu navstivil: %s\n', urci_nejmene(navstiveno_dijkstra, navstiveno_greedy, navstiveno_astar));
fprintf('3) Nasel Greedy optimalni cestu? %s\n', odpoved_greedy(delka_greedy, delka_astar));

vykresli_mapu_prehledne(mesta, matice_vzdalenosti, letecke_vzdalenosti, pozice, ...
    start, cil, cesta_dijkstra, cesta_greedy, cesta_astar);

fprintf('\nObrazek ulozen do: vysledky/mapa_porovnani.png\n');
fprintf('Hotovo.\n');

function text = cesta_na_text(cesta, mesta)
    if isempty(cesta)
        text = 'nenalezena';
        return;
    end

    casti = mesta(cesta);
    text = casti{1};
    for i = 2:length(casti)
        text = [text ' -> ' casti{i}]; %#ok<AGROW>
    end
end

function vysl = urci_nejkratsi(d1, d2, d3)
    minimum = min([d1, d2, d3]);
    jmena = {};

    if d1 == minimum, jmena{end+1} = 'Dijkstra'; end
    if d2 == minimum, jmena{end+1} = 'Greedy'; end
    if d3 == minimum, jmena{end+1} = 'A*'; end

    vysl = strjoin(jmena, ', ');
end

function vysl = urci_nejmene(n1, n2, n3)
    minimum = min([n1, n2, n3]);
    jmena = {};

    if n1 == minimum, jmena{end+1} = 'Dijkstra'; end
    if n2 == minimum, jmena{end+1} = 'Greedy'; end
    if n3 == minimum, jmena{end+1} = 'A*'; end

    vysl = strjoin(jmena, ', ');
end

function text = odpoved_greedy(delka_greedy, delka_astar)
    if delka_greedy == delka_astar
        text = 'ANO';
    else
        text = 'NE';
    end
end

function vykresli_mapu_prehledne(mesta, adj, h, pozice, start, cil, cesta_dijkstra, cesta_greedy, cesta_astar)
    fig = figure('Name', 'Mapa mest - porovnani algoritmu', 'Position', [100 100 1400 850]);
    hold on;
    axis off;

    title({'Mapa mest - porovnani algoritmu', ...
           'Start: Alpov, Cil: Hradec'}, ...
           'FontSize', 22, 'FontWeight', 'bold');

    n = size(adj, 1);

    % 1) zakladni sit silnic
    for i = 1:n
        for j = i+1:n
            if adj(i,j) > 0
                plot([pozice(i,1), pozice(j,1)], [pozice(i,2), pozice(j,2)], ...
                    '-', 'Color', [0.75 0.75 0.75], 'LineWidth', 2);

                mx = (pozice(i,1) + pozice(j,1)) / 2;
                my = (pozice(i,2) + pozice(j,2)) / 2;

                % automaticky posun popisku podle smeru hrany
                dx = pozice(j,1) - pozice(i,1);
                dy = pozice(j,2) - pozice(i,2);
                delka = sqrt(dx^2 + dy^2);

                if delka == 0
                    ox = 0;
                    oy = 0.25;
                else
                    nx = -dy / delka;
                    ny =  dx / delka;

                    % zakladni posun od hrany
                    ox = 0.28 * nx;
                    oy = 0.28 * ny;

                    % jemne doladeni pro diagonalni hrany vlevo/vpravo
                    if dx > 0 && dy < 0
                        ox = ox - 0.18;
                        oy = oy - 0.10;
                    elseif dx > 0 && dy > 0
                        ox = ox - 0.12;
                        oy = oy + 0.05;
                    end
                end

                text(mx + ox, my + oy, sprintf('%d km', adj(i,j)), ...
                    'HorizontalAlignment', 'center', ...
                    'FontSize', 12, 'FontWeight', 'bold', ...
                    'BackgroundColor', [0.97 0.95 0.80], ...
                    'Margin', 3, 'EdgeColor', [0.75 0.75 0.50]);
            end
        end
    end

    % 2) cesty algoritmu
    % Dijkstra = modra
    % Greedy   = cervena prerusovana
    % A*       = zelena

    h_dij = vykresli_cestu_posun(cesta_dijkstra, pozice, [0.00 0.45 0.74], '-', 5, -0.10);
    h_gre = vykresli_cestu_posun(cesta_greedy,   pozice, [0.85 0.20 0.20], '--', 5,  0.12);
    h_ast = vykresli_cestu_posun(cesta_astar,    pozice, [0.20 0.65 0.20], '-',  5,  0.00);

    % 3) uzly
    for i = 1:n
        if i == start
            faceColor = [0.45 0.80 0.40];
            edgeColor = [0.10 0.55 0.10];
        elseif i == cil
            faceColor = [1.00 0.50 0.50];
            edgeColor = [0.85 0.00 0.00];
        else
            faceColor = [0.65 0.82 0.88];
            edgeColor = [0.25 0.50 0.75];
        end

        scatter(pozice(i,1), pozice(i,2), 1600, ...
            'MarkerFaceColor', faceColor, ...
            'MarkerEdgeColor', edgeColor, ...
            'LineWidth', 3);

        if i == start || i == cil
            text(pozice(i,1), pozice(i,2) - 0.70, sprintf('%s\nh = %d', mesta{i}, h(i)), ...
                'HorizontalAlignment', 'center', ...
                'FontSize', 15, 'FontWeight', 'bold', ...
                'BackgroundColor', 'white', ...
                'Margin', 4, 'EdgeColor', edgeColor);
        else
            text(pozice(i,1), pozice(i,2) + 0.95, sprintf('%s\nh = %d', mesta{i}, h(i)), ...
                'HorizontalAlignment', 'center', ...
                'FontSize', 15, 'FontWeight', 'bold', ...
                'BackgroundColor', 'white', ...
                'Margin', 4, 'EdgeColor', edgeColor);
        end
    end

    % 4) legenda
    h_silnice = plot(nan, nan, '-', 'Color', [0.75 0.75 0.75], 'LineWidth', 2);
    legend([h_silnice, h_dij, h_gre, h_ast], ...
        {'Silnice', 'Dijkstra', 'Greedy', 'A*'}, ...
        'Location', 'southoutside', ...
        'Orientation', 'horizontal', ...
        'FontSize', 13);

    % 5) text s vysledkem
    text(5, -3.0, ...
        sprintf(['Vysledek:\n' ...
                 'Dijkstra a A* nasly dolni optimalni cestu (350 km).\n' ...
                 'Greedy zvolil horni cestu podle heuristiky a vysla delsi (440 km).']), ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 13, ...
        'FontWeight', 'bold', ...
        'BackgroundColor', [1 1 1], ...
        'EdgeColor', [0.6 0.6 0.6], ...
        'Margin', 6);

    xlim([-1 11]);
    ylim([-3.6 3.6]);

    saveas(fig, fullfile('vysledky', 'mapa_porovnani.png'));
end

function h_line = vykresli_cestu_posun(cesta, pozice, barva, styl, sirka, offset)
    h_line = plot(nan, nan, 'LineStyle', styl, 'Color', barva, 'LineWidth', sirka);

    if isempty(cesta) || length(cesta) < 2
        return;
    end

    for i = 1:length(cesta)-1
        a = cesta(i);
        b = cesta(i+1);

        x1 = pozice(a,1);
        y1 = pozice(a,2);
        x2 = pozice(b,1);
        y2 = pozice(b,2);

        dx = x2 - x1;
        dy = y2 - y1;
        delka = sqrt(dx^2 + dy^2);

        if delka == 0
            continue;
        end

        nx = -dy / delka;
        ny =  dx / delka;

        x1o = x1 + offset * nx;
        y1o = y1 + offset * ny;
        x2o = x2 + offset * nx;
        y2o = y2 + offset * ny;

        plot([x1o, x2o], [y1o, y2o], ...
            'LineStyle', styl, ...
            'Color', barva, ...
            'LineWidth', sirka);
    end
end