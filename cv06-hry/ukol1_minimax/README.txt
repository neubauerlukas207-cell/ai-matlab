CV06 – Úkol 1: Piškvorky – Minimax s alfa-beta ořezáváním


Popis:
Byla implementována hra piškvorky 3x3, kde hráč hraje proti AI agentovi využívajícímu algoritmus minimax s alfa-beta ořezáváním.

Použité soubory:
- piskvorky_hra.m – herní logika (deska, vítěz, remíza, tahy)
- minimax_agent.m – implementace minimax + alfa-beta
- cv06_uloha1.m – hlavní skript pro hraní hry


Odpovědi:

Je AI neporazitelná?
Ano. Pro piškvorky 3x3 je minimax optimální algoritmus, protože dokáže projít celý herní strom a vždy vybere nejlepší možný tah.

Proč?
Protože hra má malý stavový prostor, takže minimax dokáže vyhodnotit všechny možné kombinace tahů.

Příklad hry bez chyby:
AI vždy blokuje soupeře a snaží se vytvořit vlastní výherní kombinaci. Výsledek je většinou remíza.

Příklad chyby:
Pokud by AI prohrála, znamenalo by to chybu v implementaci (např. špatně MAX/MIN nebo hodnocení).