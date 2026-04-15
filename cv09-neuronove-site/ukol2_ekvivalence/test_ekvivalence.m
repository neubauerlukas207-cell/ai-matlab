clc;
clear;

if ~exist('vysledky', 'dir')
    mkdir('vysledky');
end

% nauceni site
[W, b, errors] = uceni_backprop();

X = [0 0; 0 1; 1 0; 1 1];
T = [1; 0; 0; 1];

fprintf('\n=== TEST EKVIVALENCE ===\n');
fprintf('x1 x2 | y | ocekavano\n');

for i = 1:4
    x1 = X(i,1);
    x2 = X(i,2);

    [y, ~, ~] = sit_ekvivalence(x1, x2, W, b);

    fprintf('%d  %d  | %.3f | %d\n', x1, x2, y, T(i));
end

% =====================
% GRAF UCENI
% =====================
figure;
plot(errors);
xlabel('Epochy');
ylabel('MSE');
title('Prubeh uceni');
grid on;

saveas(gcf, 'vysledky/prubeh_uceni.png');

% =====================
% ROZHODOVACI PLOCHA
% =====================
[x1g, x2g] = meshgrid(0:0.01:1, 0:0.01:1);
yg = zeros(size(x1g));

for i = 1:numel(x1g)
    [yg(i), ~, ~] = sit_ekvivalence(x1g(i), x2g(i), W, b);
end

figure;
contourf(x1g, x2g, yg, 20);
colorbar;
title('Rozhodovaci plocha');

saveas(gcf, 'vysledky/rozhodovaci_plocha.png');