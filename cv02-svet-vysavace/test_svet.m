clc; clear; close all;

svet = svet_vysavace(10, 0.3);

figure;
svet.vizualizace();

s = svet.statistiky();
fprintf('Spinava: %d, Cista: %d, %%cisto: %.1f\n', ...
    s.dirty, s.clean, s.percent_clean);

% vycisti jedno pole a ukaž znovu
svet = svet.vycisti(2,3);
figure;
svet.vizualizace();
title('Po vycisteni (2,3)');