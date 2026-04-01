function miny = generuj_miny(N,M,pocet_min)
miny.N = N;
miny.M = M;
miny.pole = zeros(N,M);
miny.odkryto = false(N,M);
miny.vlajky = false(N,M);

idx = randperm(N*M, pocet_min);
miny.pole(idx) = -1;

for i = 1:N
    for j = 1:M
        if miny.pole(i,j) == -1
            continue;
        end

        c = 0;
        for di = -1:1
            for dj = -1:1
                if di == 0 && dj == 0
                    continue;
                end
                ni = i + di;
                nj = j + dj;
                if ni >= 1 && ni <= N && nj >= 1 && nj <= M
                    if miny.pole(ni,nj) == -1
                        c = c + 1;
                    end
                end
            end
        end
        miny.pole(i,j) = c;
    end
end
end