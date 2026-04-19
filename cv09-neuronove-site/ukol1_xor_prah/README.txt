# Úkol 1: Neuronová síť s prahovou aktivační funkcí -- XOR

## Popis
Ověření, že neuronová síť s prahovou (step) aktivační funkcí dokáže vypočítat
funkci XOR. XOR není lineárně separabilní -- nelze ji řešit jedním perceptronem,
proto potřebujeme skrytou vrstvu.

## Architektura sítě
- 2 vstupy (x1, x2)
- 1 skrytý neuron (prah = 0.5)
- 1 výstupní neuron (prah = 0.2)

Váhy:
- x1 → skrytý neuron: 0.3
- x2 → skrytý neuron: 0.3
- x1 → výstupní neuron: 0.3
- x2 → výstupní neuron: 0.3
- skrytý neuron → výstupní neuron: -0.6

## Prahová aktivační funkce
step(s) = 1  pokud s >= 0
step(s) = 0  pokud s <  0
kde s = (vážený součet vstupů) - prah

## Proč jeden perceptron nestačí
XOR není lineárně separabilní -- body (0,0) a (1,1) mají výstup 0,
body (0,1) a (1,0) mají výstup 1. Tyto skupiny nelze oddělit jednou
přímkou v 2D prostoru. Proto potřebujeme skrytou vrstvu.

Skrytý neuron počítá funkci AND (aktivuje se pouze při x1=1 AND x2=1).
Výstupní neuron kombinuje vstupy s AND a efektivně počítá:
OR(x1, x2) AND NOT(AND(x1, x2)) = XOR

## Soubory
- rucni_vypocet.txt   -- ruční výpočet pro všechny 4 kombinace vstupů
- perceptron_prah.m   -- implementace perceptronu s prahovou funkcí
- xor_sit_prah.m      -- síť pro XOR (volá perceptron_prah)
- test_xor_prah.m     -- testovací skript, vypisuje tabulku výsledků

## Spuštění
V MATLABu spusťte:
  test_xor_prah

Výstup by měl vypadat takto:
=== TEST XOR SITE S PRAHOVOU FUNKCI ===

x1  x2 | skryty (h) | vystup (y) | ocekavano | spravne?
----------------------------------------------------------
 0   0 |     0      |     0      |     0     | ANO
 0   1 |     0      |     1      |     1     | ANO
 1   0 |     0      |     1      |     1     | ANO
 1   1 |     1      |     0      |     0     | ANO
----------------------------------------------------------
Uspesnost: 4/4 (100%)

## Výsledky ručního výpočtu (shrnutí)

Kombinace 1: x1=0, x2=0
  s_h = 0*0.3 + 0*0.3 = 0.0  --> h = step(0.0 - 0.5) = step(-0.5) = 0
  s_o = 0*0.3 + 0*0.3 + 0*(-0.6) = 0.0  --> y = step(0.0 - 0.2) = step(-0.2) = 0
  Očekáváno: 0 --> SPRÁVNĚ

Kombinace 2: x1=0, x2=1
  s_h = 0*0.3 + 1*0.3 = 0.3  --> h = step(0.3 - 0.5) = step(-0.2) = 0
  s_o = 0*0.3 + 1*0.3 + 0*(-0.6) = 0.3  --> y = step(0.3 - 0.2) = step(0.1) = 1
  Očekáváno: 1 --> SPRÁVNĚ

Kombinace 3: x1=1, x2=0
  s_h = 1*0.3 + 0*0.3 = 0.3  --> h = step(0.3 - 0.5) = step(-0.2) = 0
  s_o = 1*0.3 + 0*0.3 + 0*(-0.6) = 0.3  --> y = step(0.3 - 0.2) = step(0.1) = 1
  Očekáváno: 1 --> SPRÁVNĚ

Kombinace 4: x1=1, x2=1
  s_h = 1*0.3 + 1*0.3 = 0.6  --> h = step(0.6 - 0.5) = step(0.1) = 1
  s_o = 1*0.3 + 1*0.3 + 1*(-0.6) = 0.0  --> y = step(0.0 - 0.2) = step(-0.2) = 0
  Očekáváno: 0 --> SPRÁVNĚ

Uspěšnost: 4/4 (100%)

## Proč to funguje -- intuice
- Skrytý neuron se aktivuje POUZE když x1=1 AND x2=1 (s_h = 0.6 > 0.5)
- Přímé vstupy (W=0.3 každý) přispívají pozitivně → tendence k OR
- Skrytý neuron (W=-0.6) přispívá negativně → penalizace za AND
- Práh 0.2 → stačí jeden vstup (0.3 > 0.2), ale dva vstupy s AND
  se vynulují (0.3 + 0.3 - 0.6 = 0.0 < 0.2)

