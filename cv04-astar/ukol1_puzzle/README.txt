CV04 – Informované prohledávání
Úkol 1 – A* na 8-puzzle

Cílem úkolu bylo implementovat algoritmus A* pro řešení
hlavolamu 8-puzzle a porovnat různé heuristiky.

Puzzle je tvořen mřížkou 3x3 s čísly 1–8 a jedním prázdným polem.
V každém kroku lze posunout dílek sousedící s prázdným polem.

Program vygeneruje náhodný řešitelný počáteční stav
a následně jej řeší pomocí algoritmu A*.

Použité heuristiky

1) Manhattan distance  
Součet vzdáleností jednotlivých dílků od jejich cílové pozice.

2) Hamming distance  
Počet dílků, které nejsou na správném místě.

3) Lineární konflikt  
Rozšíření Manhattan distance o konflikty v řádku nebo sloupci.

Program
Skript cv04_uloha1.m:

1) vygeneruje 20 řešitelných instancí
2) každou instanci řeší všemi třemi heuristikami
3) vypíše statistiky:
   - délka řešení
   - počet expandovaných uzlů
   - čas výpočtu
4) vytvoří graf porovnání heuristik

Výstupy
vysledky/porovnani_heuristik_puzzle.png  
vysledky/reseni_puzzle.png

Závěr
Heuristiky Manhattan distance a lineární konflikt
dosahují lepších výsledků než Hamming distance,
protože poskytují přesnější odhad vzdálenosti do cíle.