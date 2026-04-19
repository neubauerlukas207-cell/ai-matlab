% Dopredny pruchod site 2-2-1 pro funkci EKVIVALENCE se sigmoidni funkci
% Vstupy:
%   x1, x2 -- vstupni hodnoty (0 nebo 1)
%   W       -- struktura vah:
%                W.ih (2x2) -- vahy vstup -> skryta vrstva
%                W.ho (2x1) -- vahy skryta vrstva -> vystup
%   b       -- struktura biasu:
%                b.h (2x1)  -- biasy skrytych neuronu
%                b.o (1x1)  -- bias vystupniho neuronu
% Vystupy:
%   y       -- vystup site (cislo mezi 0 a 1)
%   h1, h2  -- vystupy skrytych neuronu (potreba pro backpropagation)

function [y, h1, h2] = sit_ekvivalence(x1, x2, W, b)
    % Skryty neuron 1 -- vazeny soucet vstupu + bias, pak sigmoid
    s_h1 = x1*W.ih(1,1) + x2*W.ih(2,1) + b.h(1);
    h1 = sigmoid(s_h1);

    % Skryty neuron 2 -- vazeny soucet vstupu + bias, pak sigmoid
    s_h2 = x1*W.ih(1,2) + x2*W.ih(2,2) + b.h(2);
    h2 = sigmoid(s_h2);

    % Vystupni neuron -- kombinuje vystupy skrytych neuronu + bias
    s_o = h1*W.ho(1) + h2*W.ho(2) + b.o;
    y = sigmoid(s_o);
end