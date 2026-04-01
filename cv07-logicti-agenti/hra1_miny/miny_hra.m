function miny_hra()
clc;
close all;

diary('vystup.txt');
diary on;

rng('shuffle');

% =========================
% HRAC
% =========================
miny = generuj_miny(9,9,10);
zadani = miny;

figure('Name','Miny - hrac');
vizualizuj_miny(miny,false);
title('Miny - hrac - zacatek');
drawnow;
exportgraphics(gca,'screenshot_zacatek.png');

tahy_hrac = 0;
flood_hrac = 0;
vysledek_hrac = 0;
ulozen_prubeh = false;

t0 = tic;

while vysledek_hrac == 0
    [x,y,button] = ginput(1);

    if isempty(x)
        break;
    end

    j = round(x);
    i = round(y);

    if i < 1 || i > miny.N || j < 1 || j > miny.M
        continue;
    end

    if button == 1
        [miny, vysledek_hrac, f] = odkryj_pole(miny,i,j);
        tahy_hrac = tahy_hrac + 1;
        flood_hrac = flood_hrac + f;

        if miny.pole(i,j) == -1
            fprintf('Hrac tah %d: mina na [%d,%d]\n', tahy_hrac, i, j);
        else
            fprintf('Hrac tah %d: odkryto [%d,%d], hodnota=%d\n', tahy_hrac, i, j, miny.pole(i,j));
        end

    elseif button == 3
        if ~miny.odkryto(i,j)
            miny.vlajky(i,j) = ~miny.vlajky(i,j);
            tahy_hrac = tahy_hrac + 1;
            fprintf('Hrac tah %d: vlajka na [%d,%d]\n', tahy_hrac, i, j);
        end
    end

    vizualizuj_miny(miny, vysledek_hrac == -1);
    title('Miny - hrac - prubeh');
    drawnow;

    if tahy_hrac >= 3 && ~ulozen_prubeh
        exportgraphics(gca,'screenshot_prubeh.png');
        ulozen_prubeh = true;
    end
end

cas_hrac = toc(t0);

if ~ulozen_prubeh
    vizualizuj_miny(miny, vysledek_hrac == -1);
    title('Miny - hrac - prubeh');
    drawnow;
    exportgraphics(gca,'screenshot_prubeh.png');
end

vizualizuj_miny(miny,true);
title('Miny - hrac - konec');
drawnow;
exportgraphics(gca,'screenshot_konec.png');

if vysledek_hrac == 1
    text_hrac = 'Vyhra';
else
    text_hrac = 'Prohra';
end

% =========================
% AGENT
% =========================
fprintf('\n=== AGENT ===\n');

minyA = zadani;
tahy_agent = 0;
flood_agent = 0;
vysledek_agent = 0;

figure('Name','Miny - agent');
vizualizuj_miny(minyA,false);
title('Miny - agent - zacatek');
drawnow;

t1 = tic;

% prvni tah agenta = nahodny start
kandidati = find(~minyA.odkryto & ~minyA.vlajky);
p = kandidati(randi(numel(kandidati)));
[i,j] = ind2sub([minyA.N minyA.M], p);

[minyA, vysledek_agent, f] = odkryj_pole(minyA,i,j);
tahy_agent = tahy_agent + 1;
flood_agent = flood_agent + f;

vizualizuj_miny(minyA, vysledek_agent == -1);
title(sprintf('Miny - agent - tah %d', tahy_agent));
drawnow;
pause(0.4);

while vysledek_agent == 0
    [bezpecna, miny_nalezene] = miny_agent(minyA);

    % oznaceni min
    zmena_vlajek = false;
    for k = 1:size(miny_nalezene,1)
        r = miny_nalezene(k,1);
        s = miny_nalezene(k,2);

        if ~minyA.odkryto(r,s) && ~minyA.vlajky(r,s)
            minyA.vlajky(r,s) = true;
            zmena_vlajek = true;
            fprintf('Agent: oznacena mina [%d,%d]\n', r, s);
        end
    end

    if zmena_vlajek
        vizualizuj_miny(minyA,false);
        title(sprintf('Miny - agent - vlajky, tah %d', tahy_agent));
        drawnow;
        pause(0.3);
    end

    provedl_tah = false;

    % odkryti bezpecneho pole
    for k = 1:size(bezpecna,1)
        r = bezpecna(k,1);
        s = bezpecna(k,2);

        if ~minyA.odkryto(r,s) && ~minyA.vlajky(r,s)
            [minyA, vysledek_agent, f] = odkryj_pole(minyA,r,s);
            tahy_agent = tahy_agent + 1;
            flood_agent = flood_agent + f;
            provedl_tah = true;

            fprintf('Agent tah %d: odkryto [%d,%d]\n', tahy_agent, r, s);

            vizualizuj_miny(minyA, vysledek_agent == -1);
            title(sprintf('Miny - agent - tah %d', tahy_agent));
            drawnow;
            pause(0.4);
            break;
        end
    end

    % kdyz nema jisty tah, hraje nahodne
    if ~provedl_tah && vysledek_agent == 0
        kandidati = find(~minyA.odkryto & ~minyA.vlajky);

        if isempty(kandidati)
            break;
        end

        p = kandidati(randi(numel(kandidati)));
        [r,s] = ind2sub([minyA.N minyA.M], p);

        [minyA, vysledek_agent, f] = odkryj_pole(minyA,r,s);
        tahy_agent = tahy_agent + 1;
        flood_agent = flood_agent + f;

        fprintf('Agent tah %d: nahodny tah [%d,%d]\n', tahy_agent, r, s);

        vizualizuj_miny(minyA, vysledek_agent == -1);
        title(sprintf('Miny - agent - tah %d', tahy_agent));
        drawnow;
        pause(0.4);
    end
end

cas_agent = toc(t1);

vizualizuj_miny(minyA,true);
title('Miny - agent - konec');
drawnow;
exportgraphics(gca,'agent_konec.png');

if vysledek_agent == 1
    text_agent = 'Vyhra';
else
    text_agent = 'Prohra';
end

% =========================
% POROVNANI
% =========================
fprintf('\n============================================\n');
fprintf('POROVNANI: HRAC vs. AGENT\n');
fprintf('============================================\n');
fprintf('| Pocet tahu       | %6d | %6d |\n', tahy_hrac, tahy_agent);
fprintf('| Cas (s)          | %6.2f | %6.2f |\n', cas_hrac, cas_agent);
fprintf('| Vysledek         | %6s | %6s |\n', text_hrac, text_agent);
fprintf('| Flood-fill       | %6d | %6d |\n', flood_hrac, flood_agent);
fprintf('============================================\n');

diary off;
end