clear; clc; close all;

if ~exist('vysledky','dir')
    mkdir('vysledky');
end

N = 8;
runs = 100;

final_h = zeros(1,runs);
steps = zeros(1,runs);

for i=1:runs
    s = queens_utils('gen',N);
    [s,h,k] = hill_climbing(s);

    final_h(i) = h;
    steps(i) = k;
end

fprintf('Uspesnost: %.2f %%\n', 100*sum(final_h==0)/runs);
fprintf('Prumer kroku: %.2f\n', mean(steps));

% HISTOGRAM
figure;
histogram(final_h);
saveas(gcf,'vysledky/histogram_konflikty.png');

% VYKRESLENI SACHOVNICE
s = queens_utils('gen',N);
[s,h,~] = hill_climbing(s);

figure;
imagesc(zeros(N));
colormap(gray);
hold on;

for i=1:N
    text(s(i),i,'Q','HorizontalAlignment','center','FontSize',18);
end

set(gca,'YDir','reverse');
saveas(gcf,'vysledky/sachovnice_8dam.png');

