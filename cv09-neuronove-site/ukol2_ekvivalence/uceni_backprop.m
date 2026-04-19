% Uceni neuronove site backpropagation pro funkci EKVIVALENCE
% Pouziva sit 2-2-1 se sigmoidni aktivacni funkci

% Nastaveni parametru uceni
lr = 1.0;           % rychlost uceni (learning rate)
max_epoch = 10000;  % maximalni pocet epoch
cil_chyba = 0.01;   % cilova chyba MSE

% Trenovaci data -- EKVIVALENCE (opak XOR)
X = [0 0; 0 1; 1 0; 1 1];
T = [1; 0; 0; 1];

% Inicializace vah nahodnymi malymi hodnotami
% Nulove vahy by zpusobily ze se sit neuci (symetrie)
rng(42);  % fixni seed pro opakovatelnost vysledku
W.ih = randn(2,2) * 0.5;  % vahy vstup -> skryta vrstva (2x2)
W.ho = randn(2,1) * 0.5;  % vahy skryta vrstva -> vystup (2x1)
b.h  = randn(2,1) * 0.5;  % biasy skrytych neuronu
b.o  = randn(1,1) * 0.5;  % bias vystupniho neuronu

% Pole pro ukladani chyby MSE v kazde epoche (pro graf)
mse_history = zeros(max_epoch, 1);

% Hlavni trenovaci cyklus
for epoch = 1:max_epoch

    mse = 0;  % celkova chyba v teto epoche

    % Projdi vsechny 4 trenovaci vzory
    for i = 1:4
        x1 = X(i,1);
        x2 = X(i,2);
        t  = T(i);

        % DOPREDNY PRUCHOD -- vypocitej vystup site
        [y, h1, h2] = sit_ekvivalence(x1, x2, W, b);

        % VYPOCET CHYBY VYSTUPNIHO NEURONU (delta pravidlo)
        % delta_o = (y - t) * y * (1 - y)
        % (y - t)      -- jak moc se lisime od cile
        % y * (1 - y)  -- derivace sigmoidu
        delta_o = (y - t) * y * (1 - y);

        % VYPOCET CHYBY SKRYTYCH NEURONU (propagace chyby zpet)
        % chyba se siri zpet pres vahy W.ho
        delta_h1 = delta_o * W.ho(1) * h1 * (1 - h1);
        delta_h2 = delta_o * W.ho(2) * h2 * (1 - h2);

        % AKTUALIZACE VAH -- gradient descent
        % vahy skryta vrstva -> vystup
        W.ho(1) = W.ho(1) - lr * delta_o * h1;
        W.ho(2) = W.ho(2) - lr * delta_o * h2;
        b.o     = b.o     - lr * delta_o;

        % vahy vstup -> skryta vrstva (neuron 1)
        W.ih(1,1) = W.ih(1,1) - lr * delta_h1 * x1;
        W.ih(2,1) = W.ih(2,1) - lr * delta_h1 * x2;
        b.h(1)    = b.h(1)    - lr * delta_h1;

        % vahy vstup -> skryta vrstva (neuron 2)
        W.ih(1,2) = W.ih(1,2) - lr * delta_h2 * x1;
        W.ih(2,2) = W.ih(2,2) - lr * delta_h2 * x2;
        b.h(2)    = b.h(2)    - lr * delta_h2;

        % Pricti chybu tohoto vzoru do celkove MSE
        mse = mse + (y - t)^2;
    end

    % Prumer MSE pres vsechny 4 vzory
    mse = mse / 4;
    mse_history(epoch) = mse;

    % Kazdych 1000 epoch vypis stav uceni
    if mod(epoch, 1000) == 0
        fprintf('Epocha %5d | MSE = %.6f\n', epoch, mse);
    end

    % Zastav uceni pokud jsme dosahli cilove chyby
    if mse < cil_chyba
        fprintf('Sit se naucila v epoche %d (MSE = %.6f)\n', epoch, mse);
        break;
    end
end