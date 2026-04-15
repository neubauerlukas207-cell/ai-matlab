=== UKOL 2: Neuronova sit se sigmoidni aktivacni funkci -- EKVIVALENCE (XNOR) ===

Cviceni: CV09

--- Popis ---
Implementace vicevrstve neuronove site se sigmoidni aktivacni funkci,
ktera se nauci funkci EKVIVALENCE (XNOR) pomoci backpropagation.

Funkce EKVIVALENCE vraci:
1 pokud jsou vstupy stejne (0,0 nebo 1,1)
0 pokud jsou ruzne (0,1 nebo 1,0)

---

--- Soubory ---
sigmoid.m            -- sigmoidni aktivacni funkce
sit_ekvivalence.m    -- dopredny pruchod site (architektura 2-2-1)
uceni_backprop.m     -- uceni site pomoci backpropagation
test_ekvivalence.m   -- testovani site + vykresleni grafu

vysledky/
  prubeh_uceni.png        -- graf chyby (MSE) v case
  rozhodovaci_plocha.png -- vizualizace rozhodovaci plochy

---

--- Spusteni ---
1. Otevrit MATLAB
2. Nastavit aktualni slozku na ukol2_ekvivalence/
3. Spustit: test_ekvivalence

---

--- Vysledky ---
Sit se uspesne naucila funkci EKVIVALENCE.

Priklad vystupu:
0 0 -> ~0.9 -> 1
0 1 -> ~0.1 -> 0
1 0 -> ~0.1 -> 0
1 1 -> ~0.9 -> 1

Po prahovani (0.5):
Uspesnost: 4/4 (100%)

---

--- Architektura site ---
Vstupy: x1, x2

Skryta vrstva:
2 neurony (h1, h2)
sigmoidni aktivacni funkce

Vystupni vrstva:
1 neuron (y)
sigmoidni aktivacni funkce

---

--- Parametry uceni ---
Learning rate: 1.0
Max epoch: 20000
Ukonceni: MSE < 0.01

---

--- Poznamka ---
Problem EKVIVALENCE neni linearne separabilni,
proto nelze pouzit jeden perceptron.
Skryta vrstva umoznuje nauceni nelinearni hranice.