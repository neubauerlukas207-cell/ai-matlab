function factors = prime_factors(N)
% PRIME_FACTORS Rozklad celeho cisla na prvocinitele
%
%   factors = prime_factors(N)
%
%   VSTUP:
%       N - skalar, cele cislo
%
%   VYSTUP:
%       factors - radkovy vektor prvocinitelu vzestupne
%
%   PRIKLADY:
%       prime_factors(12)  -> [2 2 3]
%       prime_factors(100) -> [2 2 5 5]
%       prime_factors(17)  -> [17]
%       prime_factors(1)   -> []
%
% Poznamka:
%   Pro neplatny vstup funkce vraci [] a vypise varovani.

tic;

% Zakladni kontrola vstupu (aby to nepadalo na blbostech)
if ~isscalar(N) || ~isfinite(N) || isnan(N) || N ~= floor(N) || N <= 1
    warning('Neplatny vstup: musi to byt skalarni cele cislo > 1.');
    factors = [];
    toc;
    return;
end

n = N;
factors = [];

% 1) Nejdriv odstran vsechny dvojky (rychlejsi)
while mod(n, 2) == 0
    factors(end+1) = 2; %#ok<AGROW>
    n = n / 2;
end

% 2) Pak uz jen licha cisla
d = 3;
while d*d <= n
    while mod(n, d) == 0
        factors(end+1) = d; %#ok<AGROW>
        n = n / d;
    end
    d = d + 2;
end

% 3) Co zbylo, je prvocislo
if n > 1
    factors(end+1) = n;
end

toc;
end
