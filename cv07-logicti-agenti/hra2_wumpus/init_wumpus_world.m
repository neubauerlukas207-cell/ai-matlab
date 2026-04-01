function svet = init_wumpus_world(N)
svet.N = N;
svet.agent_pozice = [1 1];
svet.agent_smer = 'vychod';
svet.zlato_vzato = false;
svet.wumpus_ziv = true;

svet.jamy = false(N);

if N ~= 5
    error('Pouzij N = 5, tahle pevna mapa je udelana pro 5x5.');
end

% Bezpecna testovaci mapa:
% start [1,1]
% bezpecna cesta ke zlatu:
% [1,1] -> [1,2] -> [1,3] -> [1,4] -> [1,5] -> [2,5] -> [3,5] -> [4,5] -> [5,5]

svet.wumpus_pozice = [5 1];
svet.zlato_pozice = [5 5];

svet.jamy(2,2) = true;
svet.jamy(3,2) = true;
svet.jamy(4,3) = true;
end