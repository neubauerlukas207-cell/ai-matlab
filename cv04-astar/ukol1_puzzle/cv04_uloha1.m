clear;
clc;
close all;

% hlavni skript pro ukol 1 - A* na 8-puzzle

rng('shuffle');

if ~exist('vysledky', 'dir')
    mkdir('vysledky');
end

heuristiky = {'manhattan', 'hamming', 'linearni_konflikt'};
nazvy = {'Manhattan', 'Hamming', 'Linearni konflikt'};

pocet_instanci = 20;
cilovy_stav = [1 2 3 4 5 6 7 8 0];

instance = zeros(pocet_instanci, 9);

for i = 1:pocet_instanci
    [stav, ~] = generuj_puzzle();
    instance(i, :) = stav;
end

delky = zeros(pocet_instanci, 3);
expandovane = zeros(pocet_instanci, 3);
casy = zeros(pocet_instanci, 3);
vsechna_reseni = cell(pocet_instanci, 3);

fprintf('=========================================\n');
fprintf('CV04 - Ukol 1 - A* na 8-puzzle\n');
fprintf('=========================================\n\n');

for i = 1:pocet_instanci
    fprintf('Instance %d/%d: [%s]\n', i, pocet_instanci, num2str(instance(i, :)));

    for h = 1:3
        [reseni, pocet_expandovanych, cas] = astar_puzzle(instance(i, :), cilovy_stav, heuristiky{h});

        vsechna_reseni{i, h} = reseni;
        delky(i, h) = length(reseni) - 1;
        expandovane(i, h) = pocet_expandovanych;
        casy(i, h) = cas;

        fprintf('  %s -> delka=%d, expandovano=%d, cas=%.6f s\n', ...
            nazvy{h}, delky(i, h), expandovane(i, h), casy(i, h));
    end

    fprintf('\n');
end

fprintf('\n=========================================\n');
fprintf('TEXTOVE STATISTIKY\n');
fprintf('=========================================\n\n');

for h = 1:3
    fprintf('%s\n', nazvy{h});
    fprintf('  Delka reseni (tahy):   prumer=%.2f, min=%d, max=%d\n', ...
        mean(delky(:, h)), min(delky(:, h)), max(delky(:, h)));
    fprintf('  Expandovane uzly:      prumer=%.2f, min=%d, max=%d\n', ...
        mean(expandovane(:, h)), min(expandovane(:, h)), max(expandovane(:, h)));
    fprintf('  Cas behu:              prumer=%.6f s\n', mean(casy(:, h)));
    fprintf('\n');
end

fprintf('=========================================\n');
fprintf('TABULKA - PRVNICH 5 INSTANCI\n');
fprintf('=========================================\n');

for i = 1:min(5, pocet_instanci)
    fprintf('Instance %d: [%s]\n', i, num2str(instance(i, :)));
    for h = 1:3
        fprintf('  %-18s delka=%2d, expandovano=%5d, cas=%.6f s\n', ...
            nazvy{h}, delky(i, h), expandovane(i, h), casy(i, h));
    end
    fprintf('\n');
end

% ---------------------------
% vizualizace 1 - sloupcovy graf
% ---------------------------
fig1 = figure('Name', 'Porovnani heuristik', 'Position', [100 100 1200 500]);
bar(expandovane, 'grouped');
xlabel('Instance');
ylabel('Pocet expandovanych uzlu (log)');
title('Porovnani heuristik pro 20 instanci 8-puzzle');
legend(nazvy, 'Location', 'northwest');
grid on;
set(gca, 'YScale', 'log');
saveas(fig1, fullfile('vysledky', 'porovnani_heuristik_puzzle.png'));

% ---------------------------
% vizualizace 2 - jedno reseni
% ---------------------------
% vybereme prvni instanci a Manhattan
reseni_ukazka = vsechna_reseni{1, 1};
n = length(reseni_ukazka);

if n <= 6
    indexy = 1:n;
else
    indexy = unique(round(linspace(1, n, 6)));
end

fig2 = figure('Name', 'Reseni puzzle', 'Position', [100 100 1400 250]);

for i = 1:length(indexy)
    subplot(1, length(indexy), i);
    vykresli_stav(reseni_ukazka{indexy(i)});
    if i == 1
        title('Start');
    elseif i == length(indexy)
        title('Cil');
    else
        title(sprintf('Krok %d', indexy(i)-1));
    end
end

sgtitle('Ukazka reseni 8-puzzle');
saveas(fig2, fullfile('vysledky', 'reseni_puzzle.png'));

fprintf('Obrazky ulozeny do slozky vysledky.\n');
fprintf('Hotovo.\n');

function vykresli_stav(stav)
    M = reshape(stav, 3, 3)';
    imagesc(M);
    axis equal tight;
    colormap(parula);
    set(gca, 'XTick', [], 'YTick', []);

    for r = 1:3
        for c = 1:3
            val = M(r, c);
            if val == 0
                text(c, r, '_', 'HorizontalAlignment', 'center', ...
                    'FontSize', 20, 'FontWeight', 'bold', 'Color', 'w');
            else
                text(c, r, num2str(val), 'HorizontalAlignment', 'center', ...
                    'FontSize', 20, 'FontWeight', 'bold', 'Color', 'w');
            end
        end
    end
end