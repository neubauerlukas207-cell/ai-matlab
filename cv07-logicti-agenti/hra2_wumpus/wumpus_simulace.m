function wumpus_simulace()
% wumpus_simulace - spusti celou simulaci: hrac (GUI) + agent + porovnani
% Tento skript je ekvivalent wumpus_hra.m ale s plnym logem a PNG vystupy
% Spusteni: wumpus_simulace()

clc;
close all;
rng('shuffle');

diary('wumpus_simulace_vystup.txt');
diary on;

N    = 5;
svet = init_wumpus_world(N);
zadani = svet;

fprintf('=== WUMPUS WORLD SIMULACE ===\n');
fprintf('Wumpus na: [%d,%d]\n', svet.wumpus_pozice(1), svet.wumpus_pozice(2));
fprintf('Zlato na:  [%d,%d]\n', svet.zlato_pozice(1),  svet.zlato_pozice(2));
fprintf('Jamy: ');
[jr, jc] = find(svet.jamy);
for k = 1:numel(jr)
    fprintf('[%d,%d] ', jr(k), jc(k));
end
fprintf('\n\n');

% =========================================================
% FAZE 1 - HRAC
% =========================================================
fprintf('=== FAZE HRACE ===\n');

kb_hrac         = init_kb(N);
kroky_hrac      = 0;
vysledek_hrac   = 'Nedokonceno';
navstiveno_hrac = false(N);

figure('Name', 'Wumpus simulace - hrac');
vykresli_agenta_sim(svet, kb_hrac, init_percept(), N, true);
exportgraphics(gca, 'wumpus_sim_hrac_start.png');

t0 = tic;

while true
    pos = svet.agent_pozice;
    navstiveno_hrac(pos(1), pos(2)) = true;

    percept = vnimej(svet, pos);
    kb_hrac = aktualizuj_kb(kb_hrac, pos, percept);

    vykresli_agenta_sim(svet, kb_hrac, percept, N, true);
    fprintf('Krok %d: Pozice [%d,%d], smer %s\n', kroky_hrac+1, pos(1), pos(2), svet.agent_smer);
    fprintf('  Percept: zapach=%d, vanek=%d, lesk=%d\n', percept.zapach, percept.vanek, percept.lesk);
    fprintf('  KB: bezpecna=%d poli, mozny_wumpus=%d poli\n', nnz(kb_hrac.bezpecna), nnz(kb_hrac.mozny_wumpus));

    if svet.jamy(pos(1), pos(2))
        vysledek_hrac = 'Padl do jamy';
        break;
    end
    if isequal(pos, svet.wumpus_pozice) && svet.wumpus_ziv
        vysledek_hrac = 'Sezral ho Wumpus';
        break;
    end
    if svet.zlato_vzato && isequal(pos, [1 1])
        vysledek_hrac = 'Vyhra';
        break;
    end
    if kroky_hrac >= 200
        vysledek_hrac = 'Limit kroku';
        break;
    end

    w = waitforbuttonpress;
    if w ~= 1, continue; end
    key = lower(get(gcf, 'CurrentCharacter'));

    switch key
        case 'q', vysledek_hrac = 'Ukonceno'; break;
        case 'g'
            if isequal(pos, svet.zlato_pozice) && ~svet.zlato_vzato
                svet.zlato_vzato = true;
                fprintf('  HRAC: sebral zlato!\n');
            end
            kroky_hrac = kroky_hrac + 1;
        case 'w'
            if pos(1)-1 >= 1, svet.agent_pozice = pos + [-1 0]; end
            kroky_hrac = kroky_hrac + 1;
        case 's'
            if pos(1)+1 <= N, svet.agent_pozice = pos + [1 0]; end
            kroky_hrac = kroky_hrac + 1;
        case 'a'
            if pos(2)-1 >= 1, svet.agent_pozice = pos + [0 -1]; end
            kroky_hrac = kroky_hrac + 1;
        case 'd'
            if pos(2)+1 <= N, svet.agent_pozice = pos + [0 1]; end
            kroky_hrac = kroky_hrac + 1;
    end
end

cas_hrac = toc(t0);
exportgraphics(gca, 'wumpus_sim_hrac_konec.png');

% =========================================================
% FAZE 2 - AGENT
% =========================================================
fprintf('\n=== FAZE AGENTA ===\n');

svet             = zadani;
kb_agent         = init_kb(N);
kroky_agent      = 0;
vysledek_agent   = 'Nedokonceno';
navstiveno_agent = false(N);

figure('Name', 'Wumpus simulace - agent');
vykresli_agenta_sim(svet, kb_agent, init_percept(), N, false);
exportgraphics(gca, 'wumpus_sim_agent_start.png');

t1 = tic;
max_kroku = 4 * N * N;

while true
    pos = svet.agent_pozice;
    navstiveno_agent(pos(1), pos(2)) = true;

    percept  = vnimej(svet, pos);
    kb_agent = aktualizuj_kb(kb_agent, pos, percept);

    vykresli_agenta_sim(svet, kb_agent, percept, N, false);
    fprintf('Krok %d: Pozice [%d,%d]\n', kroky_agent+1, pos(1), pos(2));
    fprintf('  Percept: zapach=%d, vanek=%d, lesk=%d\n', percept.zapach, percept.vanek, percept.lesk);
    fprintf('  KB: bezpecna=%d poli, mozny_wumpus=%d, mozna_jama=%d\n', ...
        nnz(kb_agent.bezpecna), nnz(kb_agent.mozny_wumpus), nnz(kb_agent.mozna_jama));

    if svet.jamy(pos(1), pos(2))
        vysledek_agent = 'Padl do jamy';
        fprintf('  AGENT: padl do jamy!\n');
        break;
    end
    if isequal(pos, svet.wumpus_pozice) && svet.wumpus_ziv
        vysledek_agent = 'Sezral ho Wumpus';
        fprintf('  AGENT: sezral ho Wumpus!\n');
        break;
    end
    if svet.zlato_vzato && isequal(pos, [1 1])
        vysledek_agent = 'Vyhra';
        fprintf('  AGENT: vyhra!\n');
        break;
    end
    if kroky_agent >= max_kroku
        vysledek_agent = 'Limit kroku';
        break;
    end

    akce = naplanov_akci(svet, kb_agent, percept);
    fprintf('  Akce: ');

    if strcmp(akce, 'VZIT_ZLATO')
        fprintf('VZIT_ZLATO\n');
        svet.zlato_vzato = true;
        kroky_agent = kroky_agent + 1;
        pause(0.4);

    elseif strcmp(akce, 'KONEC')
        fprintf('KONEC\n');
        vysledek_agent = 'Zasekl se';
        break;

    elseif iscell(akce) && ~isempty(akce)
        fprintf('%s\n', akce{1});
        switch akce{1}
            case 'NAHORU',  svet.agent_pozice = svet.agent_pozice + [-1  0];
            case 'DOLU',    svet.agent_pozice = svet.agent_pozice + [ 1  0];
            case 'DOLEVA',  svet.agent_pozice = svet.agent_pozice + [ 0 -1];
            case 'DOPRAVA', svet.agent_pozice = svet.agent_pozice + [ 0  1];
        end
        kroky_agent = kroky_agent + 1;
        vykresli_agenta_sim(svet, kb_agent, vnimej(svet, svet.agent_pozice), N, false);
        pause(0.35);
    else
        vysledek_agent = 'Zasekl se';
        break;
    end
end

cas_agent = toc(t1);
exportgraphics(gca, 'wumpus_sim_agent_konec.png');

% =========================================================
% FAZE 3 - POROVNANI
% =========================================================
fprintf('\n============================================\n');
fprintf('     POROVNANI: HRAC vs. AGENT\n');
fprintf('============================================\n');
fprintf('                    | %-20s | %-20s |\n', 'Hrac', 'Agent');
fprintf('--------------------------------------------\n');
fprintf('| %-18s | %-20d | %-20d |\n', 'Pocet kroku',      kroky_hrac,           kroky_agent);
fprintf('| %-18s | %-20.2f | %-20.2f |\n', 'Cas (s)',      cas_hrac,             cas_agent);
fprintf('| %-18s | %-20s | %-20s |\n', 'Vysledek',         vysledek_hrac,        vysledek_agent);
fprintf('| %-18s | %-20d | %-20d |\n', 'Prozkoumano poli', nnz(navstiveno_hrac), nnz(navstiveno_agent));
fprintf('============================================\n');

diary off;
end

% ===== pomocne funkce =====

function kb = init_kb(N)
kb.navstivena   = false(N);
kb.bezpecna     = false(N);
kb.mozna_jama   = false(N);
kb.mozny_wumpus = false(N);
kb.bezpecna(1, 1) = true;
end

function p = init_percept()
p.zapach = false;
p.vanek  = false;
p.lesk   = false;
p.naraz  = false;
end

function vykresli_agenta_sim(svet, kb, percept, N, je_hrac)
% vykresli stav hrace nebo agenta
A = 0.15 * ones(N);
A(kb.bezpecna)   = 0.55;
A(kb.navstivena) = 0.95;

imagesc(A);
colormap(parula);
axis equal tight;
set(gca, 'XTick', 1:N, 'YTick', 1:N);
grid on;
hold on;

for i = 1:N
    for j = 1:N
        if kb.navstivena(i, j)
            rectangle('Position', [j-0.5 i-0.5 1 1], 'EdgeColor', 'g', 'LineWidth', 2);
        end
        if ~je_hrac
            if kb.mozna_jama(i, j) && ~kb.navstivena(i, j)
                text(j, i+0.25, 'J?', 'Color', 'r', ...
                    'HorizontalAlignment', 'center', 'FontSize', 8);
            end
            if kb.mozny_wumpus(i, j) && ~kb.navstivena(i, j)
                text(j, i-0.25, 'W?', 'Color', [1 0.4 0], ...
                    'HorizontalAlignment', 'center', 'FontSize', 8);
            end
        end
    end
end

text(svet.agent_pozice(2), svet.agent_pozice(1), 'A', ...
    'Color', 'k', 'HorizontalAlignment', 'center', ...
    'FontWeight', 'bold', 'FontSize', 18);

if je_hrac
    title(sprintf('HRAC | zapach=%d vanek=%d lesk=%d | W/A/S/D | G zlato | Q konec', ...
        percept.zapach, percept.vanek, percept.lesk));
else
    title(sprintf('AGENT | zapach=%d vanek=%d lesk=%d', ...
        percept.zapach, percept.vanek, percept.lesk));
end
hold off;
drawnow;
end