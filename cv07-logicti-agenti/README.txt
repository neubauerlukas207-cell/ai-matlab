README - CV07: Herní agenti v MATLABu

Tento projekt obsahuje dvě samostatné hry s prvky umělé inteligence a logického rozhodování:

Hra 1 – Miny (Minesweeper)
Hra 2 – Wumpus World

Cílem úkolu bylo navrhnout a implementovat jednoduché herní prostředí, umožnit interakci hráče a zároveň vytvořit agenta, který se v prostředí rozhoduje automaticky na základě pravidel nebo znalostní báze.

OBSAH PROJEKTU
Hra 1 – Miny

V této části je vytvořena klasická hra Miny na mřížce 9x9 s 10 minami.
Hra probíhá ve dvou fázích:

hráč hraje ručně pomocí myši
agent poté řeší stejnou mapu automaticky

Agent využívá jednoduchou logickou inferenci:

pokud počet skrytých sousedů odpovídá číslu na poli, jedná se o miny
pokud počet již označených vlajek odpovídá číslu na poli, ostatní sousedé jsou bezpeční
navíc je použito porovnání sousedních množin jako pokročilejší pravidlo

Pokud agent nemá jistý tah, zvolí náhodné pole.

Hra 2 – Wumpus World

Druhá část projektu implementuje prostředí Wumpus World na mapě 5x5.
Stejně jako u Min probíhá hra ve dvou režimech:

hráč ovládá agenta pomocí klávesnice
automatický agent se rozhoduje podle znalostní báze

Agent si ukládá informace o:

navštívených polích
bezpečných polích
možných jamách
možném Wumpusovi

Na základě vjemů (zapach, vanek, lesk) aktualizuje knowledge base a pomocí BFS plánuje další pohyb. Pokud získá zlato, hledá bezpečnou cestu zpět na startovní pole.

POUŽITÉ PRINCIPY

V obou hrách byly využity základní principy z oblasti umělé inteligence:

reprezentace prostředí pomocí matic a struktur
logická inference z dostupných informací
práce s okolím pole a sousedy
BFS (Breadth-First Search) pro hledání cesty
porovnání chování člověka a automatického agenta
CÍL ŘEŠENÍ

Smyslem projektu nebylo vytvořit dokonalého agenta, ale ukázat, jak lze i s relativně jednoduchými pravidly a heuristikami vytvořit systém, který se umí v herním prostředí rozhodovat rozumněji než čistě náhodně.

U hry Miny agent využívá lokální logická pravidla.
U Wumpus World agent pracuje se znalostní bází a postupně si skládá informace o bezpečných a nebezpečných polích.

VÝSTUPY PROJEKTU

Součástí projektu jsou:

zdrojové kódy jednotlivých funkcí
obrázkové výstupy her (.png)
textové logy průběhu (.txt)
porovnání hráče a agenta

Tyto výstupy umožňují sledovat průběh simulace a zároveň doložit funkčnost jednotlivých částí programu.

SHRNUTÍ

Projekt ukazuje rozdíl mezi ručním hraním a automatickým rozhodováním agenta ve dvou různých typech prostředí.
U Min agent využívá pravidla odvozená přímo z čísel na herní ploše.
U Wumpus World agent kombinuje percepci, znalostní bázi a plánování cesty.

Obě části dohromady dobře ukazují, jak lze v MATLABu implementovat jednoduché herní agenty a propojit logiku, reprezentaci stavu a rozhodování v jednom projektu.