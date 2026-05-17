%EXPERIMENT_01_HUSTOTA Vliv hustoty prekazek na vykon BFS, DFS a A*.
%
%   Hypoteza: Se zvysujici se hustotou prekazek roste pocet expandovanych
%   uzlu u vsech algoritmu. DFS bude mit delsi cestu nez BFS a A*, ktere
%   najdou optimalni reseni. Pri vysoke hustote (40 %) bude vice bludist
%   nepruchozich.
%
%   Provedeni: 4 hodnoty hustoty x 30 behu, seed resetovan pred kazdym behem.

clear; clc;

HUSTOTY   = [10, 20, 30, 40]; % procenta prekazek
N         = 20;               % velikost mrizky (stejna jako baseline)
POCET_BEH = 30;               % pocet opakovani pro statistiku
start     = [1, 1];
cil       = [N, N];

% Matice vysledku: radky = hustoty, sloupce = behy
del_bfs  = zeros(length(HUSTOTY), POCET_BEH);
del_dfs  = zeros(length(HUSTOTY), POCET_BEH);
del_ast  = zeros(length(HUSTOTY), POCET_BEH);
kro_bfs  = zeros(length(HUSTOTY), POCET_BEH);
kro_dfs  = zeros(length(HUSTOTY), POCET_BEH);
kro_ast  = zeros(length(HUSTOTY), POCET_BEH);
cas_bfs  = zeros(length(HUSTOTY), POCET_BEH);
cas_dfs  = zeros(length(HUSTOTY), POCET_BEH);
cas_ast  = zeros(length(HUSTOTY), POCET_BEH);
pruchozi = zeros(length(HUSTOTY), 1);

fprintf('=== EXPERIMENT 01: Vliv hustoty prekazek ===\n\n');

for hi = 1:length(HUSTOTY)
    h = HUSTOTY(hi);
    fprintf('Hustota %d %% ... ', h);

    for b = 1:POCET_BEH
        rng(100 + hi*100 + b); % reprodukovatelny seed pro kazdy beh

        bludiste = generuj_bludiste(N, h);

        % BFS
        tic; [c, k, ~] = bfs(bludiste, start, cil); cas_bfs(hi,b) = toc;
        if ~isempty(c)
            del_bfs(hi,b) = size(c,1);
            kro_bfs(hi,b) = k;
            pruchozi(hi)  = pruchozi(hi) + 1;
        end

        % DFS
        tic; [c, k, ~] = dfs(bludiste, start, cil); cas_dfs(hi,b) = toc;
        if ~isempty(c); del_dfs(hi,b) = size(c,1); kro_dfs(hi,b) = k; end

        % A* s Manhattan heuristikou
        tic; [c, k, ~] = astar(bludiste, start, cil, 'manhattan'); cas_ast(hi,b) = toc;
        if ~isempty(c); del_ast(hi,b) = size(c,1); kro_ast(hi,b) = k; end
    end
    fprintf('hotovo\n');
end

% Vypocet statistik (pouze pruchozi bludiste -- delka > 0)
fprintf('\n--- Vysledky: prumerna delka cesty ---\n');
fprintf('%-10s %8s %8s %8s %8s\n', 'Hustota', 'BFS', 'DFS', 'A*', 'Pruchozi');
for hi = 1:length(HUSTOTY)
    idx = del_bfs(hi,:) > 0;
    fprintf('%-10d %8.1f %8.1f %8.1f %7d/%d\n', HUSTOTY(hi), ...
        mean(del_bfs(hi,idx)), mean(del_dfs(hi,idx)), mean(del_ast(hi,idx)), ...
        pruchozi(hi), POCET_BEH);
end

fprintf('\n--- Vysledky: prumerny pocet expandovanych uzlu ---\n');
fprintf('%-10s %8s %8s %8s\n', 'Hustota', 'BFS', 'DFS', 'A*');
for hi = 1:length(HUSTOTY)
    idx = kro_bfs(hi,:) > 0;
    fprintf('%-10d %8.1f %8.1f %8.1f\n', HUSTOTY(hi), ...
        mean(kro_bfs(hi,idx)), mean(kro_dfs(hi,idx)), mean(kro_ast(hi,idx)));
end

% Ulozeni vysledku pro souhrnny skript
save('../vysledky/exp01_data.mat', 'HUSTOTY', 'del_bfs', 'del_dfs', 'del_ast', ...
    'kro_bfs', 'kro_dfs', 'kro_ast', 'cas_bfs', 'cas_dfs', 'cas_ast', 'pruchozi');

% Graf 1: prumerna delka cesty
idx_pruch = arrayfun(@(hi) del_bfs(hi,:) > 0, 1:length(HUSTOTY), 'UniformOutput', false);
mu_del_bfs = arrayfun(@(hi) mean(del_bfs(hi, idx_pruch{hi})), 1:length(HUSTOTY));
mu_del_dfs = arrayfun(@(hi) mean(del_dfs(hi, idx_pruch{hi})), 1:length(HUSTOTY));
mu_del_ast = arrayfun(@(hi) mean(del_ast(hi, idx_pruch{hi})), 1:length(HUSTOTY));

figure('Visible','off');
plot(HUSTOTY, mu_del_bfs, 'b-o', 'LineWidth', 2, 'MarkerSize', 8); hold on;
plot(HUSTOTY, mu_del_dfs, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
plot(HUSTOTY, mu_del_ast, 'g-^', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Hustota prekazek (%)');
ylabel('Prumerna delka cesty (pocet kroku)');
title('Experiment 01 -- Vliv hustoty prekazek na delku cesty');
legend('BFS', 'DFS', 'A* (Manhattan)', 'Location', 'northwest');
grid on;
saveas(gcf, '../vysledky/grafy/exp01_delka_cesty.png');

% Graf 2: pocet expandovanych uzlu
mu_kro_bfs = arrayfun(@(hi) mean(kro_bfs(hi, idx_pruch{hi})), 1:length(HUSTOTY));
mu_kro_dfs = arrayfun(@(hi) mean(kro_dfs(hi, idx_pruch{hi})), 1:length(HUSTOTY));
mu_kro_ast = arrayfun(@(hi) mean(kro_ast(hi, idx_pruch{hi})), 1:length(HUSTOTY));

figure('Visible','off');
plot(HUSTOTY, mu_kro_bfs, 'b-o', 'LineWidth', 2, 'MarkerSize', 8); hold on;
plot(HUSTOTY, mu_kro_dfs, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
plot(HUSTOTY, mu_kro_ast, 'g-^', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Hustota prekazek (%)');
ylabel('Prumerny pocet expandovanych uzlu');
title('Experiment 01 -- Vliv hustoty prekazek na pocet expandovanych uzlu');
legend('BFS', 'DFS', 'A* (Manhattan)', 'Location', 'northwest');
grid on;
saveas(gcf, '../vysledky/grafy/exp01_pocet_uzlu.png');

fprintf('\nGrafy ulozeny do vysledky/grafy/\n');
