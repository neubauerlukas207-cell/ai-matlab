=== UKOL 1: Neuronova sit s prahovou aktivacni funkci -- XOR ===

Cviceni: CV09

--- Popis ---
Implementace neuronove site s prahovou (step) aktivacni funkci,
ktera pocita funkci XOR. Protoze XOR neni linearni separabilni,
pouziva se skryta vrstva (architektura 2-1-1).

--- Soubory ---
perceptron_prah.m  -- implementace jednoho perceptronu s prahovou funkci
xor_sit_prah.m     -- sit pro XOR (skryty + vystupni neuron)
test_xor_prah.m    -- testovaci skript, overi vsechny 4 kombinace vstupu
rucni_vypocet.txt  -- rucni vypocet pro vsechny 4 kombinace vstupu

--- Spusteni ---
1. Otevrit MATLAB
2. Nastavit aktualni slozku na ukol1_xor_prah/
3. Spustit: test_xor_prah

--- Vysledky ---
Sit spravne pocita XOR pro vsechny 4 kombinace vstupu (4/4, 100%).

--- Architektura site ---
Vstupy: x1, x2
Skryty neuron H:   vahy [0.3, 0.3], prah 0.5  (pocita AND)
Vystupni neuron O: vahy [0.3, 0.3, -0.6], prah 0.2  (pocita OR AND NOT AND)