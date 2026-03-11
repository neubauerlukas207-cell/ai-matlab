CV04 – Informované prohledávání
Úkol 2 – Dijkstra vs Greedy vs A*

Cílem úkolu bylo porovnat tři algoritmy pro hledání
nejkratší cesty v grafu.

Použitá mapa obsahuje několik měst propojených silnicemi.
Každá silnice má přiřazenou vzdálenost v kilometrech.

Startovní město je Alpov a cílové město je Hradec.

Použité algoritmy-
Dijkstra
Používá skutečnou vzdálenost od startu g(n)
a vždy najde optimální cestu.

Greedy Best-First Search
Používá pouze heuristiku h(n),
tedy odhad vzdálenosti do cíle.

A*
Používá kombinaci obou hodnot:

f(n) = g(n) + h(n)

Při správné heuristice najde optimální řešení.

Výsledek

Dijkstra i A* našly stejnou nejkratší cestu:

Alpov → Cedrov → Edlov → Filipov → Hradec

Celková délka této cesty je 350 km.

Greedy algoritmus zvolil cestu:

Alpov → Borkov → Dolany → Grunov → Hradec

Tato cesta má délku 440 km,
protože algoritmus vybírá pouze podle heuristiky.

Výstup

Program vytvoří obrázek:

vysledky/mapa_porovnani.png

který zobrazuje mapu měst a cesty nalezené jednotlivými algoritmy.

Závěr

Dijkstra i A* našly optimální řešení.
Greedy algoritmus může být rychlejší,
ale nemusí vždy najít nejkratší cestu.