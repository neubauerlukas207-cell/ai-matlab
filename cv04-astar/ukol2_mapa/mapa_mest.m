function [mesta, matice_vzdalenosti, letecke_vzdalenosti, start, cil, pozice] = mapa_mest()
% MAPA_MEST Definice mapy mest pro ukol 2
% vystup:
%   mesta                ... nazvy mest
%   matice_vzdalenosti   ... symetricka matice vzdalenosti po silnici
%   letecke_vzdalenosti  ... heuristika h(n) = odhad vzdalenosti do cile
%   start                ... index startovniho mesta
%   cil                  ... index ciloveho mesta
%   pozice               ... souradnice mest pro vizualizaci

    mesta = {'Alpov', 'Borkov', 'Cedrov', 'Dolany', 'Edlov', 'Grunov', 'Filipov', 'Hradec'};

    % indexy:
    % 1 Alpov
    % 2 Borkov
    % 3 Cedrov
    % 4 Dolany
    % 5 Edlov
    % 6 Grunov
    % 7 Filipov
    % 8 Hradec

    matice_vzdalenosti = zeros(8, 8);

    % horni vetev
    matice_vzdalenosti(1,2) = 70;   matice_vzdalenosti(2,1) = 70;
    matice_vzdalenosti(2,4) = 170;  matice_vzdalenosti(4,2) = 170;
    matice_vzdalenosti(4,6) = 60;   matice_vzdalenosti(6,4) = 60;
    matice_vzdalenosti(6,8) = 140;  matice_vzdalenosti(8,6) = 140;

    % dolni vetev
    matice_vzdalenosti(1,3) = 95;   matice_vzdalenosti(3,1) = 95;
    matice_vzdalenosti(3,5) = 85;   matice_vzdalenosti(5,3) = 85;
    matice_vzdalenosti(5,7) = 110;  matice_vzdalenosti(7,5) = 110;
    matice_vzdalenosti(7,8) = 60;   matice_vzdalenosti(8,7) = 60;

    % heuristika - letecka vzdalenost do Hradce
    letecke_vzdalenosti = [250, 200, 205, 120, 140, 110, 50, 0];

    start = 1; % Alpov
    cil = 8;   % Hradec

    % pozice pro vykresleni [x y]
    pozice = [
        0,  0;   % Alpov
        2,  2;   % Borkov
        2, -2;   % Cedrov
        5,  2;   % Dolany
        5, -2;   % Edlov
        8,  2;   % Grunov
        8, -2;   % Filipov
        10, 0    % Hradec
    ];
end