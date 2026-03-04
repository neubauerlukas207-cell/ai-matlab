README – CV03: Prohledávání stavového prostoru

Tento úkol řeší porovnání dvou neinformovaných algoritmů prohledávání – BFS (Breadth-First Search) a DFS (Depth-First Search) – na náhodně generovaných bludištích.

Program nejdřív vygeneruje bludiště o velikosti 20x20 s přibližně 15 % překážek. Start je v levém horním rohu [1,1] a cíl v pravém dolním rohu [20,20]. Pokud je bludiště neprůchozí, zahodí se a generuje se nové, dokud není k dispozici 100 průchozích bludišť.

Na každém bludišti se spustí oba algoritmy:

* BFS používá frontu (FIFO) a vždy najde nejkratší cestu.
* DFS používá zásobník (LIFO) a může najít delší cestu.

Program ukládá:

* délku nalezené cesty
* počet kroků (kolik uzlů algoritmus prozkoumal)

Na konci se vypíšou základní statistiky (průměr, minimum a maximum) a vytvoří se dva grafy:

1. porovnání délky cesty a počtu kroků pro prvních 5 bludišť
2. vizualizace jednoho bludiště s nalezenou cestou pro BFS a DFS

Spuštění:
Stačí spustit skript `cv03_uloha1.m` v MATLABu. Skript automaticky vygeneruje bludiště, provede testy a uloží grafy do složky `vysledky`.
