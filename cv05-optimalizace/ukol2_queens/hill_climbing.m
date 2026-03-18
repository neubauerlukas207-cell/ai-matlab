function [stav,h,kroky] = hill_climbing(stav)

    N = length(stav);
    kroky = 0;
    h = queens_utils('conf',stav);

    while true
        best = stav;
        best_h = h;

        for i=1:N-1
            for j=i+1:N
                s = stav;
                s([i j]) = s([j i]);

                h2 = queens_utils('conf',s);

                if h2 < best_h
                    best = s;
                    best_h = h2;
                end
            end
        end

        if best_h >= h
            break;
        end

        stav = best;
        h = best_h;
        kroky = kroky + 1;

        if h == 0
            break;
        end
    end
end