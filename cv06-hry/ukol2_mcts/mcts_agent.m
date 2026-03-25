classdef mcts_agent
    % MCTS_AGENT Monte Carlo Tree Search pro piskvorky 3x3

    methods(Static)
        function [radek, sloupec, strom] = mcts_tah(deska, pocet_simulaci, ai_hrac, clovek_hrac)
            if nargin < 3
                ai_hrac = 2;
            end
            if nargin < 4
                clovek_hrac = 1;
            end

            if piskvorky_hra.je_konec(deska)
                radek = -1;
                sloupec = -1;
                strom = struct([]);
                return;
            end

            koren.deska = deska;
            koren.rodic = 0;
            koren.tah = [0, 0];
            koren.navstevy = 0;
            koren.vyhry = 0;
            koren.potomci = [];
            koren.nezkousene_tahy = piskvorky_hra.volne_pozice(deska);
            koren.hrac_na_tahu = piskvorky_hra.aktualni_hrac(deska);

            strom = koren;

            for sim = 1:pocet_simulaci
                idx = 1;
                cesta = 1;

                % 1) Selekce
                while isempty(strom(idx).nezkousene_tahy) && ~isempty(strom(idx).potomci) && ...
                        ~piskvorky_hra.je_konec(strom(idx).deska)
                    idx = mcts_agent.selekce(strom, idx);
                    cesta(end + 1) = idx; %#ok<AGROW>
                end

                % 2) Expanze
                if ~piskvorky_hra.je_konec(strom(idx).deska) && ~isempty(strom(idx).nezkousene_tahy)
                    [strom, novy_idx] = mcts_agent.expanze(strom, idx);
                    idx = novy_idx;
                    cesta(end + 1) = idx; %#ok<AGROW>
                end

                % 3) Simulace
                vysledek = mcts_agent.simulace(strom(idx).deska, ai_hrac, clovek_hrac);

                % 4) Zpetna propagace
                strom = mcts_agent.zpetna_propagace(strom, cesta, vysledek);
            end

            if isempty(strom(1).potomci)
                volne = piskvorky_hra.volne_pozice(deska);
                radek = volne(1, 1);
                sloupec = volne(1, 2);
                return;
            end

            potomci = strom(1).potomci;
            navstevy = arrayfun(@(i) strom(i).navstevy, potomci);
            [~, idx_max] = max(navstevy);
            nej_idx = potomci(idx_max);

            radek = strom(nej_idx).tah(1);
            sloupec = strom(nej_idx).tah(2);
        end

        function idx_best = selekce(strom, idx_uzlu)
            C = sqrt(2);
            potomci = strom(idx_uzlu).potomci;
            parent_visits = strom(idx_uzlu).navstevy;

            best_ucb = -inf;
            idx_best = potomci(1);

            for k = 1:length(potomci)
                i = potomci(k);

                if strom(i).navstevy == 0
                    idx_best = i;
                    return;
                end

                exploit = strom(i).vyhry / strom(i).navstevy;
                explore = C * sqrt(log(max(parent_visits, 1)) / strom(i).navstevy);
                ucb = exploit + explore;

                if ucb > best_ucb
                    best_ucb = ucb;
                    idx_best = i;
                end
            end
        end

        function [strom, novy_idx] = expanze(strom, idx_uzlu)
            tahy = strom(idx_uzlu).nezkousene_tahy;
            vyber = randi(size(tahy, 1));
            tah = tahy(vyber, :);

            strom(idx_uzlu).nezkousene_tahy(vyber, :) = [];

            hrac = strom(idx_uzlu).hrac_na_tahu;
            nova_deska = piskvorky_hra.proved_tah(strom(idx_uzlu).deska, tah(1), tah(2), hrac);

            novy_uzel.deska = nova_deska;
            novy_uzel.rodic = idx_uzlu;
            novy_uzel.tah = tah;
            novy_uzel.navstevy = 0;
            novy_uzel.vyhry = 0;
            novy_uzel.potomci = [];
            novy_uzel.nezkousene_tahy = piskvorky_hra.volne_pozice(nova_deska);
            novy_uzel.hrac_na_tahu = piskvorky_hra.aktualni_hrac(nova_deska);

            strom(end + 1) = novy_uzel;
            novy_idx = length(strom);
            strom(idx_uzlu).potomci(end + 1) = novy_idx;
        end

        function vysledek = simulace(deska, ai_hrac, clovek_hrac)
            sim_deska = deska;

            while ~piskvorky_hra.je_konec(sim_deska)
                hrac = piskvorky_hra.aktualni_hrac(sim_deska);
                volne = piskvorky_hra.volne_pozice(sim_deska);
                i = randi(size(volne, 1));
                sim_deska = piskvorky_hra.proved_tah(sim_deska, volne(i, 1), volne(i, 2), hrac);
            end

            if piskvorky_hra.je_vitez(sim_deska, ai_hrac)
                vysledek = 1.0;
            elseif piskvorky_hra.je_vitez(sim_deska, clovek_hrac)
                vysledek = 0.0;
            else
                vysledek = 0.5;
            end
        end

        function strom = zpetna_propagace(strom, cesta, vysledek)
            for i = 1:length(cesta)
                idx = cesta(i);
                strom(idx).navstevy = strom(idx).navstevy + 1;
                strom(idx).vyhry = strom(idx).vyhry + vysledek;
            end
        end
    end
end