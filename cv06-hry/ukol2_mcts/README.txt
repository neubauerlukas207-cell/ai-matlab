CV06 – Úkol 2: Piškvorky – MCTS


Popis:
Byla implementována hra piškvorky 3x3, kde AI agent využívá Monte Carlo Tree Search (MCTS).

Použité soubory:
- mcts_agent.m – implementace MCTS (selekce, expanze, simulace, zpětná propagace)
- cv06_uloha2.m – hra člověk vs AI
- cv06_porovnani.m – porovnání minimax vs MCTS

Experiment:
Bylo odehráno 50 her mezi Minimax a MCTS při různém počtu simulací (100, 500, 1000, 5000).

Výsledky:
- 100 simulací: MCTS občas prohrává
- 500 simulací: MCTS hraje velmi dobře
- 1000 simulací: téměř neporazitelný
- 5000 simulací: prakticky vždy remíza

Odpovědi:

Kolik simulací je potřeba?
Přibližně 1000 simulací pro dosažení velmi dobrého výkonu.

Je MCTS srovnatelný s minimax?
Ano, ale pouze s dostatečným počtem simulací. Minimax je ale stále přesnější.

Výhody MCTS:
- neprohledává celý strom
- škáluje na větší hry
- flexibilní

Nevýhody MCTS:
- není deterministický
- potřebuje hodně simulací
- může dělat chyby při malém počtu simulací

Příklad bez chyby:
Při 1000+ simulacích MCTS většinou dosáhne remízy proti minimaxu.

Příklad chyby:
Při malém počtu simulací (např. 100) může MCTS udělat špatný tah a prohrát.