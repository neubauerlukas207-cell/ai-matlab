clear; clc; close all;

n = 20;
hustota = 0.15;
start = [1 1];
cil   = [n n];
pocet = 100;

if ~exist("vysledky","dir")
    mkdir("vysledky");
end

delky_BFS = zeros(pocet,1);
delky_DFS = zeros(pocet,1);
uzly_BFS  = zeros(pocet,1);
uzly_DFS  = zeros(pocet,1);

bludiste_list = cell(pocet,1);
cesty_BFS = cell(pocet,1);
cesty_DFS = cell(pocet,1);
nav_BFS   = cell(pocet,1);
nav_DFS   = cell(pocet,1);

i = 1;
pokusy = 0;

while i <= pocet
    pokusy = pokusy + 1;

    bl = generuj_bludiste(n, hustota);

    [cB, kB, vB] = bfs(bl, start, cil);
    if isempty(cB)
        continue
    end

    [cD, kD, vD] = dfs(bl, start, cil);
    if isempty(cD)
        continue
    end

    bludiste_list{i} = bl;
    cesty_BFS{i} = cB;
    cesty_DFS{i} = cD;
    nav_BFS{i} = vB;
    nav_DFS{i} = vD;

    delky_BFS(i) = size(cB,1);
    delky_DFS(i) = size(cD,1);
    uzly_BFS(i)  = kB;
    uzly_DFS(i)  = kD;

    i = i + 1;
end

% --- STATISTIKY ---
fprintf("STATISTIKY\n\n");

fprintf("BFS delka cesty: prumer %.2f | min %d | max %d\n", mean(delky_BFS), min(delky_BFS), max(delky_BFS));
fprintf("DFS delka cesty: prumer %.2f | min %d | max %d\n\n", mean(delky_DFS), min(delky_DFS), max(delky_DFS));

fprintf("BFS kroky:       prumer %.2f | min %d | max %d\n", mean(uzly_BFS), min(uzly_BFS), max(uzly_BFS));
fprintf("DFS kroky:       prumer %.2f | min %d | max %d\n\n", mean(uzly_DFS), min(uzly_DFS), max(uzly_DFS));

fprintf("DFS naslo delsi cestu nez BFS v %d z %d pripadu.\n", sum(delky_DFS > delky_BFS), pocet);
fprintf("Pokusy o generovani celkem: %d\n", pokusy);

% --- GRAF: prvnich 5 ---
k = 5;
figure("Color","w");

subplot(2,1,1);
bar([delky_BFS(1:k) delky_DFS(1:k)]);
grid on;
title("Porovnani delky cesty (prvnich 5)");
xlabel("Bludiste (1..5)");
ylabel("Delka cesty");
legend("BFS","DFS","Location","northwest");

subplot(2,1,2);
bar([uzly_BFS(1:k) uzly_DFS(1:k)]);
grid on;
title("Porovnani poctu kroku (prvnich 5)");
xlabel("Bludiste (1..5)");
ylabel("Kroky");
legend("BFS","DFS","Location","northwest");

saveas(gcf, fullfile("vysledky","porovnani_5_bludist.png"));

% --- VIZUALIZACE: jedno bludiste BFS vs DFS (barvy + navstivene) ---
idx = 1;
bl = bludiste_list{idx};
cB = cesty_BFS{idx}; vB = nav_BFS{idx};
cD = cesty_DFS{idx}; vD = nav_DFS{idx};

A = zeros(n,n); % BFS obraz
B = zeros(n,n); % DFS obraz

% 0 volno, 1 prekazka, 2 navstivene, 3 cesta, 4 start, 5 cil
A(bl==1) = 1;   B(bl==1) = 1;
A(vB) = 2;      B(vD) = 2;

A(sub2ind([n n], cB(:,1), cB(:,2))) = 3;
B(sub2ind([n n], cD(:,1), cD(:,2))) = 3;

A(start(1),start(2)) = 4;  B(start(1),start(2)) = 4;
A(cil(1),cil(2))     = 5;  B(cil(1),cil(2))     = 5;

cmap = [
    1 1 1;         % 0 volno
    0 0 0;         % 1 prekazka
    0.7 0.7 0.7;   % 2 navstivene
    0 0 1;         % 3 cesta
    0 1 0;         % 4 start
    1 0 0          % 5 cil
];

figure("Color","w");
subplot(1,2,1);
imagesc(A); axis image off; colormap(gca, cmap); caxis([0 5]);
title("BFS (vlevo)");

subplot(1,2,2);
imagesc(B); axis image off; colormap(gca, cmap); caxis([0 5]);
title("DFS (vpravo)");

saveas(gcf, fullfile("vysledky","bludiste_bfs_vs_dfs.png"));

fprintf("\nUlozeno do slozky: vysledky\n");