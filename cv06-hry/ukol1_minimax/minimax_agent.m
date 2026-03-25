classdef minimax_agent
    % MINIMAX_AGENT Minimax s alfa-beta orezavanim pro piskvorky 3x3

    methods(Static)
        function [radek, sloupec, nej_skore, pocet_uzlu] = nejlepsi_tah(deska, ai_hrac, clovek_hrac, pouzit_ab)
            if nargin < 2
                ai_hrac = 2;
            end
            if nargin < 3
                clovek_hrac = 1;
            end
            if nargin < 4
                pouzit_ab = true;
            end

            volne = piskvorky_hra.volne_pozice(deska);

            nej_skore = -inf;
            radek = -1;
            sloupec = -1;
            pocet_uzlu = 0;

            for i = 1:size(volne, 1)
                r = volne(i, 1);
                s = volne(i, 2);

                nova_deska = deska;
                nova_deska(r, s) = ai_hrac;

                [skore, uzly] = minimax_agent.minimax( ...
                    nova_deska, 0, false, -inf, inf, pouzit_ab, ai_hrac, clovek_hrac);

                pocet_uzlu = pocet_uzlu + uzly;

                if skore > nej_skore
                    nej_skore = skore;
                    radek = r;
                    sloupec = s;
                end
            end
        end

        function [skore, pocet_uzlu] = minimax(deska, hloubka, je_maximalizujici, alfa, beta, pouzit_ab, ai_hrac, clovek_hrac)
            if nargin < 6
                pouzit_ab = true;
            end
            if nargin < 7
                ai_hrac = 2;
            end
            if nargin < 8
                clovek_hrac = 1;
            end

            pocet_uzlu = 1;

            if piskvorky_hra.je_vitez(deska, ai_hrac)
                skore = 10 - hloubka;
                return;
            end

            if piskvorky_hra.je_vitez(deska, clovek_hrac)
                skore = -10 + hloubka;
                return;
            end

            if piskvorky_hra.je_remiza(deska)
                skore = 0;
                return;
            end

            volne = piskvorky_hra.volne_pozice(deska);

            if je_maximalizujici
                skore = -inf;

                for i = 1:size(volne, 1)
                    r = volne(i, 1);
                    s = volne(i, 2);

                    nova_deska = deska;
                    nova_deska(r, s) = ai_hrac;

                    [hodnota, uzly] = minimax_agent.minimax( ...
                        nova_deska, hloubka + 1, false, alfa, beta, pouzit_ab, ai_hrac, clovek_hrac);

                    pocet_uzlu = pocet_uzlu + uzly;
                    skore = max(skore, hodnota);

                    if pouzit_ab
                        alfa = max(alfa, skore);
                        if alfa >= beta
                            break;
                        end
                    end
                end
            else
                skore = inf;

                for i = 1:size(volne, 1)
                    r = volne(i, 1);
                    s = volne(i, 2);

                    nova_deska = deska;
                    nova_deska(r, s) = clovek_hrac;

                    [hodnota, uzly] = minimax_agent.minimax( ...
                        nova_deska, hloubka + 1, true, alfa, beta, pouzit_ab, ai_hrac, clovek_hrac);

                    pocet_uzlu = pocet_uzlu + uzly;
                    skore = min(skore, hodnota);

                    if pouzit_ab
                        beta = min(beta, skore);
                        if alfa >= beta
                            break;
                        end
                    end
                end
            end
        end

        function stats = statistiky_alfa_beta()
            % Statistiky z pocatecni prazdne desky.
            % Podle bezne hry zacina X, tedy v koreni je na tahu minimalizujici hrac
            % pokud bereme standardne clovek = X a AI = O.

            deska = piskvorky_hra.inicializuj_desku();
            ai_hrac = 2;
            clovek_hrac = 1;

            [~, uzly_bez] = minimax_agent.minimax(deska, 0, false, -inf, inf, false, ai_hrac, clovek_hrac);
            [~, uzly_ab]  = minimax_agent.minimax(deska, 0, false, -inf, inf, true,  ai_hrac, clovek_hrac);

            uspora = (1 - uzly_ab / uzly_bez) * 100;

            stats = struct();
            stats.uzly_bez_orezu = uzly_bez;
            stats.uzly_s_ab = uzly_ab;
            stats.uspora_procent = uspora;
        end
    end
end