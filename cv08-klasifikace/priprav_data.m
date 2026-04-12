%% Nacteni Iris datasetu
load fisheriris

%% Vytvoreni tabulky
iris_tabulka = array2table(meas, 'VariableNames', ...
{'SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'});
iris_tabulka.Druh = species;

%% Nahodne oddeleni testovaci (holdout) sady
rng('shuffle');

n_celkem = height(iris_tabulka);

test_indexy = randperm(n_celkem, 15);

je_test = false(n_celkem, 1);
je_test(test_indexy) = true;

iris_test = iris_tabulka(je_test, :);   % 15 vzorku
iris_train = iris_tabulka(~je_test, :); % 135 vzorku

%% Ulozeni testovacich dat
save('test_vzorky.mat', 'iris_test');

%% Kontrola
fprintf('Trenovaci sada: %d vzorku\n', height(iris_train));
fprintf('Testovaci sada: %d vzorku\n', height(iris_test));