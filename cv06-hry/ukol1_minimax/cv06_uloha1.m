clc;
clear;

fprintf('===============================\n');
fprintf('CV06 - Uloha 1: Minimax + AB\n');
fprintf('Piskvorky 3x3\n');
fprintf('===============================\n');

deska = piskvorky_hra.inicializuj_desku();

volba = upper(strtrim(input('Chces hrat jako X (prvni) nebo O (druhy)? [X/O]: ', 's')));
while ~ismember(volba, {'X', 'O'})
    volba = upper(strtrim(input('Zadej pouze X nebo O: ', 's')));
end

if volba == 'X'
    clovek = 1;
    ai = 2;
else
    clovek = 2;
    ai = 1;
end

aktualni = 1;

fprintf('\nZaciname hru.\n');
fprintf('Clovek = %s, AI = %s\n', piskvorky_hra.symbol(clovek), piskvorky_hra.symbol(ai));
piskvorky_hra.zobraz_desku(deska);

while ~piskvorky_hra.je_konec(deska)
    if aktualni == clovek
        fprintf('Tah cloveka (%s)\n', piskvorky_hra.symbol(clovek));

        platny = false;
        while ~platny
            r = input('Zadej radek (1-3): ');
            s = input('Zadej sloupec (1-3): ');

            if isnumeric(r) && isnumeric(s) && piskvorky_hra.validni_tah(deska, r, s)
                platny = true;
                deska = piskvorky_hra.proved_tah(deska, r, s, clovek);
            else
                fprintf('Neplatny tah. Zkus to znovu.\n');
            end
        end
    else
        fprintf('Tah AI (%s)...\n', piskvorky_hra.symbol(ai));
        [r, s, skore, uzly] = minimax_agent.nejlepsi_tah(deska, ai, clovek, true);
        deska = piskvorky_hra.proved_tah(deska, r, s, ai);
        fprintf('AI zvolila tah: [%d, %d], skore = %d, prohledane uzly = %d\n', r, s, skore, uzly);
    end

    piskvorky_hra.zobraz_desku(deska);

    if piskvorky_hra.je_konec(deska)
        break;
    end

    if aktualni == 1
        aktualni = 2;
    else
        aktualni = 1;
    end
end

fprintf('Konec hry.\n');
piskvorky_hra.vypis_vysledek(deska, clovek, ai);

fprintf('\n--- Statistiky alfa-beta orezavani ---\n');
stats = minimax_agent.statistiky_alfa_beta();
fprintf('Minimax bez orezavani: %d uzlu\n', stats.uzly_bez_orezu);
fprintf('Minimax s alfa-beta:   %d uzlu\n', stats.uzly_s_ab);
fprintf('Uspora: %.2f %%\n', stats.uspora_procent);