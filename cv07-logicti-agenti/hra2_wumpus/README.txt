CV07 - HRA 2: Wumpus World


SPUSTENI

V MATLABu prejdete do slozky hra2_wumpus a spustte:
  >> wumpus_hra()       % hrac + agent + porovnani
  nebo
  >> wumpus_simulace()  % stejna hra s podrobnejsim logem

OVLADANI (faze hrace)

  W - pohyb nahoru
  S - pohyb dolu
  A - pohyb doleva
  D - pohyb doprava
  G - sebrat zlato (pokud stojite na nem)
  Q - ukoncit hru

CIL HRY
  Najdi zlato, seberi ho (G) a vrat se na start [1,1].
  Vyhybi se Wumpusovi a jamam.

STRUKTURA SOUBORU

  init_wumpus_world.m  - nahodna inicializace sveta 5x5
  vnimej.m             - senzory: zapach, vanek, lesk, naraz
  aktualizuj_kb.m      - aktualizuje knowledge base podle percepci
  naplanov_akci.m      - BFS planovani: najdi nejblizsi bezpecne nenavstivene pole
  wumpus_hra.m         - hlavni skript: hrac -> agent -> porovnani
  wumpus_simulace.m    - rozsirena simulace s podrobnym logem a PNG vystupy

LOGICKY AGENT

Baze znalostí (KB) obsahuje 4 logicke matice NxN:
  .navstivena    - navstivena pole
  .bezpecna      - overene bezpecna pole
  .mozna_jama    - pole kde by mohla byt jama
  .mozny_wumpus  - pole kde by mohl byt Wumpus

Inference:
  POKUD zapach==false -> vsichni sousede urcite bez Wumpuse
  POKUD vanek==false  -> vsichni sousede urcite bez jamy
  POKUD zapach==true  -> nektery soused mozna Wumpus
  POKUD vanek==true   -> nektery soused mozna jama

Planovani (BFS):
  Agent hleda nejblizsi bezpecne nenavstivene pole.
  Pokud ma zlato, hleda cestu zpet na [1,1].

PRUBEH JEDNE HRY (priklad)

  Krok 1: Pozice [1,1], percept: zapach=0 vanek=0 lesk=0
    KB: bezpecna=[1,2],[2,1], mozny_wumpus=[]
    Akce: DOPRAVA -> nova pozice [1,2]
  Krok 2: Pozice [1,2], percept: zapach=0 vanek=1 lesk=0
    KB: mozna_jama=[1,3] nebo [2,2]
    Akce: DOLU -> [2,2] (bezpecne)
  ...

VYSTUPY

  wumpus_hrac.png            - stav po konci hrace
  wumpus_agent.png           - stav po konci agenta
  wumpus_sim_hrac_start.png  - zacatek simulace
  wumpus_sim_agent_konec.png - konec agenta v simulaci
  wumpus_vystup.txt          - kompletni textovy log
