# CV13 -- Prohledávání bludiště: BFS, DFS, A*

## Autoři

Týmová práce dvou studentů (zveřejněno se souhlasem spoluautora).
## Téma a cvičení

Projekt vychází z cvičení **CV03 -- Prohledávání stavového prostoru**.
Úloha: prohledávání náhodně generovaných bludišť algoritmy BFS, DFS a A*.

## Výzkumná otázka

Jak hustota překážek, velikost bludiště a volba heuristiky ovlivňují
výkon algoritmů BFS, DFS a A* -- konkrétně délku nalezené cesty,
počet expandovaných uzlů a čas běhu?

## Baseline

Výchozí řešení: **BFS na mřížce 20×20 s 20 % překážkami**, start [1,1], cíl [N,N].
Průměrná délka cesty, počet expandovaných uzlů a čas běhu naměřené
v souboru `kod/baseline.m` slouží jako referenční bod pro všechny experimenty.

## Experimenty

| # | Soubor | Popis | Hypotéza |
|---|--------|-------|----------|
| 1 | `experiment_01_hustota.m` | Vliv hustoty překážek (10--40 %) | Více překážek → více expandovaných uzlů, méně průchozích bludišť |
| 2 | `experiment_02_velikost.m` | Vliv velikosti mřížky (10--100) | Větší mřížka → výrazně větší čas, A* škáluje nejlépe |
| 3 | `experiment_03_heuristiky.m` | Srovnání heuristik A* | Manhattan nejúčinnější pro 4-sousedství, nulová = Dijkstra |
| 4 | `experiment_04_vzdalenost.m` | Vliv vzdálenosti start--cíl | Větší vzdálenost → A* těží více z heuristiky |
| 5 | `experiment_05_pruchozost.m` | Průchozost bludiště vs. hustota | Existuje kritická hustota (fázový přechod ~35 %) |

## Souhrnné srovnání

Souhrnný skript: `kod/srovnani_vsech.m`
Hlavní grafy a tabulka jsou v `vysledky/grafy/` a `vysledky/tabulky/`.

## Závěry

**Co fungovalo:**
BFS a A* vždy nalezly optimální cestu (39 kroků na mřížce 20×20). A* expandoval o 30 % méně uzlů než BFS díky Manhattan heuristice. Experiment 05 krásně ukázal fázový přechod při hustotě 30 % -- přesně polovina bludišť je průchozích.

**Co nefungovalo (překvapení):**
A* byl časově pomalejší než BFS (0.063 s vs 0.003 s na mřížce 100×100). Důvod: naše implementace třídí frontu pomocí sortrows při každém přidání uzlu, což je pomalé. V produkční implementaci by se použila halda (heap), která by A* výrazně zrychlila.

**Co nás překvapilo:**
Se zvyšující se hustotou překážek paradoxně klesal počet expandovaných uzlů -- při 40 % hustotě BFS expandoval jen 192 uzlů vs 360 při 10 %. Důvod: při vysoké hustotě je většina bludiště nedostupná, takže algoritmus prozkoumá méně polí.

**Co bychom zkusili příště:**
Implementovat A* s haldou (priority queue) pro správné měření časové efektivity. Otestovat 8-sousedství místo 4-sousedství -- Chebyshev heuristika by pak byla optimální.

## Použité nástroje

- MATLAB R2024b
- Žádné speciální toolboxy -- pouze základní MATLAB
- LLM: viz `LLM_Audit.pdf`

## Struktura projektu

```
kod/
  baseline.m                  -- výchozí řešení (BFS, 20x20, 20 %)
  bfs.m                       -- BFS algoritmus
  dfs.m                       -- DFS algoritmus
  astar.m                     -- A* algoritmus se 4 heuristikami
  generuj_bludiste.m          -- generátor náhodného bludiště
  experiment_01_hustota.m     -- experiment 1
  experiment_02_velikost.m    -- experiment 2
  experiment_03_heuristiky.m  -- experiment 3
  experiment_04_vzdalenost.m  -- experiment 4
  experiment_05_pruchozost.m  -- experiment 5
  srovnani_vsech.m            -- souhrnný skript
vysledky/
  grafy/                      -- PNG grafy z experimentů
  tabulky/                    -- textové tabulky výsledků
prezentace/
  CV13_Prezentace.pdf         -- prezentace pro CV14
README.md                     -- tento soubor
LLM_Audit.pdf                 -- audit použití LLM nástrojů
```

## Rozdělení práce

- **Moje část**: baseline, experimenty 1 a 2, souhrnný skript
- **Spoluautor**: A* algoritmus, experimenty 3, 4 a 5, README, prezentace

