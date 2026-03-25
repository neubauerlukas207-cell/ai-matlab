classdef piskvorky_hra
    % PISKVORKY_HRA Zakladni herni logika pro piskvorky 3x3
    % Reprezentace:
    % 0 = prazdne pole
    % 1 = X
    % 2 = O

    methods(Static)
        function deska = inicializuj_desku()
            deska = zeros(3, 3);
        end

        function zobraz_desku(deska)
            fprintf('\n');
            for r = 1:3
                radek = '';
                for s = 1:3
                    radek = [radek, ' ', piskvorky_hra.symbol(deska(r, s)), ' ']; %#ok<AGROW>
                    if s < 3
                        radek = [radek, '|']; %#ok<AGROW>
                    end
                end
                fprintf('%s\n', radek);
                if r < 3
                    fprintf('---+---+---\n');
                end
            end
            fprintf('\n');
        end

        function vitez = je_vitez(deska, hrac)
            vitez = false;

            for r = 1:3
                if all(deska(r, :) == hrac)
                    vitez = true;
                    return;
                end
            end

            for s = 1:3
                if all(deska(:, s) == hrac)
                    vitez = true;
                    return;
                end
            end

            if all(diag(deska) == hrac) || all(diag(fliplr(deska)) == hrac)
                vitez = true;
            end
        end

        function remiza = je_remiza(deska)
            remiza = all(deska(:) ~= 0) && ...
                     ~piskvorky_hra.je_vitez(deska, 1) && ...
                     ~piskvorky_hra.je_vitez(deska, 2);
        end

        function pozice = volne_pozice(deska)
            [r, s] = find(deska == 0);
            pozice = [r, s];
        end

        function konec = je_konec(deska)
            konec = piskvorky_hra.je_vitez(deska, 1) || ...
                    piskvorky_hra.je_vitez(deska, 2) || ...
                    piskvorky_hra.je_remiza(deska);
        end

        function hrac = aktualni_hrac(deska)
            pocetX = sum(deska(:) == 1);
            pocetO = sum(deska(:) == 2);

            if pocetX <= pocetO
                hrac = 1;
            else
                hrac = 2;
            end
        end

        function ok = validni_tah(deska, radek, sloupec)
            ok = radek >= 1 && radek <= 3 && ...
                 sloupec >= 1 && sloupec <= 3 && ...
                 deska(radek, sloupec) == 0;
        end

        function deska2 = proved_tah(deska, radek, sloupec, hrac)
            deska2 = deska;
            deska2(radek, sloupec) = hrac;
        end

        function sym = symbol(hodnota)
            if hodnota == 1
                sym = 'X';
            elseif hodnota == 2
                sym = 'O';
            else
                sym = '.';
            end
        end

        function vypis_vysledek(deska, clovek, ai)
            if piskvorky_hra.je_vitez(deska, clovek)
                fprintf('Vyhral clovek (%s).\n', piskvorky_hra.symbol(clovek));
            elseif piskvorky_hra.je_vitez(deska, ai)
                fprintf('Vyhrala AI (%s).\n', piskvorky_hra.symbol(ai));
            else
                fprintf('Remiza.\n');
            end
        end
    end
end