% Testovaci skript pro overeni naucene site pro EKVIVALENCI
% Spusti uceni, otestuje sit a vykresli grafy

% Spust uceni site (W, b, mse_history, epoch jsou dostupne v workspace)
uceni_backprop;

fprintf('\n=== TEST SITE PRO EKVIVALENCI ===\n\n');
fprintf('x1  x2 | vystup (y) | zaokrouhleno | ocekavano | spravne?\n');
fprintf('------------------------------------------------------------\n');

% Trenovaci data
X = [0 0; 0 1; 1 0; 1 1];
T = [1; 0; 0; 1];

uspech = 0;

% Otestuj vsechny 4 kombinace vstupu
for i = 1:4
    x1 = X(i,1);
    x2 = X(i,2);
    t  = T(i);

    % Vypocitej vystup naucene site
    [y, ~, ~] = sit_ekvivalence(x1, x2, W, b);

    % Zaokrouhli vystup na 0 nebo 1
    y_round = round(y);

    % Porovnej s ocekavanym vystupem
    ok = (y_round == t);
    if ok
        uspech = uspech + 1;
        spravne = 'ANO';
    else
        spravne = 'NE';
    end

    fprintf(' %d   %d | %10.4f | %12d | %9d | %s\n', ...
        x1, x2, y, y_round, t, spravne);
end

fprintf('------------------------------------------------------------\n');
fprintf('Uspesnost: %d/4 (%.0f%%)\n', uspech, uspech/4*100);

% Vykresli graf prubeh uceni (MSE vs epochy)
figure;
plot(mse_history(1:epoch));
xlabel('Epocha');
ylabel('MSE (stredni kvadraticka chyba)');
title('Prubeh uceni site pro EKVIVALENCI');
grid on;
saveas(gcf, 'prubeh_uceni.png');
fprintf('\nGraf prubeh uceni ulozen jako prubeh_uceni.png\n');

% Vykresli rozhodovaci hranici site
figure;

% Vytvor mrizku bodu 100x100 v rozsahu [-0.5, 1.5]
[xx, yy] = meshgrid(linspace(-0.5, 1.5, 100), linspace(-0.5, 1.5, 100));

% Pro kazdy bod mrizky vypocitej vystup site
zz = zeros(size(xx));
for i = 1:numel(xx)
    [zz(i), ~, ~] = sit_ekvivalence(xx(i), yy(i), W, b);
end

% Zobraz rozhodovaci hranici jako barevnou mapu
contourf(xx, yy, zz, 20);
colorbar;
hold on;

% Pridej trenovaci body -- kolecka pro tridu 1, krizky pro tridu 0
for i = 1:4
    if T(i) == 1
        plot(X(i,1), X(i,2), 'wo', 'MarkerSize', 12, 'LineWidth', 2);
    else
        plot(X(i,1), X(i,2), 'wx', 'MarkerSize', 12, 'LineWidth', 2);
    end
end

title('Rozhodovaci hranice site pro EKVIVALENCI');
xlabel('x1');
ylabel('x2');
saveas(gcf, 'rozhodovaci_hranice.png');
fprintf('Graf rozhodovaci hranice ulozen jako rozhodovaci_hranice.png\n');