function [stav, cilovy_stav] = generuj_puzzle()
% GENERUJ_PUZZLE Vygeneruje nahodny resitelny stav 8-puzzle
% stav je reprezentovan jako vektor 1x9, kde 0 = prazdne pole

    cilovy_stav = [1 2 3 4 5 6 7 8 0];

    while true
        kandidat = randperm(9) - 1;  % hodnoty 0..8
        if je_resitelny(kandidat)
            stav = kandidat;
            return;
        end
    end
end

function res = je_resitelny(stav)
% Pro 8-puzzle je stav resitelny prave tehdy, kdyz je pocet inverzi sudy

    arr = stav(stav ~= 0);
    inv_count = 0;

    for i = 1:length(arr)-1
        for j = i+1:length(arr)
            if arr(i) > arr(j)
                inv_count = inv_count + 1;
            end
        end
    end

    res = mod(inv_count, 2) == 0;
end