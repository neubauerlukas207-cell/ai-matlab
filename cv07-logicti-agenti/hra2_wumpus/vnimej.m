function percept = vnimej(svet, pozice)
% vnimej - vrati percepce agenta na aktualni pozici
% Vstup:  svet    - struktura sveta
%         pozice  - [i, j] aktualni pozice
% Vystup: percept - struktura:
%           .zapach - true pokud Wumpus sousedi s pozici (4 smery)
%           .vanek  - true pokud jama sousedi s pozici (4 smery)
%           .lesk   - true pokud zlato lezi na pozici
%           .naraz  - false (neni pouzito v tomto rezimu)

i = pozice(1);
j = pozice(2);
N = svet.N;

percept.zapach = false;
percept.vanek  = false;
percept.lesk   = isequal(pozice, svet.zlato_pozice) && ~svet.zlato_vzato;
percept.naraz  = false;

dirs = [-1 0; 1 0; 0 -1; 0 1];      % 4 sousede

for k = 1:4
    ni = i + dirs(k, 1);
    nj = j + dirs(k, 2);

    if ni < 1 || ni > N || nj < 1 || nj > N
        continue;                    % mimo mrizku
    end

    % Wumpus je zivy a sousedi s aktualni pozici?
    if svet.wumpus_ziv && isequal([ni nj], svet.wumpus_pozice)
        percept.zapach = true;
    end

    % jama sousedi s aktualni pozici?
    if svet.jamy(ni, nj)
        percept.vanek = true;
    end
end
end