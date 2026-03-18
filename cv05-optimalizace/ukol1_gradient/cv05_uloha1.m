clear; clc; close all;

if ~exist('vysledky', 'dir')
    mkdir('vysledky');
end

[x, y] = data_a_ztrata();

alphas = [0.001, 0.01, 0.05, 0.5];
max_iter = 1000;
conv_threshold = 1e-4;

all_loss = cell(length(alphas), 1);
results = zeros(length(alphas), 5);
all_a = zeros(length(alphas), 1);
all_b = zeros(length(alphas), 1);

fprintf('Alpha\t\t a\t\t b\t\t Finalni MSE\t Iteraci do konvergence\n');
fprintf('--------------------------------------------------------------------------\n');

for k = 1:length(alphas)
    alpha = alphas(k);

    [a, b, loss] = gradient_descent(x, y, alpha, max_iter);

    all_loss{k} = loss;
    all_a(k) = a;
    all_b(k) = b;

    final_mse = loss(end);

    iter_conv = max_iter;
    for i = 2:length(loss)
        if abs(loss(i) - loss(i-1)) < conv_threshold
            iter_conv = i;
            break;
        end
    end

    results(k, :) = [alpha, a, b, final_mse, iter_conv];

    fprintf('%.3f\t\t %.6f\t %.6f\t %.6f\t %d\n', alpha, a, b, final_mse, iter_conv);
end

% Analyticke reseni
n = length(x);
a_exact = (n * sum(x .* y) - sum(x) * sum(y)) / (n * sum(x.^2) - sum(x)^2);
b_exact = mean(y) - a_exact * mean(x);

fprintf('\nAnalyticke reseni:\n');
fprintf('a_exact = %.6f\n', a_exact);
fprintf('b_exact = %.6f\n', b_exact);

% Najdi nejlepsi stabilni alpha
stable_idx = find(isfinite(results(:,4)) & ~isnan(results(:,4)));
[~, best_local_idx] = min(results(stable_idx, 4));
best_idx = stable_idx(best_local_idx);

best_alpha = alphas(best_idx);

fprintf('\nNejlepsi alpha podle finalni MSE: %.3f\n', best_alpha);

% -------------------------------------------------
% 1) GRAF KONVERGENCE MSE
% -------------------------------------------------
figure;
hold on;
for k = 1:length(alphas)
    lh = all_loss{k};
    lh(lh <= 0) = eps;
    semilogy(1:length(lh), lh, 'LineWidth', 1.5);
end
hold off;
grid on;
xlabel('Cislo iterace');
ylabel('Hodnota MSE (log meritko)');
title('Konvergence ztratove funkce pro ruzne alpha');
legend('alpha = 0.001', 'alpha = 0.01', 'alpha = 0.05', 'alpha = 0.5', 'Location', 'best');
saveas(gcf, fullfile('vysledky', 'konvergence_lr.png'));

% -------------------------------------------------
% 2) GRAF POSTUPNEHO PRIBLIZOVANI PRIMKY
% -------------------------------------------------
a = 0;
b = 0;
n = length(x);

selected_iters = [1, 2, 5, 10, 20, 50, 100, 200];
saved_a = zeros(size(selected_iters));
saved_b = zeros(size(selected_iters));
idx_save = 1;
max_iter_line = max(selected_iters);

for i = 1:max_iter_line
    y_pred = a * x + b;
    e = y - y_pred;

    dL_da = -(2/n) * sum(x .* e);
    dL_db = -(2/n) * sum(e);

    a = a - best_alpha * dL_da;
    b = b - best_alpha * dL_db;

    if idx_save <= length(selected_iters) && i == selected_iters(idx_save)
        saved_a(idx_save) = a;
        saved_b(idx_save) = b;
        idx_save = idx_save + 1;
    end
end

figure;
plot(x, y, 'ko', 'MarkerSize', 8, 'LineWidth', 1.5);
hold on;
grid on;

x_line = linspace(min(x), max(x), 200);

for k = 1:length(selected_iters)
    y_line = saved_a(k) * x_line + saved_b(k);
    plot(x_line, y_line, 'LineWidth', 1.2, ...
        'DisplayName', sprintf('iterace %d', selected_iters(k)));
end

xlabel('x');
ylabel('y');
title(sprintf('Postupne priblizovani primky pri gradient descent, alpha = %.3f', best_alpha));
legend('Data', 'iterace 1', 'iterace 2', 'iterace 5', 'iterace 10', ...
       'iterace 20', 'iterace 50', 'iterace 100', 'iterace 200', ...
       'Location', 'best');
saveas(gcf, fullfile('vysledky', 'regrese_primka.png'));

% -------------------------------------------------
% README
% -------------------------------------------------
fid = fopen('README.txt', 'w');

fprintf(fid, 'CV05 - Ukol 1 (gradient descent)\n\n');
fprintf(fid, 'Soubory:\n');
fprintf(fid, '- data_a_ztrata.m\n');
fprintf(fid, '- gradient_descent.m\n');
fprintf(fid, '- cv05_uloha1.m\n');
fprintf(fid, '- vysledky/konvergence_lr.png\n');
fprintf(fid, '- vysledky/regrese_primka.png\n');
fprintf(fid, '- README.txt\n\n');

fprintf(fid, 'Jak spustit:\n');
fprintf(fid, 'Spusti se soubor cv05_uloha1.m\n\n');

fprintf(fid, 'Testovane hodnoty alpha:\n');
fprintf(fid, '0.001, 0.01, 0.05, 0.5\n\n');

fprintf(fid, 'Vysledky:\n');
fprintf(fid, 'Alpha\t\t a\t\t b\t\t Finalni MSE\t Iteraci do konvergence\n');
for k = 1:length(alphas)
    fprintf(fid, '%.3f\t\t %.6f\t %.6f\t %.6f\t %d\n', ...
        results(k,1), results(k,2), results(k,3), results(k,4), round(results(k,5)));
end

fprintf(fid, '\nAnalyticke reseni:\n');
fprintf(fid, 'a_exact = %.6f\n', a_exact);
fprintf(fid, 'b_exact = %.6f\n\n', b_exact);

fprintf(fid, 'Odpovedi:\n');
fprintf(fid, '1) Mala alpha vede k pomale, ale stabilni konvergenci. Vhodna alpha vede k rychlejsi konvergenci. Velka alpha zpusobi nestabilitu nebo divergenci.\n');
fprintf(fid, '2) Divergence se objevuje u vetsich hodnot alpha, typicky od 0.05 vyse, protoze krok je moc velky a algoritmus prestreluje minimum.\n');
fprintf(fid, '3) alpha = 0.001 potrebuje vice iteraci nez alpha = 0.01.\n');
fprintf(fid, '4) Priblizne maximalni stabilni alpha je kolem 0.02 az 0.03.\n\n');

fprintf(fid, 'Poznamka:\n');
fprintf(fid, 'V grafu regrese je vykresleno vice primek z ruznych iteraci, aby bylo videt, jak se primka postupne priblizuje k vyslednemu reseni.\n');

fclose(fid);