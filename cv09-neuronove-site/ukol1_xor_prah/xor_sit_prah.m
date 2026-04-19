% Sit pro vypocet funkce XOR s prahovou aktivacni funkci
% Architektura: 2 vstupy, 1 skryty neuron, 1 vystupni neuron
% Vstupy:
%   x1, x2 -- vstupni hodnoty (0 nebo 1)
% Vystup:
%   y      -- vysledek XOR (0 nebo 1)

function y = xor_sit_prah(x1, x2)
    % Skryty neuron -- pocita funkci AND
    % Vahy 0.3 a 0.3, prah 0.5 -- aktivuje se pouze kdyz x1=1 AND x2=1
    h = perceptron_prah([x1, x2], [0.3, 0.3], 0.5);

    % Vystupni neuron -- kombinuje vstupy a vystup skrytého neuronu
    % Primé vstupy (W=0.3) prispivaji pozitivne (tendence k OR)
    % Skryty neuron (W=-0.6) penalizuje AND
    % Prah 0.2 -- staci jeden vstup (0.3 > 0.2), ale AND se vynuluje
    y = perceptron_prah([x1, x2, h], [0.3, 0.3, -0.6], 0.2);
end