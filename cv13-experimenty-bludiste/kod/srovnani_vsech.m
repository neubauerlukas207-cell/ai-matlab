%SROVNANI_VSECH Souhrnny skript -- nacte vysledky vsech experimentu a
%   vygeneruje hlavni souhrnne grafy pro prezentaci.
%   Spoustejte az po spusteni vsech 5 experimentu.

clear; clc;

fprintf('=== SOUHRNNE SROVNANI VSECH EXPERIMENTU ===\n\n');

% Nacist data z experimentu
load('../vysledky/exp01_data.mat');
exp01_kro_bfs = kro_bfs; exp01_kro_dfs = kro_dfs; exp01_kro_ast = kro_ast;
exp01_del_bfs = del_bfs; exp01_del_dfs = del_dfs; exp01_del_ast = del_ast;
exp01_hustoty = HUSTOTY;

load('../vysledky/exp02_data.mat');
exp02_cas_bfs = cas_bfs; exp02_cas_dfs = cas_dfs; exp02_cas_ast = cas_ast;
exp02_velikosti = VELIKOSTI;

load('../vysledky/exp03_data.mat');
exp03_kro = kro_h; exp03_popisky = POPISKY;

load('../vysledky/exp05_data.mat');
exp05_hustoty = HUSTOTY; exp05_pruchozost = pruchozost_pct;

% --- Souhrnna tabulka ---
fprintf('%-30s | %-10s | %-10s | %-10s\n', 'Experiment', 'BFS', 'DFS', 'A*');
fprintf('%s\n', repmat('-', 1, 65));

idx = exp01_del_bfs(2,:) > 0; % hustota 20 % (baseline podmínky)
fprintf('%-30s | %10.1f | %10.1f | %10.1f\n', ...
    'Delka cesty (20x20, 20 %)', ...
    mean(exp01_del_bfs(2,idx)), mean(exp01_del_dfs(2,idx)), mean(exp01_del_ast(2,idx)));

idx = exp01_kro_bfs(2,:) > 0;
fprintf('%-30s | %10.1f | %10.1f | %10.1f\n', ...
    'Pocet uzlu (20x20, 20 %)', ...
    mean(exp01_kro_bfs(2,idx)), mean(exp01_kro_dfs(2,idx)), mean(exp01_kro_ast(2,idx)));

idx = exp02_cas_bfs(end,:) > 0; % nejvetsi mrizka
fprintf('%-30s | %10.6f | %10.6f | %10.6f\n', ...
    'Cas behu (100x100, 20 %)', ...
    mean(exp02_cas_bfs(end,idx)), mean(exp02_cas_dfs(end,idx)), mean(exp02_cas_ast(end,idx)));

% Hlavni souhrnny graf -- bar chart pro vsechny algoritmy pri baseline podminkach
figure('Visible','off');
idx = exp01_kro_bfs(2,:) > 0;
hodnoty = [mean(exp01_kro_bfs(2,idx)), mean(exp01_kro_dfs(2,idx)), mean(exp01_kro_ast(2,idx))];
bar(hodnoty, 0.5);
set(gca, 'XTickLabel', {'BFS', 'DFS', 'A* (Manhattan)'});
xlabel('Algoritmus');
ylabel('Prumerny pocet expandovanych uzlu');
title('Souhrnne srovnani -- Pocet expandovanych uzlu (20x20, 20 % prekazek)');
grid on;
saveas(gcf, '../vysledky/grafy/srovnani_vsech_uzly.png');

% Graf konvergence casu s velikosti
idx_f = @(vi) exp02_cas_bfs(vi,:) > 0;
mu_bfs = arrayfun(@(vi) mean(exp02_cas_bfs(vi, idx_f(vi))), 1:length(exp02_velikosti));
mu_dfs = arrayfun(@(vi) mean(exp02_cas_dfs(vi, idx_f(vi))), 1:length(exp02_velikosti));
mu_ast = arrayfun(@(vi) mean(exp02_cas_ast(vi, idx_f(vi))), 1:length(exp02_velikosti));

figure('Visible','off');
semilogy(exp02_velikosti, mu_bfs, 'b-o', 'LineWidth', 2, 'MarkerSize', 8); hold on;
semilogy(exp02_velikosti, mu_dfs, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
semilogy(exp02_velikosti, mu_ast, 'g-^', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Velikost mrizky (N)');
ylabel('Cas behu (s) -- logaritmicka skala');
title('Souhrnne srovnani -- Skalovani casu s velikosti mrizky');
legend('BFS', 'DFS', 'A* (Manhattan)', 'Location', 'northwest');
grid on;
saveas(gcf, '../vysledky/grafy/srovnani_vsech_cas.png');

% Souhrnna tabulka do souboru
fid = fopen('../vysledky/tabulky/srovnani_parametru.txt', 'w');
fprintf(fid, 'Souhrnna tabulka experimentu -- BFS vs DFS vs A*\n');
fprintf(fid, '=================================================\n\n');
fprintf(fid, 'Experiment 01 -- Vliv hustoty prekazek (mrizka 20x20)\n');
fprintf(fid, '%-8s %10s %10s %10s %10s\n', 'Hustota', 'Del.BFS', 'Del.DFS', 'Del.A*', 'Pruchozi');
for hi = 1:length(exp01_hustoty)
    idx = exp01_del_bfs(hi,:) > 0;
    if any(idx)
        fprintf(fid, '%-8d %10.1f %10.1f %10.1f %9d/30\n', exp01_hustoty(hi), ...
            mean(exp01_del_bfs(hi,idx)), mean(exp01_del_dfs(hi,idx)), ...
            mean(exp01_del_ast(hi,idx)), sum(idx));
    end
end
fprintf(fid, '\nExperiment 03 -- Heuristiky A* (mrizka 20x20, hustota 20 %%)\n');
fprintf(fid, '%-12s %10s %10s\n', 'Heuristika', 'Uzlu', 'Del.cesty');
for hi = 1:length(exp03_popisky)
    idx = exp03_kro(hi,:) > 0;
    fprintf(fid, '%-12s %10.1f %10.1f\n', exp03_popisky{hi}, ...
        mean(exp03_kro(hi,idx)), mean(exp03_kro(hi,idx)));
end
fclose(fid);

fprintf('\nSouhrnne grafy a tabulka ulozeny.\n');
