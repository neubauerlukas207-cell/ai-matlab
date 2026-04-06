function [bezpecna, miny_nalezene] = miny_agent(miny)
% miny_agent - logicky agent odvozuje bezpecna pole a miny
% 1) cislo - vlajky == pocet skrytych sousedu -> skryti jsou miny
% 2) cislo == pocet vlajek -> ostatni skryti sousede jsou bezpecni
% 3) porovnani dvou sousednich odkrytych poli

bezpecna = [];
miny_nalezene = [];

for i = 1:miny.N
    for j = 1:miny.M
        if ~miny.odkryto(i, j)
            continue;
        end
        if miny.pole(i, j) <= 0
            continue;
        end

        [skryti, pocet_vlajek] = ziskej_skryte(miny, i, j);

        if isempty(skryti)
            continue;
        end

        if miny.pole(i, j) - pocet_vlajek == size(skryti, 1)
            miny_nalezene = [miny_nalezene; skryti]; %#ok<AGROW>
        end

        if miny.pole(i, j) == pocet_vlajek
            bezpecna = [bezpecna; skryti]; %#ok<AGROW>
        end
    end
end

% pokrocila inference
for i = 1:miny.N
    for j = 1:miny.M
        if ~miny.odkryto(i, j) || miny.pole(i, j) <= 0
            continue;
        end

        [skrytiA, vlajkyA] = ziskej_skryte(miny, i, j);
        effA = miny.pole(i, j) - vlajkyA;

        if isempty(skrytiA)
            continue;
        end

        for di = -1:1
            for dj = -1:1
                if di == 0 && dj == 0
                    continue;
                end

                ni = i + di;
                nj = j + dj;

                if ni < 1 || ni > miny.N || nj < 1 || nj > miny.M
                    continue;
                end
                if ~miny.odkryto(ni, nj) || miny.pole(ni, nj) <= 0
                    continue;
                end

                [skrytiB, vlajkyB] = ziskej_skryte(miny, ni, nj);
                effB = miny.pole(ni, nj) - vlajkyB;

                if isempty(skrytiB)
                    continue;
                end

                if je_podmnozina(skrytiB, skrytiA)
                    diff_skryte = odeber_podmnozinu(skrytiA, skrytiB);
                    diff_eff = effA - effB;

                    if ~isempty(diff_skryte)
                        if diff_eff == size(diff_skryte, 1)
                            miny_nalezene = [miny_nalezene; diff_skryte]; %#ok<AGROW>
                        elseif diff_eff == 0
                            bezpecna = [bezpecna; diff_skryte]; %#ok<AGROW>
                        end
                    end
                end
            end
        end
    end
end

if ~isempty(bezpecna)
    bezpecna = unique(bezpecna, 'rows');
end
if ~isempty(miny_nalezene)
    miny_nalezene = unique(miny_nalezene, 'rows');
end
end

function [skryti, pocet_vlajek] = ziskej_skryte(miny, i, j)
skryti = [];
pocet_vlajek = 0;

for di = -1:1
    for dj = -1:1
        if di == 0 && dj == 0
            continue;
        end

        ni = i + di;
        nj = j + dj;

        if ni >= 1 && ni <= miny.N && nj >= 1 && nj <= miny.M
            if miny.vlajky(ni, nj)
                pocet_vlajek = pocet_vlajek + 1;
            elseif ~miny.odkryto(ni, nj)
                skryti(end+1, :) = [ni nj]; %#ok<AGROW>
            end
        end
    end
end
end

function r = je_podmnozina(A, B)
r = true;
for k = 1:size(A, 1)
    nalezen = any(B(:,1) == A(k,1) & B(:,2) == A(k,2));
    if ~nalezen
        r = false;
        return;
    end
end
end

function D = odeber_podmnozinu(A, B)
D = [];
for k = 1:size(A, 1)
    if ~any(B(:,1) == A(k,1) & B(:,2) == A(k,2))
        D(end+1, :) = A(k, :); %#ok<AGROW>
    end
end
end