%EXPERIMENT_05_PRUCHOZOST Vlastni experiment -- pruchozost bludist pri ruzne hustote.
%
%   Hypoteza: Se zvysujici se hustotou prekazek klesa procento pruchozich
%   bludist. Existuje kriticka hustota (pravdepodobnostni prah) pri ktere
%   dochazi k prudkemu poklesu pruchozosti -- tzv. fazovy prechod.
%   Predpokladame ze tento prah je nekde mezi 30--40 % pro mrizku 20x20.
%
%   Provedeni: 10 hodnot hustoty x 100 behu, mrizka 20x20.
%   Pruchozost overujeme pomoci BFS (nejspolehlivejsi).

clear; clc;

HUSTOTY   = 5:5:50;   % procenta prekazek od 5 do 50
N         = 20;
POCET_BEH = 100;      % vice behu pro spolehlivejsi odhad pravdepodobnosti
start     = [1, 1];
cil       = [N, N];

fprintf('=== EXPERIMENT 05: Pruchozost bludist pri ruzne hustote ===\n\n');

pruchozi     = zeros(length(HUSTOTY), 1); % pocet pruchozich bludist
delky_cesty  = zeros(length(HUSTOTY), POCET_BEH);

for hi = 1:length(HUSTOTY)
    h = HUSTOTY(hi);
    for b = 1:POCET_BEH
        rng(500 + hi*200 + b);

        bludiste = generuj_bludiste(N, h);
        [c, ~, ~] = bfs(bludiste, start, cil);

        if ~isempty(c)
            pruchozi(hi)        = pruchozi(hi) + 1;
            delky_cesty(hi, b)  = size(c, 1);
        end
    end
    fprintf('Hustota %2d %%: pruchozi %3d / %d (%.0f %%)\n', ...
        h, pruchozi(hi), POCET_BEH, 100*pruchozi(hi)/POCET_BEH);
end

pruchozost_pct = 100 * pruchozi / POCET_BEH;

save('../vysledky/exp05_data.mat', 'HUSTOTY', 'pruchozi', 'pruchozost_pct', 'delky_cesty');

% Graf 1: pruchozost v zavislosti na hustote
figure('Visible','off');
plot(HUSTOTY, pruchozost_pct, 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Hustota prekazek (%)');
ylabel('Pruchozost bludiste (%)');
title('Experiment 05 -- Pruchozost bludiste v zavislosti na hustote prekazek');
grid on;
% Zvyrazneni kriticke oblasti
hold on;
yline(50, 'r--', 'LineWidth', 1.5);
legend('Pruchozost', 'Prah 50 %', 'Location', 'southwest');
saveas(gcf, '../vysledky/grafy/exp05_pruchozost.png');

% Graf 2: prumerna delka cesty pouze pro pruchozi bludiste
idx_f = @(hi) delky_cesty(hi,:) > 0;
mu_del = arrayfun(@(hi) mean(delky_cesty(hi, idx_f(hi))), 1:length(HUSTOTY));
mu_del(pruchozi == 0) = NaN; % pro nepruchozi nezobrazovat

figure('Visible','off');
plot(HUSTOTY, mu_del, 'g-s', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Hustota prekazek (%)');
ylabel('Prumerna delka cesty (pocet kroku)');
title('Experiment 05 -- Delka cesty v zavislosti na hustote (jen pruchozi)');
grid on;
saveas(gcf, '../vysledky/grafy/exp05_delka_cesty.png');

fprintf('\nGrafy ulozeny do vysledky/grafy/\n');
