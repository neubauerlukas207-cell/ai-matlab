%EXPERIMENT_02_VELIKOST Vliv velikosti mrizky na vykon BFS, DFS a A*.
%
%   Hypoteza: S rostouci velikosti mrizky roste cas behu u vsech algoritmu.
%   A* bude nejrychlejsi diky heuristice -- expanduje mene uzlu nez BFS.
%   DFS bude nejpomalejsi co do delky cesty (nenajde optimalni reseni).
%
%   Provedeni: 4 velikosti mrizky x 20 behu, hustota prekazek fixni 20 %.

clear; clc;

VELIKOSTI = [10, 20, 50, 100]; % rozmery mrizky (NxN)
HUSTOTA   = 20;                % fixni hustota jako v baseline
POCET_BEH = 20;                % pocet opakovani

fprintf('=== EXPERIMENT 02: Vliv velikosti mrizky ===\n\n');

del_bfs = zeros(length(VELIKOSTI), POCET_BEH);
del_dfs = zeros(length(VELIKOSTI), POCET_BEH);
del_ast = zeros(length(VELIKOSTI), POCET_BEH);
kro_bfs = zeros(length(VELIKOSTI), POCET_BEH);
kro_dfs = zeros(length(VELIKOSTI), POCET_BEH);
kro_ast = zeros(length(VELIKOSTI), POCET_BEH);
cas_bfs = zeros(length(VELIKOSTI), POCET_BEH);
cas_dfs = zeros(length(VELIKOSTI), POCET_BEH);
cas_ast = zeros(length(VELIKOSTI), POCET_BEH);

for vi = 1:length(VELIKOSTI)
    N     = VELIKOSTI(vi);
    start = [1, 1];
    cil   = [N, N];
    fprintf('Velikost %dx%d ... ', N, N);

    for b = 1:POCET_BEH
        rng(200 + vi*100 + b);

        bludiste = generuj_bludiste(N, HUSTOTA);

        tic; [c,k,~] = bfs(bludiste, start, cil);                 cas_bfs(vi,b) = toc;
        if ~isempty(c); del_bfs(vi,b) = size(c,1); kro_bfs(vi,b) = k; end

        tic; [c,k,~] = dfs(bludiste, start, cil);                 cas_dfs(vi,b) = toc;
        if ~isempty(c); del_dfs(vi,b) = size(c,1); kro_dfs(vi,b) = k; end

        tic; [c,k,~] = astar(bludiste, start, cil, 'manhattan');  cas_ast(vi,b) = toc;
        if ~isempty(c); del_ast(vi,b) = size(c,1); kro_ast(vi,b) = k; end
    end
    fprintf('hotovo\n');
end

% Statistiky
fprintf('\n--- Prumerny cas behu (s) ---\n');
fprintf('%-10s %10s %10s %10s\n', 'Velikost', 'BFS', 'DFS', 'A*');
for vi = 1:length(VELIKOSTI)
    idx = cas_bfs(vi,:) > 0;
    fprintf('%-10d %10.6f %10.6f %10.6f\n', VELIKOSTI(vi), ...
        mean(cas_bfs(vi,idx)), mean(cas_dfs(vi,idx)), mean(cas_ast(vi,idx)));
end

save('../vysledky/exp02_data.mat', 'VELIKOSTI', 'del_bfs', 'del_dfs', 'del_ast', ...
    'kro_bfs', 'kro_dfs', 'kro_ast', 'cas_bfs', 'cas_dfs', 'cas_ast');

% Graf: cas behu podle velikosti (logaritmicka osa)
idx_f = @(vi) cas_bfs(vi,:) > 0;
mu_cas_bfs = arrayfun(@(vi) mean(cas_bfs(vi, idx_f(vi))), 1:length(VELIKOSTI));
mu_cas_dfs = arrayfun(@(vi) mean(cas_dfs(vi, idx_f(vi))), 1:length(VELIKOSTI));
mu_cas_ast = arrayfun(@(vi) mean(cas_ast(vi, idx_f(vi))), 1:length(VELIKOSTI));

figure('Visible','off');
semilogy(VELIKOSTI, mu_cas_bfs, 'b-o', 'LineWidth', 2, 'MarkerSize', 8); hold on;
semilogy(VELIKOSTI, mu_cas_dfs, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
semilogy(VELIKOSTI, mu_cas_ast, 'g-^', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Velikost mrizky (N)');
ylabel('Prumerny cas behu (s) -- logaritmicka skala');
title('Experiment 02 -- Vliv velikosti mrizky na cas behu');
legend('BFS', 'DFS', 'A* (Manhattan)', 'Location', 'northwest');
grid on;
saveas(gcf, '../vysledky/grafy/exp02_cas_behu.png');

% Graf: pocet expandovanych uzlu
mu_kro_bfs = arrayfun(@(vi) mean(kro_bfs(vi, idx_f(vi))), 1:length(VELIKOSTI));
mu_kro_dfs = arrayfun(@(vi) mean(kro_dfs(vi, idx_f(vi))), 1:length(VELIKOSTI));
mu_kro_ast = arrayfun(@(vi) mean(kro_ast(vi, idx_f(vi))), 1:length(VELIKOSTI));

figure('Visible','off');
plot(VELIKOSTI, mu_kro_bfs, 'b-o', 'LineWidth', 2, 'MarkerSize', 8); hold on;
plot(VELIKOSTI, mu_kro_dfs, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
plot(VELIKOSTI, mu_kro_ast, 'g-^', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Velikost mrizky (N)');
ylabel('Prumerny pocet expandovanych uzlu');
title('Experiment 02 -- Vliv velikosti mrizky na pocet expandovanych uzlu');
legend('BFS', 'DFS', 'A* (Manhattan)', 'Location', 'northwest');
grid on;
saveas(gcf, '../vysledky/grafy/exp02_pocet_uzlu.png');

fprintf('\nGrafy ulozeny do vysledky/grafy/\n');
