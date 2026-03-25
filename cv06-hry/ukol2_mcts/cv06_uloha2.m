clc;
clear;

fprintf('===============================\n');
fprintf('CV06 - Uloha 2: MCTS\n');
fprintf('Piskvorky 3x3\n');
fprintf('===============================\n');

deska = piskvorky_hra.inicializuj_desku();

pocet_simulaci = input('Zadej pocet simulaci MCTS (napr. 100, 500, 1000, 5000): ');
while isempty(pocet_simulaci) || ~isscalar(pocet_simulaci) || pocet_simulaci <= 0
    pocet_simulaci = input('Zadej kladne cele cislo: ');
end

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
fprintf('MCTS simulace na tah: %d\n', pocet_simulaci);
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
        tic;
        [r, s] = mcts_agent.mcts_tah(deska, pocet_simulaci, ai, clovek);
        cas = toc;
        deska = piskvorky_hra.proved_tah(deska, r, s, ai);
        fprintf('AI zvolila tah: [%d, %d], cas = %.4f s\n', r, s, cas);
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