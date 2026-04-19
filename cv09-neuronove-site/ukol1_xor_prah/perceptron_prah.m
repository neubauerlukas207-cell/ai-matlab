% Funkce perceptron s prahovou aktivacni funkci
% Vstupy:
%   vstupy -- vektor vstupnich hodnot (1 x N)
%   vahy   -- vektor vah (1 x N), stejna dimenze jako vstupy
%   prah   -- prahova hodnota (skalar)
% Vystup:
%   y      -- 0 nebo 1 (po aplikaci prahove funkce)

function y = perceptron_prah(vstupy, vahy, prah)
    % Vypocitej vazeny soucet vstupu a vah
    s = sum(vstupy .* vahy);
    % Odecti prah a aplikuj prahovou funkci (step)
    y = double(s - prah >= 0);
end