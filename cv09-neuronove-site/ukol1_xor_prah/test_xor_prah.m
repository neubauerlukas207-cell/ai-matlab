% Testovaci skript pro overeni spravnosti XOR site s prahovou funkci
% Otestuje vsechny 4 kombinace vstupu a porovna s ocekavanym vystupem

fprintf('=== TEST XOR SITE S PRAHOVOU FUNKCI ===\n\n');
fprintf('x1  x2 | skryty (h) | vystup (y) | ocekavano | spravne?\n');
fprintf('----------------------------------------------------------\n');

% Vsechny 4 kombinace vstupu
vstupy = [0 0; 0 1; 1 0; 1 1];

% Ocekavane vystupy funkce XOR
ocekavano = [0; 1; 1; 0];

% Pocitadlo spravnych vysledku
uspech = 0;

% Prochazej vsechny kombinace vstupu
for i = 1:4
    x1 = vstupy(i,1);
    x2 = vstupy(i,2);

    % Vypocitej vystup skryteho neuronu
    h = perceptron_prah([x1, x2], [0.3, 0.3], 0.5);

    % Vypocitej vysledny vystup site
    y = xor_sit_prah(x1, x2);

    % Porovnej s ocekavanym vystupem
    ok = (y == ocekavano(i));
    if ok
        uspech = uspech + 1;
        spravne = 'ANO';
    else
        spravne = 'NE';
    end

    % Vypis radek tabulky
    fprintf(' %d   %d |     %d      |     %d      |     %d     | %s\n', ...
        x1, x2, h, y, ocekavano(i), spravne);
end

% Vypis celkove uspesnosti
fprintf('----------------------------------------------------------\n');
fprintf('Uspesnost: %d/4 (%.0f%%)\n', uspech, uspech/4*100);