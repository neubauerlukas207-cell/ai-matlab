clc;
clear;

fprintf('============================================\n');
fprintf('CV06 - Porovnani Minimax vs MCTS\n');
fprintf('============================================\n');

simulace_list = [100, 500, 1000, 5000];
pocet_her_celkem = 50;

fprintf('\nMCTS simulace | Vyhry MCTS | Remizy | Prohry MCTS | Cas/tah [s]\n');
fprintf('--------------|------------|--------|-------------|------------\n');

for sim = simulace_list
    vyhry_mcts = 0;
    remizy = 0;
    prohry_mcts = 0;

    casy_tahu = [];
    pocet_tahu_mcts = 0;

    % 25 her: Minimax = X, MCTS = O
    for i = 1:(pocet_her_celkem / 2)
        [vysledek, casy] = odehraj_hru_auto('minimax', 'mcts', sim);

        if vysledek == 2
            vyhry_mcts = vyhry_mcts + 1;
        elseif vysledek == 0
            remizy = remizy + 1;
        else
            prohry_mcts = prohry_mcts + 1;
        end

        casy_tahu = [casy_tahu, casy]; %#ok<AGROW>
        pocet_tahu_mcts = pocet_tahu_mcts + numel(casy);
    end

    % 25 her: MCTS = X, Minimax = O
    for i = 1:(pocet_her_celkem / 2)
        [vysledek, casy] = odehraj_hru_auto('mcts', 'minimax', sim);

        if vysledek == 1
            vyhry_mcts = vyhry_mcts + 1;
        elseif vysledek == 0
            remizy = remizy + 1;
        else
            prohry_mcts = prohry_mcts + 1;
        end

        casy_tahu = [casy_tahu, casy]; %#ok<AGROW>
        pocet_tahu_mcts = pocet_tahu_mcts + numel(casy);
    end

    if pocet_tahu_mcts > 0
        prum_cas = mean(casy_tahu);
    else
        prum_cas = 0;
    end

    fprintf('%12d | %10d | %6d | %11d | %10.4f\n', ...
        sim, vyhry_mcts, remizy, prohry_mcts, prum_cas);
end

fprintf('\n============================================\n');
fprintf('Bonus porovnani agentu\n');
fprintf('============================================\n');

pocet_bonus_her = 100;

[vx1, rr1, vo1] = porovnej_dvojici('minimax', 'rule', 0, pocet_bonus_her);
[vx2, rr2, vo2] = porovnej_dvojici('mcts', 'rule', 1000, pocet_bonus_her);
[vx3, rr3, vo3] = porovnej_dvojici('minimax', 'mcts', 1000, pocet_bonus_her);

fprintf('\nAgent X vs Agent O       | Vyhry X | Remizy | Vyhry O\n');
fprintf('-------------------------|---------|--------|--------\n');
fprintf('Minimax vs Rule-based    | %7d | %6d | %6d\n', vx1, rr1, vo1);
fprintf('MCTS vs Rule-based       | %7d | %6d | %6d\n', vx2, rr2, vo2);
fprintf('Minimax vs MCTS          | %7d | %6d | %6d\n', vx3, rr3, vo3);


function [vysledek, casy_mcts] = odehraj_hru_auto(agentX, agentO, simulace_mcts)
    deska = piskvorky_hra.inicializuj_desku();
    aktualni = 1;
    casy_mcts = [];

    while ~piskvorky_hra.je_konec(deska)
        if aktualni == 1
            if strcmp(agentX, 'minimax')
                [r, s] = minimax_agent.nejlepsi_tah(deska, 1, 2, true);
            elseif strcmp(agentX, 'mcts')
                tic;
                [r, s] = mcts_agent.mcts_tah(deska, simulace_mcts, 1, 2);
                casy_mcts(end + 1) = toc; %#ok<AGROW>
            else
                [r, s] = rule_based_tah(deska, 1, 2);
            end
            deska = piskvorky_hra.proved_tah(deska, r, s, 1);
            aktualni = 2;
        else
            if strcmp(agentO, 'minimax')
                [r, s] = minimax_agent.nejlepsi_tah(deska, 2, 1, true);
            elseif strcmp(agentO, 'mcts')
                tic;
                [r, s] = mcts_agent.mcts_tah(deska, simulace_mcts, 2, 1);
                casy_mcts(end + 1) = toc; %#ok<AGROW>
            else
                [r, s] = rule_based_tah(deska, 2, 1);
            end
            deska = piskvorky_hra.proved_tah(deska, r, s, 2);
            aktualni = 1;
        end
    end

    if piskvorky_hra.je_vitez(deska, 1)
        vysledek = 1;
    elseif piskvorky_hra.je_vitez(deska, 2)
        vysledek = 2;
    else
        vysledek = 0;
    end
end


function [vyhryX, remizy, vyhryO] = porovnej_dvojici(agentX, agentO, simulace_mcts, pocet_her)
    vyhryX = 0;
    remizy = 0;
    vyhryO = 0;

    for i = 1:pocet_her
        [vysledek, ~] = odehraj_hru_auto(agentX, agentO, simulace_mcts);

        if vysledek == 1
            vyhryX = vyhryX + 1;
        elseif vysledek == 2
            vyhryO = vyhryO + 1;
        else
            remizy = remizy + 1;
        end
    end
end


function [r, s] = rule_based_tah(deska, muj_hrac, souper_hrac)
    volne = piskvorky_hra.volne_pozice(deska);

    % 1) Pokud mohu vyhrat jednim tahem, zahraj vitezny tah
    for i = 1:size(volne, 1)
        rr = volne(i, 1);
        ss = volne(i, 2);
        test = piskvorky_hra.proved_tah(deska, rr, ss, muj_hrac);
        if piskvorky_hra.je_vitez(test, muj_hrac)
            r = rr; s = ss; return;
        end
    end

    % 2) Pokud souper muze vyhrat jednim tahem, zablokuj ho
    for i = 1:size(volne, 1)
        rr = volne(i, 1);
        ss = volne(i, 2);
        test = piskvorky_hra.proved_tah(deska, rr, ss, souper_hrac);
        if piskvorky_hra.je_vitez(test, souper_hrac)
            r = rr; s = ss; return;
        end
    end

    % 3) Pokud je stred volny, zahraj na stred
    if deska(2, 2) == 0
        r = 2; s = 2; return;
    end

    % 4) Pokud je volny roh, zahraj do rohu
    rohy = [1 1; 1 3; 3 1; 3 3];
    for i = 1:size(rohy, 1)
        rr = rohy(i, 1);
        ss = rohy(i, 2);
        if deska(rr, ss) == 0
            r = rr; s = ss; return;
        end
    end

    % 5) Jinak zahraj na libovolne volne pole
    r = volne(1, 1);
    s = volne(1, 2);
end