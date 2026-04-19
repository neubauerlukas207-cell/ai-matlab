% Sigmoidni aktivacni funkce
% Vstup:
%   s -- skalar nebo matice (vazeny soucet)
% Vystup:
%   y -- hodnota sigmoidu mezi 0 a 1

function y = sigmoid(s)
    % Vzorec: 1 / (1 + e^(-s))
    % Operator ./ zajistuje ze funkce funguje i pro matice
    y = 1 ./ (1 + exp(-s));
end