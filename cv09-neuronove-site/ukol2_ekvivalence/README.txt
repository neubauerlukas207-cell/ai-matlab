# Ukol 2: Neuronova sit se sigmoidni aktivacni funkci -- EKVIVALENCE

## Popis
Implementace vicevrstve neuronove site se sigmoidni aktivacni funkci,
ktera se nauci funkci EKVIVALENCE (XNOR) pomoci backpropagation.
Na rozdil od Ukolu 1 sit nenma pevne zadane vahy -- najde je sama ucenim.

## Co je EKVIVALENCE
EKVIVALENCE vraci 1 pokud jsou oba vstupy stejne (oba 0 nebo oba 1):

  x1=0, x2=0 --> vystup 1
  x1=0, x2=1 --> vystup 0
  x1=1, x2=0 --> vystup 0
  x1=1, x2=1 --> vystup 1

EKVIVALENCE neni linearni separabilni -- stejne jako XOR ji nelze
resit jednim perceptronem. Je potreba skryta vrstva.

## Architektura site (2-2-1)
- 2 vstupni neurony (x1, x2)
- 2 skryte neurony (H1, H2) -- kazdy ma bias
- 1 vystupni neuron -- ma bias
- Celkem 9 parametru k nauceni:
    W.ih (2x2) -- vahy vstup -> skryta vrstva
    W.ho (2x1) -- vahy skryta vrstva -> vystup
    b.h  (2x1) -- biasy skrytych neuronu
    b.o  (1x1) -- bias vystupniho neuronu

## Sigmoidni aktivacni funkce
sigma(s) = 1 / (1 + exp(-s))

Vlastnosti:
- Vystup je vzdy mezi 0 a 1
- sigma(0) = 0.5
- Diferencovatelna --> lze pouzit gradient descent (backpropagation)
- Derivace: sigma'(s) = sigma(s) * (1 - sigma(s))

## Backpropagation -- jak se sit uci
1. Dopredny pruchod: vypocitej vystup site
2. Vypocitej chybu vystupniho neuronu:
     delta_o = (y - t) * y * (1 - y)
3. Propaguj chybu zpet ke skrytym neuronum:
     delta_h1 = delta_o * W.ho(1) * h1 * (1 - h1)
     delta_h2 = delta_o * W.ho(2) * h2 * (1 - h2)
4. Aktualizuj vahy (gradient descent):
     W = W - lr * delta * vstup

## Parametry uceni
- Learning rate: lr = 1.0
- Max. pocet epoch: 10000
- Cilova chyba MSE: < 0.01
- Inicializace vah: randn * 0.5 (male nahodne hodnoty, seed=42)

## Soubory
- sigmoid.m          -- sigmoidni aktivacni funkce
- sit_ekvivalence.m  -- dopredny pruchod site 2-2-1
- uceni_backprop.m   -- uceni site backpropagation
- test_ekvivalence.m -- testovaci skript + grafy

## Spusteni
V MATLABu spustte:
  test_ekvivalence

Vystup by mel vypadat takto:
=== TEST SITE PRO EKVIVALENCI ===

x1  x2 | vystup (y) | zaokrouhleno | ocekavano | spravne?
------------------------------------------------------------
 0   0 |     0.9842 |            1 |         1 | ANO
 0   1 |     0.0231 |            0 |         0 | ANO
 1   0 |     0.0198 |            0 |         0 | ANO
 1   1 |     0.9756 |            1 |         1 | ANO
------------------------------------------------------------
Uspesnost: 4/4 (100%)

## Vystupy
- prubeh_uceni.png       -- graf MSE vs. epochy (sit se uci)
- rozhodovaci_hranice.png -- vizualizace co se sit naucila

## Jak cist grafy
prubeh_uceni.png:
  - Osa X = epochy (pocet iteraci uceni)
  - Osa Y = MSE (stredni kvadraticka chyba)
  - Chyba klesa z ~0.28 na ~0 za cca 600 epoch --> sit se naucila

rozhodovaci_hranice.png:
  - Zluta oblast = vystup site blizko 1 (EKVIVALENCE = true)
  - Modra oblast = vystup site blizko 0 (EKVIVALENCE = false)
  - Kolecka (O) = trida 1, lezi ve zlute oblasti
  - Krizky (X) = trida 0, lezi v modre oblasti

## Proc to funguje
Sit pouziva 2 skryte neurony ktere spolecne vytvorit nelinearni
rozhodovaci hranici. Jeden perceptron by umel pouze primku --
EKVIVALENCE potrebuje slozitejsi hranici (viz rozhodovaci_hranice.png).
Backpropagation postupne upravuje vahy tak aby se celkova chyba
minimalizovala -- po ~600 epochach je MSE < 0.01.

## Pouzite zdroje
- Prirucka studenta CV09 v2 (Prirucka_student_cv09_v2.pdf)
- Russell & Norvig: Artificial Intelligence: A Modern Approach, kap. 21