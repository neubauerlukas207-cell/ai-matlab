function [miny, vysledek, flood_count] = odkryj_pole(miny,i,j)
vysledek = 0;
flood_count = 0;

if i < 1 || i > miny.N || j < 1 || j > miny.M
    return;
end

if miny.odkryto(i,j) || miny.vlajky(i,j)
    return;
end

if miny.pole(i,j) == -1
    miny.odkryto(i,j) = true;
    vysledek = -1;
    return;
end

Q = [i j];

while ~isempty(Q)
    r = Q(1,1);
    s = Q(1,2);
    Q(1,:) = [];

    if miny.odkryto(r,s)
        continue;
    end

    miny.odkryto(r,s) = true;
    flood_count = flood_count + 1;

    if miny.pole(r,s) == 0
        for di = -1:1
            for dj = -1:1
                if di == 0 && dj == 0
                    continue;
                end

                ni = r + di;
                nj = s + dj;

                if ni >= 1 && ni <= miny.N && nj >= 1 && nj <= miny.M
                    if ~miny.odkryto(ni,nj) && ~miny.vlajky(ni,nj) && miny.pole(ni,nj) ~= -1
                        Q(end+1,:) = [ni nj];
                    end
                end
            end
        end
    end
end

if all(miny.odkryto(miny.pole ~= -1), 'all')
    vysledek = 1;
end
end