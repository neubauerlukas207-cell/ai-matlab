CV05 – Úkol 2 (N dam – hill climbing)

Úkolem bylo vyřešit problém N dam pomocí hill climbing algoritmu.

Stav je reprezentován jako vektor (řádek -> sloupec).
Kontrolují se pouze diagonální konflikty.

Soubory:
- queens_utils.m – generování stavu + konflikty
- hill_climbing.m – algoritmus
- cv05_uloha2.m – spuštění, statistiky, grafy

Jak spustit:
Stačí spustit:
cv05_uloha2

Skript provede 100 běhů a vytvoří grafy.

Nastavení:
N = 8
100 běhů

Výsledky:
- Ne vždy se najde řešení
- Úspěšnost cca 10–20 %
- Algoritmus se často zasekne

Důvod:
Hill climbing může skončit v lokálním minimu.

Závěr:
Algoritmus je rychlý, ale není spolehlivý,
proto je potřeba více opakování.