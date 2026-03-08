%% cv03_uloha1.m
% Ukol 1: Prohledavani bludiste – BFS vs DFS
% Vygeneruje 100 PRUCHOZICH bludist 20x20 s 15% prekazek,
% spusti BFS a DFS, vypise statistiky a ulozi grafy do slozky /vysledky.

clear; clc; close all;

%% Nastaveni
n = 20;
hustota = 15;
pocet_bludist = 100;

start = [1, 1];
cil   = [n, n];

vysledky_dir = fullfile(pwd, 'vysledky');
if ~exist(vysledky_dir, 'dir')
    mkdir(vysledky_dir);
end

%% 1) Vygeneruj 100 pruchozich bludist
bludiste_list = cell(pocet_bludist, 1);

fprintf('Generuji %d pruchozich bludist %dx%d s hustotou %g%% ...\n', pocet_bludist, n, n, hustota);

i = 1;
pokusy = 0;
while i <= pocet_bludist
    pokusy = pokusy + 1;
    B = generuj_bludiste(n, hustota);

    % Over pruchodnost (BFS jako nejjednodussi test)
    [cesta_b, ~, ~] = bfs(B, start, cil);

    if ~isempty(cesta_b)
        bludiste_list{i} = B;
        i = i + 1;
    end
end

fprintf('Hotovo. Celkem pokusu: %d (nepruchozich zahozena: %d)\n\n', pokusy, pokusy - pocet_bludist);

%% 2) Spust BFS a DFS na kazdem bludisti
len_bfs = zeros(pocet_bludist, 1);
len_dfs = zeros(pocet_bludist, 1);
steps_bfs = zeros(pocet_bludist, 1);
steps_dfs = zeros(pocet_bludist, 1);

paths_bfs = cell(pocet_bludist, 1);
paths_dfs = cell(pocet_bludist, 1);
visited_bfs = cell(pocet_bludist, 1);
visited_dfs = cell(pocet_bludist, 1);

for k = 1:pocet_bludist
    B = bludiste_list{k};

    [p_b, s_b, v_b] = bfs(B, start, cil);
    [p_d, s_d, v_d] = dfs(B, start, cil);

    paths_bfs{k} = p_b; visited_bfs{k} = v_b;
    paths_dfs{k} = p_d; visited_dfs{k} = v_d;

    len_bfs(k) = size(p_b, 1);
    len_dfs(k) = size(p_d, 1);
    steps_bfs(k) = s_b;
    steps_dfs(k) = s_d;
end

%% 3) Textove statistiky
fprintf('=== STATISTIKY PRO %d PRUCHOZICH BLUDIST ===\n', pocet_bludist);

fprintf('\nDelka cesty (pocet bodu v ceste):\n');
fprintf('  BFS: prumer = %.2f, min = %d, max = %d\n', mean(len_bfs), min(len_bfs), max(len_bfs));
fprintf('  DFS: prumer = %.2f, min = %d, max = %d\n', mean(len_dfs), min(len_dfs), max(len_dfs));

fprintf('\nPocet prozkoumanych uzlu (kroku algoritmu):\n');
fprintf('  BFS: prumer = %.2f, min = %d, max = %d\n', mean(steps_bfs), min(steps_bfs), max(steps_bfs));
fprintf('  DFS: prumer = %.2f, min = %d, max = %d\n', mean(steps_dfs), min(steps_dfs), max(steps_dfs));

kolik_dfs_delsi = sum(len_dfs > len_bfs);
fprintf('\nDFS naslo delsi cestu nez BFS v %d pripadech z %d.\n', kolik_dfs_delsi, pocet_bludist);

%% 4) Vizualizace
% 4.1) Sloupcovy graf pro prvnich 5 bludist
idx = 1:5;

figure('Name', 'Porovnani 5 bludist');
subplot(1,2,1);
bar([len_bfs(idx), len_dfs(idx)]);
xlabel('Bludiste #'); ylabel('Delka cesty (pocet bodu)');
legend({'BFS','DFS'}, 'Location','best');
title('Delka cesty');

subplot(1,2,2);
bar([steps_bfs(idx), steps_dfs(idx)]);
xlabel('Bludiste #'); ylabel('Pocet prozkoumanych uzlu');
legend({'BFS','DFS'}, 'Location','best');
title('Prozkoumane uzly');

saveas(gcf, fullfile(vysledky_dir, 'porovnani_5_bludist.png'));

% 4.2) Vizualizace jednoho bludiste (1. bludiste)
B = bludiste_list{1};
p_b = paths_bfs{1}; v_b = visited_bfs{1};
p_d = paths_dfs{1}; v_d = visited_dfs{1};

figure('Name', 'Bludiste BFS vs DFS', 'Position', [100 100 1100 500]);

subplot(1,2,1);
vykresli_bludiste(B, start, cil, p_b, v_b);
title('BFS');

subplot(1,2,2);
vykresli_bludiste(B, start, cil, p_d, v_d);
title('DFS');

saveas(gcf, fullfile(vysledky_dir, 'bludiste_bfs_vs_dfs.png'));

fprintf('\nUlozene obrazky:\n  %s\n  %s\n', ...
    fullfile('vysledky', 'porovnani_5_bludist.png'), ...
    fullfile('vysledky', 'bludiste_bfs_vs_dfs.png'));

%% --- LOKALNI FUNKCE ---
function vykresli_bludiste(B, start, cil, cesta, navstivene)
    % Barvy:
    % bílá = volno, černá = překážka
    % šedá = prozkoumané uzly, modrá = cesta
    % zelená = start, červená = cíl

    n = size(B,1);

    img = zeros(n,n,3);
    for r=1:n
        for c=1:n
            if B(r,c) == 1
                img(r,c,:) = 0;   % cerna
            else
                img(r,c,:) = 1;   % bila
            end
        end
    end

    % Navstivene uzly (seda) jen na volnych polich
    [vr, vc] = find(navstivene & (B==0));
    for i=1:numel(vr)
        img(vr(i), vc(i), :) = 0.7;
    end

    % Cesta (modra)
    for i=1:size(cesta,1)
        r = cesta(i,1); c = cesta(i,2);
        img(r,c,1) = 0.1; img(r,c,2) = 0.3; img(r,c,3) = 1.0;
    end

    % Start (zelena)
    img(start(1), start(2), :) = reshape([0.1 0.9 0.1],1,1,3);

    % Cil (cervena)
    img(cil(1), cil(2), :) = reshape([0.95 0.1 0.1],1,1,3);

    image(img);
    axis image off;
end