%EXPERIMENT_04_VZDALENOST Vliv vzdalenosti start--cil na vykon algoritmu.
%
%   Hypoteza: Vetsi vzdalenost mezi startem a cilem zvysuje pocet
%   expandovanych uzlu u vsech algoritmu. A* bude tezit z heuristiky
%   nejvice pri dlouhych cestach -- prinos heuristiky roste se vzdalenosti.
%   DFS bude mit nejvariabilnejsi delku cesty.
%
%   Provedeni: 3 konfigurace startu a cile x 30 behu, mrizka 20x20.

clear; clc;

N         = 20;
HUSTOTA   = 20;
POCET_BEH = 30;

% Tri konfigurace: rohy (max vzdalenost), stredy okraju, blizke body
KONFIGURACE = {
    [1,1],    [N,N],      'Rohy (max vzdalenost)';
    [1,N],    [N,1],      'Rohy (diagonala)';
    [N/2,1],  [N/2,N],    'Stred -- stred (vodorovne)';
};

fprintf('=== EXPERIMENT 04: Vliv vzdalenosti start--cil ===\n\n');

del_bfs = zeros(size(KONFIGURACE,1), POCET_BEH);
del_dfs = zeros(size(KONFIGURACE,1), POCET_BEH);
del_ast = zeros(size(KONFIGURACE,1), POCET_BEH);
kro_bfs = zeros(size(KONFIGURACE,1), POCET_BEH);
kro_dfs = zeros(size(KONFIGURACE,1), POCET_BEH);
kro_ast = zeros(size(KONFIGURACE,1), POCET_BEH);

for ki = 1:size(KONFIGURACE,1)
    start = KONFIGURACE{ki,1};
    cil   = KONFIGURACE{ki,2};
    popis = KONFIGURACE{ki,3};
    fprintf('Konfigurace: %s ... ', popis);

    for b = 1:POCET_BEH
        rng(400 + ki*100 + b);

        bludiste = generuj_bludiste(N, HUSTOTA);
        % Zajistit ze start a cil nejsou prekazka
        bludiste(start(1), start(2)) = 0;
        bludiste(cil(1),   cil(2))   = 0;

        [c,k,~] = bfs(bludiste, start, cil);
        if ~isempty(c); del_bfs(ki,b) = size(c,1); kro_bfs(ki,b) = k; end

        [c,k,~] = dfs(bludiste, start, cil);
        if ~isempty(c); del_dfs(ki,b) = size(c,1); kro_dfs(ki,b) = k; end

        [c,k,~] = astar(bludiste, start, cil, 'manhattan');
        if ~isempty(c); del_ast(ki,b) = size(c,1); kro_ast(ki,b) = k; end
    end
    fprintf('hotovo\n');
end

fprintf('\n--- Prumerna delka cesty ---\n');
fprintf('%-30s %8s %8s %8s\n', 'Konfigurace', 'BFS', 'DFS', 'A*');
for ki = 1:size(KONFIGURACE,1)
    idx = del_bfs(ki,:) > 0;
    fprintf('%-30s %8.1f %8.1f %8.1f\n', KONFIGURACE{ki,3}, ...
        mean(del_bfs(ki,idx)), mean(del_dfs(ki,idx)), mean(del_ast(ki,idx)));
end

fprintf('\n--- Prumerny pocet expandovanych uzlu ---\n');
fprintf('%-30s %8s %8s %8s\n', 'Konfigurace', 'BFS', 'DFS', 'A*');
for ki = 1:size(KONFIGURACE,1)
    idx = kro_bfs(ki,:) > 0;
    fprintf('%-30s %8.1f %8.1f %8.1f\n', KONFIGURACE{ki,3}, ...
        mean(kro_bfs(ki,idx)), mean(kro_dfs(ki,idx)), mean(kro_ast(ki,idx)));
end

save('../vysledky/exp04_data.mat', 'KONFIGURACE', 'del_bfs', 'del_dfs', 'del_ast', ...
    'kro_bfs', 'kro_dfs', 'kro_ast');

% Graf: srovnani poctu uzlu pro vsechny konfigurace a algoritmy
idx_f = @(ki) kro_bfs(ki,:) > 0;
mu_bfs = arrayfun(@(ki) mean(kro_bfs(ki, idx_f(ki))), 1:size(KONFIGURACE,1));
mu_dfs = arrayfun(@(ki) mean(kro_dfs(ki, idx_f(ki))), 1:size(KONFIGURACE,1));
mu_ast = arrayfun(@(ki) mean(kro_ast(ki, idx_f(ki))), 1:size(KONFIGURACE,1));

figure('Visible','off');
X = 1:size(KONFIGURACE,1);
bar(X, [mu_bfs; mu_dfs; mu_ast]', 0.8);
set(gca, 'XTickLabel', {KONFIGURACE{:,3}});
xlabel('Konfigurace start--cil');
ylabel('Prumerny pocet expandovanych uzlu');
title('Experiment 04 -- Vliv vzdalenosti start--cil');
legend('BFS', 'DFS', 'A* (Manhattan)', 'Location', 'northwest');
grid on;
saveas(gcf, '../vysledky/grafy/exp04_vzdalenost.png');

fprintf('\nGrafy ulozeny do vysledky/grafy/\n');
