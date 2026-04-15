fprintf('=== TEST XOR SITE S PRAHOVOU FUNKCI ===\n\n');
fprintf('x1  x2  | skryty (h) | vystup (y) | ocekavano | spravne?\n');
fprintf('---------------------------------------------------------\n');

vstupy = [0 0; 0 1; 1 0; 1 1];
ocekavano = [0; 1; 1; 0];
spravne = 0;

for i = 1:4
    x1 = vstupy(i,1);
    x2 = vstupy(i,2);
    h = perceptron_prah([x1, x2], [0.3, 0.3], 0.5);
    y = xor_sit_prah(x1, x2);
    ok = (y == ocekavano(i));
    if ok, spravne = spravne + 1; end
    fprintf(' %d   %d  |     %d      |     %d      |     %d     | %s\n', ...
        x1, x2, h, y, ocekavano(i), 'ANO');
end

fprintf('\nUspesnost: %d/4 (%.0f%%)\n', spravne, spravne/4*100);