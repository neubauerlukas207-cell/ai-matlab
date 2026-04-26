README - Ukol 1: Klasifikace obrazku predtrenovanou siti


OBSAH SLOZKY

klasifikace_pretrained.m   - Hlavni skript pro klasifikaci 10 obrazku
obrazky_test/              - Slozka s 10 testovacimi obrazky (obr01.jpg - obr10.jpg)
klasifikace_vysledky.png   - Vizualizace vysledku (subplot 2x5)
ANALYZA_PRETRAINED.txt     - Popis pouzite site a analyza vysledku
README.txt                 - Tento soubor

POUZITA SIT
SqueezeNet - defaultne dostupna v MATLAB Deep Learning Toolbox
Vstupni rozmer: 227 x 227 x 3
Pocet parametru: ~1.2 milionu

VYSLEDKY

Top-1 spravne: 2 / 10 (20 %)
Top-5 spravne: 5 / 10 (50 %)
Prumerny cas klasifikace: 0.1718 s/obrazek
Hardware: CPU
