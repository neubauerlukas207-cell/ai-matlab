clc; clear; close all;

% Zadání:
N = 10;
procento = 0.40;
max_pohyb_dopredu = 200;

% Svět
svet = svet_vysavace(N, procento);

% Agent: náhodná pozice a směr
agent.x = randi(N);
agent.y = randi(N);
smery = {'S','V','J','Z'};
agent.smer = smery{randi(4)};

% Statistiky běhu
dopredu_kroky = 0;
otocky = 0;
vysati = 0;

stav_agenta = [];

% Pomocná funkce na spočítání špíny
spina = @(mapa) sum(mapa(:));

pocatecni_dirty = spina(svet.mapa);

% Hlavní smyčka: konec když je čisto nebo max 200 kroků dopředu
while spina(svet.mapa) > 0 && dopredu_kroky < max_pohyb_dopredu

    % Percepce (jen smetí + stěna)
    percepce.vidim_smeti = (svet.mapa(agent.x, agent.y) == 1);
    percepce.vidim_stenu = je_stena_pred(agent, N);

    % Agent rozhodne akci
    [akce, stav_agenta] = muj_agent(percepce, stav_agenta);

    % Proveď akci
    switch akce
        case 'VYSAJ'
            if svet.mapa(agent.x, agent.y) == 1
                svet.mapa(agent.x, agent.y) = 0; % vysaj přímo
                vysati = vysati + 1;
            end

        case 'OTOC_VPRAVO'
            agent.smer = otoc(agent.smer, +1);
            otocky = otocky + 1;

        case 'OTOC_VLEVO'
            agent.smer = otoc(agent.smer, -1);
            otocky = otocky + 1;

        case 'POHNI_SE'
            if ~je_stena_pred(agent, N)
                [agent.x, agent.y] = krok_vpred(agent);
                dopredu_kroky = dopredu_kroky + 1;
            else
                % pojistka: kdyby chtěl jít do zdi
                agent.smer = otoc(agent.smer, +1);
                otocky = otocky + 1;
            end
    end
end

% Výsledky
final_dirty = spina(svet.mapa);
vycisteno = pocatecni_dirty - final_dirty;

total = N*N;
percent_clean = 100 * (total - final_dirty) / total;

eff = vysati / max(1, (dopredu_kroky + otocky));

fprintf('--- VYSLEDKY ---\n');
fprintf('Svet: %dx%d, smeti: %.0f %%\n', N, N, procento*100);
fprintf('Pocatecne spinave: %d\n', pocatecni_dirty);
fprintf('Vycisteno: %d\n', vycisteno);
fprintf('Cistota: %.1f %%\n', percent_clean);
fprintf('Kroky dopredu: %d (limit %d)\n', dopredu_kroky, max_pohyb_dopredu);
fprintf('Otocky: %d\n', otocky);
fprintf('Vysati: %d\n', vysati);
fprintf('Efektivita (vysati/(dopredu+otocky)): %.3f\n', eff);

% Vizualizace mapy
figure;
imagesc(svet.mapa);
axis equal tight;
title('Finalni mapa (1 = smeti, 0 = cisto)');
hold on;
plot(agent.y, agent.x, 'rx', 'MarkerSize', 12, 'LineWidth', 2);
hold off;

% Vyhodnoceni do souboru (zadání chce vyhodnoceni.txt)
fid = fopen('vyhodnoceni.txt', 'w');
fprintf(fid, 'Vyhodnoceni simulace agenta-vysavace\n\n');
fprintf(fid, 'Parametry:\n');
fprintf(fid, '- Svet: %dx%d\n', N, N);
fprintf(fid, '- Pocatecni znecisteni: %.0f %%\n', procento*100);
fprintf(fid, '- Ukonceni: cisto nebo max %d pohybu dopredu\n\n', max_pohyb_dopredu);

fprintf(fid, 'Vysledky:\n');
fprintf(fid, '- Cistota: %.1f %%\n', percent_clean);
fprintf(fid, '- Kroky dopredu: %d\n', dopredu_kroky);
fprintf(fid, '- Otocky: %d\n', otocky);
fprintf(fid, '- Pocet vysati: %d\n', vysati);
fprintf(fid, '- Efektivita (vysati/(dopredu+otocky)): %.3f\n\n', eff);

fprintf(fid, 'Komentar:\n');
fprintf(fid, '- Agent je reaktivni: vysaje pri nalezeni smeti, na stenu reaguje otacenim.\n');
fprintf(fid, '- Ma jednoduchou pamet (anti-loop) proti toceni v rozich.\n');
fprintf(fid, '- Slabina: nema mapu sveta, muze se vratit na stejna mista.\n');
fclose(fid);

% --- Lokální pomocné funkce ---
function wall = je_stena_pred(agent, N)
switch agent.smer
    case 'S', wall = (agent.x == 1);
    case 'J', wall = (agent.x == N);
    case 'V', wall = (agent.y == N);
    case 'Z', wall = (agent.y == 1);
end
end

function [nx, ny] = krok_vpred(agent)
nx = agent.x; ny = agent.y;
switch agent.smer
    case 'S', nx = nx - 1;
    case 'J', nx = nx + 1;
    case 'V', ny = ny + 1;
    case 'Z', ny = ny - 1;
end
end

function smer2 = otoc(smer, dir)
poradi = {'S','V','J','Z'};
idx = find(strcmp(poradi, smer), 1);
idx2 = idx + dir;
if idx2 < 1, idx2 = 4; end
if idx2 > 4, idx2 = 1; end
smer2 = poradi{idx2};
end