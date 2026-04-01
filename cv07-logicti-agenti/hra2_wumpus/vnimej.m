function percept = vnimej(svet, pozice)                         % vrati percepce na aktualni pozici agenta
i = pozice(1);                                                 % radek aktualni pozice
j = pozice(2);                                                 % sloupec aktualni pozice
N = svet.N;                                                    % rozmer mrizky

percept.zapach = false;                                        % vychozi hodnota: zadny zapach
percept.vanek = false;                                         % vychozi hodnota: zadny vanek
percept.lesk = isequal(pozice, svet.zlato_pozice) && ~svet.zlato_vzato; % lesk je true, pokud stojime na zlate a jeste jsme ho nevzali
percept.naraz = false;                                         % naraz tady nepouzivame, ale nechavame ho kvuli zadani

dirs = [-1 0; 1 0; 0 -1; 0 1];                                 % 4-směrní sousedi: nahoru, dolu, doleva, doprava

for k = 1:4                                                    % projdeme vsechny 4 sousedy
    ni = i + dirs(k,1);                                        % radek souseda
    nj = j + dirs(k,2);                                        % sloupec souseda

    if ni >= 1 && ni <= N && nj >= 1 && nj <= N                % kontrola, ze soused lezi uvnitr mrizky
        if isequal([ni nj], svet.wumpus_pozice) && svet.wumpus_ziv % pokud je na sousednim poli Wumpus
            percept.zapach = true;                             % nastavime zapach na true
        end                                                    % konec kontroly Wumpuse

        if svet.jamy(ni,nj)                                    % pokud je na sousednim poli jama
            percept.vanek = true;                              % nastavime vanek na true
        end                                                    % konec kontroly jamy
    end                                                        % konec kontroly hranic
end                                                            % konec cyklu pres sousedy
end                                                            % konec funkce