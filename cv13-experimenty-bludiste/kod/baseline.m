%BASELINE Vychozi reseni -- BFS na mrizce 20x20 s 20 % prekazek.
%   Slouzi jako srovnavaci bod pro vsechny experimenty.
%   Spoustejte tento skript jako prvni pred experimenty.

clear; clc;

% Pevny seed pro reprodukovatelnost -- stejne vysledky pri kazdem spusteni
rng(42);

fprintf('=== BASELINE: BFS na mrizce 20x20, hustota prekazek 20 %% ===\n\n');

N         = 20;       % velikost mrizky
HUSTOTA   = 20;       % procento prekazek
POCET_BEH = 20;       % pocet opakovani pro statistiku

start = [1, 1];
cil   = [N, N];

% Pole pro ulozeni vysledku
delky_cesty  = zeros(POCET_BEH, 1);
pocty_kroku  = zeros(POCET_BEH, 1);
casy         = zeros(POCET_BEH, 1);
pruchozi     = 0;

for i = 1:POCET_BEH
    rng(42 + i); % ruzny seed pro kazde bludiste, ale reprodukovatelny

    bludiste = generuj_bludiste(N, HUSTOTA);

    % Merit pouze samotny algoritmus (bez vykreslovani)
    tic;
    [cesta, pocet_kroku, ~] = bfs(bludiste, start, cil);
    casy(i) = toc;

    if ~isempty(cesta)
        pruchozi = pruchozi + 1;
        delky_cesty(i) = size(cesta, 1);
        pocty_kroku(i) = pocet_kroku;
    end
end

% Vypocet statistik pouze pro pruchozi bludiste
idx = delky_cesty > 0;
fprintf('Parametry baseline:\n');
fprintf('  Velikost mrizky : %d x %d\n', N, N);
fprintf('  Hustota prekazek: %d %%\n', HUSTOTA);
fprintf('  Pocet behu      : %d\n', POCET_BEH);
fprintf('\nVysledky BFS (baseline):\n');
fprintf('  Pruchozich bludist : %d / %d (%.0f %%)\n', pruchozi, POCET_BEH, 100*pruchozi/POCET_BEH);
fprintf('  Prumerna delka cesty: %.1f kroku\n', mean(delky_cesty(idx)));
fprintf('  Prumerny pocet kroku: %.1f uzlu\n', mean(pocty_kroku(idx)));
fprintf('  Prumerny cas        : %.6f s\n', mean(casy(idx)));
fprintf('  Std delky cesty     : %.2f\n', std(delky_cesty(idx)));
