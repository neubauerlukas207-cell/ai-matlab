function miny_hra()
% miny_hra - spusti hru Miny v rezimu hrace, pak agenta, nakonec porovnani
% Spusteni: miny_hra()

clc;
close all;
rng('shuffle');

diary('vystup.txt');
diary on;

% =========================================================
% FAZE 1 - HRAC
% =========================================================
fprintf('=== FAZE HRACE ===\n');

miny = generuj_miny(9, 9, 10);
zadani = miny;

figure('Name', 'Miny - hrac');
vizualizuj_miny(miny, false);
title('Miny - hrac - zacatek');
drawnow;
uloz_obrazek('screenshot_zacatek.png');

tahy_hrac = 0;
flood_hrac = 0;
vysledek_hrac = 0;
ulozen_prubeh = false;

t0 = tic;

while vysledek_hrac == 0
    [x, y, button] = ginput(1);

    if isempty(x)
        break;
    end

    j = round(x);
    i = round(y);

    if i < 1 || i > miny.N || j < 1 || j > miny.M
        continue;
    end

    if button == 1
        [miny, vysledek_hrac, f] = odkryj_pole(miny, i, j);
        tahy_hrac = tahy_hrac + 1;
        flood_hrac = flood_hrac + f;

        if miny.pole(i, j) == -1
            fprintf('Tah %d: odkryta mina na [%d,%d]\n', tahy_hrac, i, j);
        else
            fprintf('Tah %d: odkryto [%d,%d], hodnota=%d\n', tahy_hrac, i, j, miny.pole(i, j));
        end

    elseif button == 3
        if ~miny.odkryto(i, j)
            miny.vlajky(i, j) = ~miny.vlajky(i, j);
            tahy_hrac = tahy_hrac + 1;
            fprintf('Tah %d: prepnuta vlajka na [%d,%d]\n', tahy_hrac, i, j);
        end
    end

    vizualizuj_miny(miny, vysledek_hrac == -1);
    title('Miny - hrac - prubeh');
    drawnow;

    if tahy_hrac >= 3 && ~ulozen_prubeh
        uloz_obrazek('screenshot_prubeh.png');
        ulozen_prubeh = true;
    end
end

cas_hrac = toc(t0);

if ~ulozen_prubeh
    uloz_obrazek('screenshot_prubeh.png');
end

vizualizuj_miny(miny, true);
title('Miny - hrac - konec');
drawnow;
uloz_obrazek('screenshot_konec.png');

if vysledek_hrac == 1
    text_hrac = 'Vyhra';
elseif vysledek_hrac == -1
    text_hrac = 'Prohra';
else
    text_hrac = 'Nedokonceno';
end

spravne_vlajky_hrac = sum(sum(miny.vlajky & (zadani.pole == -1)));
vsechny_miny = sum(sum(zadani.pole == -1));

% =========================================================
% FAZE 2 - AGENT
% =========================================================
fprintf('\n=== FAZE AGENTA ===\n');

minyA = zadani;
tahy_agent = 0;
flood_agent = 0;
vysledek_agent = 0;

figure('Name', 'Miny - agent');
vizualizuj_miny(minyA, false);
title('Miny - agent - zacatek');
drawnow;
pause(0.5);

t1 = tic;

% prvni tah - nahodny start
kandidati = find(~minyA.odkryto & ~minyA.vlajky);
p = kandidati(randi(numel(kandidati)));
[r0, s0] = ind2sub([minyA.N minyA.M], p);

[minyA, vysledek_agent, f] = odkryj_pole(minyA, r0, s0);
tahy_agent = tahy_agent + 1;
flood_agent = flood_agent + f;
fprintf('Agent tah %d: nahodny start [%d,%d]\n', tahy_agent, r0, s0);

vizualizuj_miny(minyA, vysledek_agent == -1);
title(sprintf('Miny - agent - tah %d', tahy_agent));
drawnow;
pause(0.3);

% hlavni smycka
while vysledek_agent == 0
    [bezpecna, miny_nalezene] = miny_agent(minyA);

    % oznaceni min vlajkami
    for k = 1:size(miny_nalezene, 1)
        r = miny_nalezene(k, 1);
        s = miny_nalezene(k, 2);
        if ~minyA.odkryto(r, s) && ~minyA.vlajky(r, s)
            minyA.vlajky(r, s) = true;
            fprintf('Agent: oznacena mina [%d,%d]\n', r, s);
        end
    end

    vizualizuj_miny(minyA, false);
    title(sprintf('Miny - agent - analyza po tahu %d', tahy_agent));
    drawnow;
    pause(0.2);

    provedl_tah = false;

    % odkryj vsechna jiste bezpecna pole
    for k = 1:size(bezpecna, 1)
        r = bezpecna(k, 1);
        s = bezpecna(k, 2);

        if ~minyA.odkryto(r, s) && ~minyA.vlajky(r, s)
            [minyA, vysledek_agent, f] = odkryj_pole(minyA, r, s);
            tahy_agent = tahy_agent + 1;
            flood_agent = flood_agent + f;
            provedl_tah = true;

            fprintf('Agent tah %d: bezpecne [%d,%d]\n', tahy_agent, r, s);

            vizualizuj_miny(minyA, vysledek_agent == -1);
            title(sprintf('Miny - agent - tah %d', tahy_agent));
            drawnow;
            pause(0.25);

            if vysledek_agent ~= 0
                break;
            end
        end
    end

    if vysledek_agent ~= 0
        break;
    end

    % kdyz nema jistotu, hraje nahodne
    if ~provedl_tah
        kandidati2 = find(~minyA.odkryto & ~minyA.vlajky);
        if isempty(kandidati2)
            break;
        end

        p2 = kandidati2(randi(numel(kandidati2)));
        [r2, s2] = ind2sub([minyA.N minyA.M], p2);

        [minyA, vysledek_agent, f] = odkryj_pole(minyA, r2, s2);
        tahy_agent = tahy_agent + 1;
        flood_agent = flood_agent + f;

        fprintf('Agent tah %d: nahodny tah [%d,%d]\n', tahy_agent, r2, s2);

        vizualizuj_miny(minyA, vysledek_agent == -1);
        title(sprintf('Miny - agent - tah %d', tahy_agent));
        drawnow;
        pause(0.3);
    end
end

cas_agent = toc(t1);

vizualizuj_miny(minyA, true);
title('Miny - agent - konec');
drawnow;
uloz_obrazek('agent_konec.png');

if vysledek_agent == 1
    text_agent = 'Vyhra';
elseif vysledek_agent == -1
    text_agent = 'Prohra';
else
    text_agent = 'Nedokonceno';
end

spravne_vlajky_agent = sum(sum(minyA.vlajky & (zadani.pole == -1)));

% =========================================================
% FAZE 3 - POROVNANI
% =========================================================
fprintf('\n============================================\n');
fprintf('     POROVNANI: HRAC vs. AGENT\n');
fprintf('============================================\n');
fprintf('                  | Hrac   | Agent\n');
fprintf('--------------------------------------------\n');
fprintf('Pocet tahu        | %6d | %6d\n', tahy_hrac, tahy_agent);
fprintf('Cas (s)           | %6.2f | %6.2f\n', cas_hrac, cas_agent);
fprintf('Vysledek          | %6s | %6s\n', text_hrac, text_agent);
fprintf('Flood-fill odkryti| %6d | %6d\n', flood_hrac, flood_agent);
fprintf('Vlajky spravne    | %2d/%-2d | %2d/%-2d\n', ...
    spravne_vlajky_hrac, vsechny_miny, spravne_vlajky_agent, vsechny_miny);
fprintf('============================================\n');

diary off;
end

function uloz_obrazek(jmeno)
ax = gca;
try
    ax.Toolbar.Visible = 'off';
catch
end
exportgraphics(ax, jmeno);
end