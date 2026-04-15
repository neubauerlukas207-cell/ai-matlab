function y = perceptron_prah(vstupy, vahy, prah)
    s = sum(vstupy .* vahy) - prah;
    y = double(s >= 0);
end