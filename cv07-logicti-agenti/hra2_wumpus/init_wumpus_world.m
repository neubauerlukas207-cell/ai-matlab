function svet = init_wumpus_world(N)
% init_wumpus_world - nahodne inicializuje Wumpus World NxN
% Vstup:  N    - velikost mrizky (NxN)
% Vystup: svet - struktura sveta obsahujici:
%               .N               - rozmer
%               .wumpus_pozice   - [i, j]
%               .jamy            - logicka matice NxN (true = jama)
%               .zlato_pozice    - [i, j]
%               .agent_pozice    - [1, 1]
%               .agent_smer      - 'vychod'
%               .zlato_vzato     - false
%               .wumpus_ziv      - true

svet.N            = N;
svet.agent_pozice = [1 1];           % agent zacina vzdy na [1,1]
svet.agent_smer   = 'vychod';
svet.zlato_vzato  = false;
svet.wumpus_ziv   = true;
svet.jamy         = false(N);

% vsechna pole krome [1,1]
vsechna = [];
for i = 1:N
    for j = 1:N
        if ~(i == 1 && j == 1)
            vsechna(end+1, :) = [i j]; %#ok<AGROW>
        end
    end
end

perm = vsechna(randperm(size(vsechna, 1)), :); % nahodna permutace

% Wumpus - prvni v permutaci
svet.wumpus_pozice = perm(1, :);

% zlato - druhe v permutaci (ruzne od Wumpuse, vzdalene od startu)
svet.zlato_pozice  = perm(2, :);

% jamy - cca 20% zbylych poli (mimo [1,1], Wumpus a zlato)
pouzite = [svet.wumpus_pozice; svet.zlato_pozice; 1 1];
volna = [];
for k = 1:size(vsechna, 1)
    p = vsechna(k, :);
    je_pouzite = any(pouzite(:,1) == p(1) & pouzite(:,2) == p(2));
    if ~je_pouzite
        volna(end+1, :) = p; %#ok<AGROW>
    end
end

pocet_jam = max(1, round(0.2 * N * N));
pocet_jam = min(pocet_jam, size(volna, 1));

idx_jam = randperm(size(volna, 1), pocet_jam);
for k = 1:pocet_jam
    svet.jamy(volna(idx_jam(k), 1), volna(idx_jam(k), 2)) = true;
end

% bezpecnost - [1,1] nesmi byt jama ani Wumpus (uz zajisteno)
% [1,2] a [2,1] tez nesmejí byt jamy (zvysuje sance na bezpecny start)
svet.jamy(1, 2) = false;
svet.jamy(2, 1) = false;
end