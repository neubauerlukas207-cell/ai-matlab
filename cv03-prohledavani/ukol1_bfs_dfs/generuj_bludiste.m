function bludiste = generuj_bludiste(n, hustota)

if nargin < 1
    n = 20;
end

if nargin < 2
    hustota = 0.15;
end

bludiste = rand(n,n) < hustota;
bludiste = double(bludiste);

% start a cil nesmi byt prekazka
bludiste(1,1) = 0;
bludiste(n,n) = 0;

end