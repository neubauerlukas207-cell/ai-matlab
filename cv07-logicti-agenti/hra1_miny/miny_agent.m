function [bezpecna, miny_nalezene] = miny_agent(miny)
bezpecna = [];
miny_nalezene = [];

for i = 1:miny.N
    for j = 1:miny.M
        if ~miny.odkryto(i,j)
            continue;
        end

        if miny.pole(i,j) <= 0
            continue;
        end

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
                    if miny.vlajky(ni,nj)
                        pocet_vlajek = pocet_vlajek + 1;
                    elseif ~miny.odkryto(ni,nj)
                        skryti(end+1,:) = [ni nj];
                    end
                end
            end
        end

        if isempty(skryti)
            continue;
        end

        if miny.pole(i,j) - pocet_vlajek == size(skryti,1)
            miny_nalezene = [miny_nalezene; skryti];
        end

        if miny.pole(i,j) == pocet_vlajek
            bezpecna = [bezpecna; skryti];
        end
    end
end

if ~isempty(bezpecna)
    bezpecna = unique(bezpecna,'rows');
end

if ~isempty(miny_nalezene)
    miny_nalezene = unique(miny_nalezene,'rows');
end
end