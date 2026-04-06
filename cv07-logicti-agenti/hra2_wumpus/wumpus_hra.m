function wumpus_hra()
% wumpus_hra - spusti Wumpus World pro hrace, pak agenta, nakonec porovnani
% Spusteni: wumpus_hra()

clc;
close all;
rng('shuffle');

diary('wumpus_vystup.txt');
diary on;

N    = 5;
svet = init_wumpus_world(N);
zadani = svet;                       % uloz kopii pro agenta

% =========================================================
% FAZE 1 - HRAC
% =========================================================
fprintf('=== FAZE HRACE ===\n');

kb_hrac      = init_kb(N);
kroky_hrac   = 0;
vysledek_hrac = 'Nedokonceno';
navstiveno_hrac = false(N);

fig_hrac = figure('Name', 'Wumpus - hrac');
t0 = tic;

while true
    pos = svet.agent_pozice;
    navstiveno_hrac(pos(1), pos(2)) = true;

    percept   = vnimej(svet, pos);
    kb_hrac   = aktualizuj_kb(kb_hrac, pos, percept);

    vykresli_hrace(svet, kb_hrac, percept, N);
    fprintf('HRAC: pozice=[%d,%d] | zapach=%d vanek=%d lesk=%d\n', ...
        pos(1), pos(2), percept.zapach, percept.vanek, percept.lesk);

    % kontrola padu do jamy
    if svet.jamy(pos(1), pos(2))
        vysledek_hrac = 'Padl do jamy';
        fprintf('HRAC: padl do jamy!\n');
        break;
    end

    % kontrola Wumpuse
    if isequal(pos, svet.wumpus_pozice) && svet.wumpus_ziv
        vysledek_hrac = 'Sezral ho Wumpus';
        fprintf('HRAC: sezral ho Wumpus!\n');
        break;
    end

    % kontrola vyhry
    if svet.zlato_vzato && isequal(pos, [1 1])
        vysledek_hrac = 'Vyhra';
        fprintf('HRAC: vyhra - zlato doneseno na start!\n');
        break;
    end

    % limit kroku
    if kroky_hrac >= 200
        vysledek_hrac = 'Limit kroku';
        break;
    end

    % cekej na klavesu
    w = waitforbuttonpress;
    if w ~= 1, continue; end
    key = lower(get(gcf, 'CurrentCharacter'));

    switch key
        case 'q'
            vysledek_hrac = 'Ukonceno';
            break;

        case 'g'
            if isequal(pos, svet.zlato_pozice) && ~svet.zlato_vzato
                svet.zlato_vzato = true;
                fprintf('HRAC: sebral zlato!\n');
            end
            kroky_hrac = kroky_hrac + 1;

        case 'w'
            nove = pos + [-1 0];
            if nove(1) >= 1
                svet.agent_pozice = nove;
            end
            kroky_hrac = kroky_hrac + 1;

        case 's'
            nove = pos + [1 0];
            if nove(1) <= N
                svet.agent_pozice = nove;
            end
            kroky_hrac = kroky_hrac + 1;

        case 'a'
            nove = pos + [0 -1];
            if nove(2) >= 1
                svet.agent_pozice = nove;
            end
            kroky_hrac = kroky_hrac + 1;

        case 'd'
            nove = pos + [0 1];
            if nove(2) <= N
                svet.agent_pozice = nove;
            end
            kroky_hrac = kroky_hrac + 1;
    end
end

cas_hrac = toc(t0);
drawnow;
exportgraphics(gca, 'wumpus_hrac.png');

% =========================================================
% FAZE 2 - AGENT
% =========================================================
fprintf('\n=== FAZE AGENTA ===\n');

svet         = zadani;               % obnov puvodni svet
kb_agent     = init_kb(N);
kroky_agent  = 0;
vysledek_agent = 'Nedokonceno';
navstiveno_agent = false(N);

figure('Name', 'Wumpus - agent');
t1 = tic;

max_kroku = 4 * N * N;               % bezpecnostni limit

while true
    pos = svet.agent_pozice;
    navstiveno_agent(pos(1), pos(2)) = true;

    percept  = vnimej(svet, pos);
    kb_agent = aktualizuj_kb(kb_agent, pos, percept);

    vykresli_agenta(svet, kb_agent, percept, N);
    fprintf('AGENT: pozice=[%d,%d] | zapach=%d vanek=%d lesk=%d\n', ...
        pos(1), pos(2), percept.zapach, percept.vanek, percept.lesk);

    % kontrola padu do jamy
    if svet.jamy(pos(1), pos(2))
        vysledek_agent = 'Padl do jamy';
        fprintf('AGENT: padl do jamy!\n');
        break;
    end

    % kontrola Wumpuse
    if isequal(pos, svet.wumpus_pozice) && svet.wumpus_ziv
        vysledek_agent = 'Sezral ho Wumpus';
        fprintf('AGENT: sezral ho Wumpus!\n');
        break;
    end

    % kontrola vyhry
    if svet.zlato_vzato && isequal(pos, [1 1])
        vysledek_agent = 'Vyhra';
        fprintf('AGENT: vyhra!\n');
        break;
    end

    if kroky_agent >= max_kroku
        vysledek_agent = 'Limit kroku';
        break;
    end

    % naplanovani akce
    akce = naplanov_akci(svet, kb_agent, percept);

    if strcmp(akce, 'VZIT_ZLATO')
        svet.zlato_vzato = true;
        kroky_agent = kroky_agent + 1;
        fprintf('AGENT: sebral zlato!\n');
        pause(0.3);

    elseif strcmp(akce, 'KONEC')
        vysledek_agent = 'Zasekl se';
        fprintf('AGENT: zasekl se - zadny bezpecny tah.\n');
        break;

    elseif iscell(akce) && ~isempty(akce)
        % proveď jeden krok z cesty
        switch akce{1}
            case 'NAHORU',  svet.agent_pozice = svet.agent_pozice + [-1  0];
            case 'DOLU',    svet.agent_pozice = svet.agent_pozice + [ 1  0];
            case 'DOLEVA',  svet.agent_pozice = svet.agent_pozice + [ 0 -1];
            case 'DOPRAVA', svet.agent_pozice = svet.agent_pozice + [ 0  1];
        end
        kroky_agent = kroky_agent + 1;

        vykresli_agenta(svet, kb_agent, vnimej(svet, svet.agent_pozice), N);
        pause(0.25);

    else
        vysledek_agent = 'Zasekl se';
        break;
    end
end

cas_agent = toc(t1);
drawnow;
exportgraphics(gca, 'wumpus_agent.png');

% =========================================================
% FAZE 3 - POROVNANI
% =========================================================
fprintf('\n===============================================================\n');
fprintf('     POROVNANI: HRAC vs. AGENT\n');
fprintf('===============================================================\n');
fprintf('| %-18s | %-20s | %-20s |\n', '', 'Hrac', 'Agent');
fprintf('---------------------------------------------------------------\n');
fprintf('| %-18s | %-20d | %-20d |\n', 'Pocet kroku',      kroky_hrac,             kroky_agent);
fprintf('| %-18s | %-20.2f | %-20.2f |\n', 'Cas (s)',      cas_hrac,               cas_agent);
fprintf('| %-18s | %-20s | %-20s |\n', 'Vysledek',         vysledek_hrac,          vysledek_agent);
fprintf('| %-18s | %-20d | %-20d |\n', 'Prozkoumano poli', nnz(navstiveno_hrac),   nnz(navstiveno_agent));
fprintf('===============================================================\n');

diary off;
end

% ===== pomocne funkce =====

function kb = init_kb(N)
% init_kb - inicializuje prazdnou knowledge base
kb.navstivena   = false(N);
kb.bezpecna     = false(N);
kb.mozna_jama   = false(N);
kb.mozny_wumpus = false(N);
kb.bezpecna(1, 1) = true;           % start je vzdy bezpecny
end

function vykresli_hrace(svet, kb, percept, N)
% vykresli_hrace - zobrazi stav hrace (viditelna jen navstivena a bezpecna pole)
A = 0.2 * ones(N);                  % neznama pole - tmava
A(kb.bezpecna)  = 0.65;             % bezpecna - seda
A(kb.navstivena) = 1.0;             % navstivena - bila

imagesc(A);
colormap(parula);
axis equal tight;
set(gca, 'XTick', 1:N, 'YTick', 1:N);
grid on;
hold on;

text(svet.agent_pozice(2), svet.agent_pozice(1), 'A', ...
    'Color', 'k', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 16);

title(sprintf('HRAC | zapach=%d vanek=%d lesk=%d | W/A/S/D pohyb | G zlato | Q konec', ...
    percept.zapach, percept.vanek, percept.lesk));
hold off;
drawnow;
end

function vykresli_agenta(svet, kb, percept, N)
% vykresli_agenta - zobrazi stav agenta s KB vrstvami
A = 0.2 * ones(N);
A(kb.bezpecna)   = 0.65;
A(kb.navstivena) = 1.0;

imagesc(A);
colormap(parula);
axis equal tight;
set(gca, 'XTick', 1:N, 'YTick', 1:N);
grid on;
hold on;

% navstivena pole - zeleny ramecek
for i = 1:N
    for j = 1:N
        if kb.navstivena(i, j)
            rectangle('Position', [j-0.5 i-0.5 1 1], ...
                'EdgeColor', 'g', 'LineWidth', 2);
        end
        if kb.mozna_jama(i, j)
            text(j, i, 'J?', 'Color', 'r', ...
                'HorizontalAlignment', 'center', 'FontSize', 9);
        end
        if kb.mozny_wumpus(i, j)
            text(j, i, 'W?', 'Color', [1 0.5 0], ...
                'HorizontalAlignment', 'center', 'FontSize', 9);
        end
    end
end

text(svet.agent_pozice(2), svet.agent_pozice(1), 'A', ...
    'Color', 'k', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 16);

title(sprintf('AGENT | zapach=%d vanek=%d lesk=%d', ...
    percept.zapach, percept.vanek, percept.lesk));
hold off;
drawnow;
end