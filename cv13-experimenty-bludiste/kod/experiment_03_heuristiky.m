%EXPERIMENT_03_HEURISTIKY Srovnani heuristik algoritmu A*.
%
%   Hypoteza: Manhattan heuristika bude nejucinnejsi pro 4-sousedstvi --
%   expanduje nejméne uzlu a zaroven zarucuje optimalitu. Euclidean bude
%   srovnatelna. Chebyshev podceni vzdalenost (vhodna pro 8-sousedstvi),
%   takze expanduje vice uzlu. Nulova heuristika (= Dijkstra) expanduje
%   nejvice uzlu ze vsech.
%
%   Provedeni: 4 heuristiky x 30 behu, mrizka 20x20, hustota 20 %.

clear; clc;

HEURISTIKY = {'manhattan', 'euclidean', 'chebyshev', 'nulova'};
POPISKY    = {'Manhattan', 'Euclidean', 'Chebyshev', 'Nulova'};
N          = 20;
HUSTOTA    = 20;
POCET_BEH  = 30;
start      = [1, 1];
cil        = [N, N];

fprintf('=== EXPERIMENT 03: Srovnani heuristik A* ===\n\n');

del_h = zeros(length(HEURISTIKY), POCET_BEH);
kro_h = zeros(length(HEURISTIKY), POCET_BEH);
cas_h = zeros(length(HEURISTIKY), POCET_BEH);

for hi = 1:length(HEURISTIKY)
    fprintf('Heuristika %s ... ', POPISKY{hi});
    for b = 1:POCET_BEH
        rng(300 + hi*100 + b);

        bludiste = generuj_bludiste(N, HUSTOTA);

        tic;
        [c, k, ~] = astar(bludiste, start, cil, HEURISTIKY{hi});
        cas_h(hi, b) = toc;

        if ~isempty(c)
            del_h(hi, b) = size(c, 1);
            kro_h(hi, b) = k;
        end
    end
    fprintf('hotovo\n');
end

% Statistiky
fprintf('\n--- Vysledky heuristik A* ---\n');
fprintf('%-12s %10s %10s %10s %10s\n', 'Heuristika', 'Del.cesty', 'Std del.', 'Uzlu', 'Cas (s)');
for hi = 1:length(HEURISTIKY)
    idx = del_h(hi,:) > 0;
    fprintf('%-12s %10.1f %10.2f %10.1f %10.6f\n', POPISKY{hi}, ...
        mean(del_h(hi,idx)), std(del_h(hi,idx)), ...
        mean(kro_h(hi,idx)), mean(cas_h(hi,idx)));
end

save('../vysledky/exp03_data.mat', 'HEURISTIKY', 'POPISKY', 'del_h', 'kro_h', 'cas_h');

% Graf: pocet expandovanych uzlu pro kazdu heuristiku (bar chart)
idx_f = @(hi) kro_h(hi,:) > 0;
mu_kro = arrayfun(@(hi) mean(kro_h(hi, idx_f(hi))), 1:length(HEURISTIKY));
sd_kro = arrayfun(@(hi) std(kro_h(hi,  idx_f(hi))), 1:length(HEURISTIKY));

figure('Visible','off');
bar(mu_kro, 0.6);
hold on;
errorbar(1:length(HEURISTIKY), mu_kro, sd_kro, 'k.', 'LineWidth', 1.5);
set(gca, 'XTickLabel', POPISKY);
xlabel('Heuristika');
ylabel('Prumerny pocet expandovanych uzlu');
title('Experiment 03 -- Srovnani heuristik A*');
grid on;
saveas(gcf, '../vysledky/grafy/exp03_heuristiky_uzly.png');

% Graf: delka cesty (mela by byt stejna pro Manhattan a BFS)
mu_del = arrayfun(@(hi) mean(del_h(hi, idx_f(hi))), 1:length(HEURISTIKY));

figure('Visible','off');
bar(mu_del, 0.6);
set(gca, 'XTickLabel', POPISKY);
xlabel('Heuristika');
ylabel('Prumerna delka cesty (pocet kroku)');
title('Experiment 03 -- Delka cesty pro ruzne heuristiky A*');
grid on;
saveas(gcf, '../vysledky/grafy/exp03_heuristiky_delka.png');

fprintf('\nGrafy ulozeny do vysledky/grafy/\n');
