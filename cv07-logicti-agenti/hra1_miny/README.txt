CV07 - HRA 1: Miny (Minesweeper)

SPUSTENI

V MATLABu prejdete do slozky hra1_miny a spustte:
  >> miny_hra()

Hra se otevre ve dvou fazich:
  1. Faze hrace - klikejte mysi na mrizku
  2. Faze agenta - bezi automaticky po ukonceni hrace

OVLADANI (faze hrace)

  Levy klik  - odkrytí pole
  Pravy klik - umisteni/odebrani vlajky (F)
  Zavrete figure - ukonceni hrace (agent pokracuje)

STRUKTURA SOUBORU

  generuj_miny.m    - generuje minove pole NxM s nahodne rozmistenymi minami
  vizualizuj_miny.m - vykresluje aktualni stav pole (imagesc + text)
  odkryj_pole.m     - odkryva pole, spousti BFS flood-fill pro prazdne oblasti
  miny_agent.m      - logicky agent (Pravidlo 1, 2, 3 - pokrocila inference)
  miny_hra.m        - hlavni skript: hrac -> agent -> porovnani

LOGICKY AGENT

Agent opakovaně (fixpoint) prochazi odkryta pole a aplikuje:
  Pravidlo 1: cislo == pocet skrytych sousedu -> vsichni jsou miny
  Pravidlo 2: cislo == pocet vlajek -> ostatni jsou bezpecni
  Pravidlo 3: porovnani par sousedu - pokrocila inference

Kdyz agent nema jisty tah, hraje nahodne.

PRUBEH JEDNE HRY (priklad)

  Tah 1: Hrac kliknul na [5,5] - odkryto pole, hodnota=2
  Tah 2: Hrac kliknul na [3,3] - flood-fill, odkryto 12 poli
  ...
  Agent: oznacil 8 min vlajkami, odkryl 62 bezpecnych poli
  Vysledek: Hrac prohra (sipnul na minu), Agent vyhra

VYSTUPY

  screenshot_zacatek.png - zacatek hry (prazdna mrizka)
  screenshot_prubeh.png  - prubeh po 3. tahu hrace
  screenshot_konec.png   - konec hrace (odhalene miny)
  agent_konec.png        - konec agenta
  vystup.txt             - kompletni textovy log (diary)
