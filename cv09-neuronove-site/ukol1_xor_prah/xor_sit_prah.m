function y = xor_sit_prah(x1, x2)
    h = perceptron_prah([x1, x2], [0.3, 0.3], 0.5);
    y = perceptron_prah([x1, x2, h], [0.3, 0.3, -0.6], 0.2);
end