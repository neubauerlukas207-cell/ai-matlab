function wumpus_hra()                                                           % hlavni skript pro hrace i agenta
clc;                                                                            % vycisti command window
close all;                                                                      % zavre vsechna figure
rng('shuffle');                                                                 % nastavi nahodne seminko

diary('wumpus_vystup.txt');                                                     % zacne ukladat command window do souboru
diary on;                                                                       % zapne diary

N = 5;                                                                          % velikost sveta
svet = init_wumpus_world(N);                                                    % vytvori svet
zadani = svet;                                                                  % ulozi kopii sveta pro agenta

kb = init_kb(N);                                                                % vytvori KB hrace
navstiveno_hrac = false(N);                                                     % navstivena pole hrace
kroky_hrac = 0;                                                                 % pocet kroku hrace
vysledek_hrac = 'Nedokonceno';                                                  % vysledek hrace

figure('Name','Wumpus - hrac');                                                 % figure pro hrace
t0 = tic;                                                                       % start casu hrace

while true                                                                      % smycka hrace
    pos = svet.agent_pozice;                                                    % aktualni pozice
    navstiveno_hrac(pos(1),pos(2)) = true;                                      % oznac pozici jako navstivenou

    percept = vnimej(svet, pos);                                                % ziskej percepce
    kb = aktualizuj_kb(kb, pos, percept);                                       % aktualizuj KB

    vykresli_hrace(svet, kb, percept);                                          % vykresli hrace
    fprintf('HRAC: pozice=[%d,%d] | zapach=%d vanek=%d lesk=%d\n', ...
        pos(1), pos(2), percept.zapach, percept.vanek, percept.lesk);           % vypis do command window

    if svet.jamy(pos(1),pos(2))                                                 % kontrola jamy
        vysledek_hrac = 'Padl do jamy';                                         % prohra
        break;                                                                   % konec hry
    end

    if isequal(pos, svet.wumpus_pozice)                                          % kontrola Wumpuse
        vysledek_hrac = 'Sezral ho Wumpus';                                     % prohra
        break;                                                                   % konec hry
    end

    if svet.zlato_vzato && isequal(pos, [1 1])                                  % kontrola vyhry
        vysledek_hrac = 'Vyhra';                                                % vyhra
        break;                                                                   % konec hry
    end

    w = waitforbuttonpress;                                                      % pocka na klavesu
    if w ~= 1                                                                    % pokud to neni klavesa
        continue;                                                                % ignoruj
    end

    key = lower(get(gcf,'CurrentCharacter'));                                    % nacti klavesu

    if key == 'q'                                                                % ukonceni hry
        vysledek_hrac = 'Ukonceno';                                             % nastav vysledek
        break;                                                                   % konec hry

    elseif key == 'g'                                                            % sebrani zlata
        if isequal(pos, svet.zlato_pozice)                                       % pokud je agent na zlate
            svet.zlato_vzato = true;                                             % vezme zlato
            fprintf('HRAC: sebral zlato\n');                                     % vypis zpravu
        end
        kroky_hrac = kroky_hrac + 1;                                             % zvys pocet kroku

    elseif key == 'w'                                                            % pohyb nahoru
        nove = pos + [-1 0];
        if nove(1) >= 1
            svet.agent_pozice = nove;
        end
        kroky_hrac = kroky_hrac + 1;

    elseif key == 's'                                                            % pohyb dolu
        nove = pos + [1 0];
        if nove(1) <= N
            svet.agent_pozice = nove;
        end
        kroky_hrac = kroky_hrac + 1;

    elseif key == 'a'                                                            % pohyb doleva
        nove = pos + [0 -1];
        if nove(2) >= 1
            svet.agent_pozice = nove;
        end
        kroky_hrac = kroky_hrac + 1;

    elseif key == 'd'                                                            % pohyb doprava
        nove = pos + [0 1];
        if nove(2) <= N
            svet.agent_pozice = nove;
        end
        kroky_hrac = kroky_hrac + 1;
    end
end

cas_hrac = toc(t0);                                                              % zmer cas hrace
drawnow;                                                                         % prekresli
exportgraphics(gca,'wumpus_hrac.png');                                           % uloz finalni obrazek hrace

svet = zadani;                                                                   % obnov stejny svet pro agenta
kb = init_kb(N);                                                                 % KB agenta
navstiveno_agent = false(N);                                                     % navstivena pole agenta
kroky_agent = 0;                                                                 % pocet kroku agenta
vysledek_agent = 'Nedokonceno';                                                  % vysledek agenta

figure('Name','Wumpus - agent');                                                 % figure pro agenta
t1 = tic;                                                                        % start casu agenta

while true                                                                       % smycka agenta
    pos = svet.agent_pozice;                                                     % aktualni pozice
    navstiveno_agent(pos(1),pos(2)) = true;                                      % oznac jako navstivene

    percept = vnimej(svet, pos);                                                 % ziskej percepce
    kb = aktualizuj_kb(kb, pos, percept);                                        % aktualizuj KB

    vykresli_agenta(svet, kb, percept);                                          % vykresli agenta
    fprintf('AGENT: pozice=[%d,%d] | zapach=%d vanek=%d lesk=%d\n', ...
        pos(1), pos(2), percept.zapach, percept.vanek, percept.lesk);            % vypis stav

    if svet.jamy(pos(1),pos(2))                                                  % kontrola jamy
        vysledek_agent = 'Padl do jamy';                                         % prohra
        break;                                                                   % konec hry
    end

    if isequal(pos, svet.wumpus_pozice)                                          % kontrola Wumpuse
        vysledek_agent = 'Sezral ho Wumpus';                                     % prohra
        break;                                                                   % konec hry
    end

    if svet.zlato_vzato && isequal(pos, [1 1])                                   % kontrola vyhry
        vysledek_agent = 'Vyhra';                                                % vyhra
        break;                                                                   % konec hry
    end

    akce = naplanov_akci(svet, kb, percept);                                     % naplanuj dalsi akci

    if ischar(akce) || isstring(akce)                                            % pokud je akce text
        if strcmp(akce,'VZIT_ZLATO')                                             % pokud se ma vzit zlato
            svet.zlato_vzato = true;                                             % vezmi zlato
            kroky_agent = kroky_agent + 1;                                       % zvys kroky
            fprintf('AGENT: sebral zlato\n');                                    % vypis zpravu
        else                                                                     % jinak
            vysledek_agent = 'Zasekl se';                                        % agent nema bezpecny tah
            break;                                                               % konec hry
        end
    else                                                                         % pokud je akce seznam kroku
        if isempty(akce)                                                         % kdyz je prazdna
            vysledek_agent = 'Zasekl se';                                        % konec
            break;
        end

        for k = 1:numel(akce)                                                    % projdi vsechny kroky
            switch akce{k}
                case 'NAHORU'
                    svet.agent_pozice = svet.agent_pozice + [-1 0];
                case 'DOLU'
                    svet.agent_pozice = svet.agent_pozice + [1 0];
                case 'DOLEVA'
                    svet.agent_pozice = svet.agent_pozice + [0 -1];
                case 'DOPRAVA'
                    svet.agent_pozice = svet.agent_pozice + [0 1];
            end

            kroky_agent = kroky_agent + 1;                                       % zvys kroky

            pos2 = svet.agent_pozice;                                            % nova pozice
            vykresli_agenta(svet, kb, vnimej(svet, pos2));                       % vykresli krok
            pause(0.25);                                                         % kratka pauza

            if svet.jamy(pos2(1),pos2(2))                                        % kontrola jamy
                vysledek_agent = 'Padl do jamy';
                break;
            end

            if isequal(pos2, svet.wumpus_pozice)                                 % kontrola Wumpuse
                vysledek_agent = 'Sezral ho Wumpus';
                break;
            end
        end

        if ~strcmp(vysledek_agent, 'Nedokonceno')                                % pokud uz hra skoncila
            break;
        end
    end

    pause(0.2);                                                                  % pauza mezi tahy
end

cas_agent = toc(t1);                                                             % zmer cas agenta
drawnow;                                                                         % prekresli
exportgraphics(gca,'wumpus_agent.png');                                          % uloz finalni obrazek agenta

fprintf('\n===============================================================\n');
fprintf('POROVNANI: HRAC vs. AGENT\n');
fprintf('===============================================================\n');
fprintf('| %-18s | %-20s | %-20s |\n', '', 'Hrac', 'Agent');
fprintf('---------------------------------------------------------------\n');
fprintf('| %-18s | %-20d | %-20d |\n', 'Pocet kroku', kroky_hrac, kroky_agent);
fprintf('| %-18s | %-20.2f | %-20.2f |\n', 'Cas (s)', cas_hrac, cas_agent);
fprintf('| %-18s | %-20s | %-20s |\n', 'Vysledek', vysledek_hrac, vysledek_agent);
fprintf('| %-18s | %-20d | %-20d |\n', 'Prozkoumano poli', nnz(navstiveno_hrac), nnz(navstiveno_agent));
fprintf('===============================================================\n');

diary off;                                                                       % vypni ukladani vystupu
end

function kb = init_kb(N)                                                         % inicializace knowledge base
kb.navstivena = false(N);                                                        % navstivena pole
kb.bezpecna = false(N);                                                          % bezpecna pole
kb.mozna_jama = false(N);                                                        % mozna jama
kb.mozny_wumpus = false(N);                                                      % mozny wumpus
kb.bezpecna(1,1) = true;                                                         % start je bezpecny
end

function vykresli_hrace(svet, kb, percept)                                       % vykresli stav hrace
N = svet.N;
A = 0.25 * ones(N);                                                              % tmava barva pro nezname
A(kb.bezpecna) = 0.75;                                                           % svetlejsi pro bezpecna
A(kb.navstivena) = 1.0;                                                          % nejsvetlejsi pro navstivena

imagesc(A);                                                                      % vykresli matici
axis equal tight;                                                                % nastav osy
set(gca,'XTick',1:N,'YTick',1:N);                                                % tick marky
grid on;                                                                         % mrizka
title(sprintf('HRAC | zapach=%d vanek=%d lesk=%d | W,A,S,D pohyb | G zlato | Q konec', ...
    percept.zapach, percept.vanek, percept.lesk));                               % titulek

hold on;                                                                         % podrz figure
text(svet.agent_pozice(2), svet.agent_pozice(1), 'A', ...
    'Color','b', ...
    'HorizontalAlignment','center', ...
    'FontWeight','bold', ...
    'FontSize',14);                                                              % nakresli agenta
hold off;                                                                        % ukonci podrzeni
drawnow;                                                                         % prekresli
end

function vykresli_agenta(svet, kb, percept)                                      % vykresli stav agenta
N = svet.N;
A = 0.35 * ones(N);                                                              % zakladni barva
A(kb.bezpecna) = 0.75;                                                           % bezpecna pole
A(kb.navstivena) = 1.0;                                                          % navstivena pole

imagesc(A);                                                                      % vykresli matici
axis equal tight;                                                                % nastav osy
set(gca,'XTick',1:N,'YTick',1:N);                                                % tick marky
grid on;                                                                         % mrizka
title(sprintf('AGENT | zapach=%d vanek=%d lesk=%d', ...
    percept.zapach, percept.vanek, percept.lesk));                               % titulek

hold on;                                                                         % podrz figure
for i = 1:N                                                                      % projdi radky
    for j = 1:N                                                                  % projdi sloupce
        if kb.navstivena(i,j)                                                    % pokud je pole navstivene
            rectangle('Position',[j-0.5 i-0.5 1 1], ...
                'EdgeColor','g', 'LineWidth',1.5);                               % zeleny ramecek
        end
    end
end

text(svet.agent_pozice(2), svet.agent_pozice(1), 'A', ...
    'Color','b', ...
    'HorizontalAlignment','center', ...
    'FontWeight','bold', ...
    'FontSize',14);                                                              % nakresli agenta
hold off;                                                                        % ukonci podrzeni
drawnow;                                                                         % prekresli
end