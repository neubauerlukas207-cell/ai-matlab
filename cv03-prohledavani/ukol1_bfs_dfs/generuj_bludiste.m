function bludiste = generuj_bludiste(n, hustota)
%GENERUJ_BLUDISTE Vygeneruje nahodne ctvercove bludiste.
%   bludiste = generuj_bludiste(n, hustota)
%   Vstup:
%     n       - rozmer (napr. 20)
%     hustota - procento prekazek (napr. 15)
%   Vystup:
%     bludiste - matice n x n (0 = volno, 1 = prekazka)

    if nargin < 2
        hustota = 15;
    end
    if nargin < 1
        n = 20;
    end

    p = hustota / 100;          % procenta -> pravdepodobnost
    bludiste = rand(n, n) < p;  % nahodne prekazky (logical)

    % Start a cil nesmi byt prekazka
    bludiste(1,1) = 0;
    bludiste(n,n) = 0;

    bludiste = double(bludiste); % 0/1
end