README - Ukol 2: Transfer Learning


OBSAH SLOZKY

priprava_dat.m           - Nacteni a rozdeleni datasetu (80/20)
transfer_learning.m      - Uprava site a trenink (SqueezeNet)
vyhodnoceni.m            - Presnost, confusion matrix, chybne klasifikace
analyza_chyb.m           - Detailni analyza chybnych klasifikaci (top-5)
dataset/                 - Vlastni dataset (3 tridy, 30 obrazku/trida)
  bryle/                 - 30 fotek bryli
  kniha/                 - 30 fotek knihy
  pomeranc/              - 30 fotek pomerance
dataset_preview.png      - Nahled trenovacich dat
confusion_matrix.png     - Matice zamen testovacího setu
chybne_klasifikace.png   - Vizualizace chybnych klasifikaci (nevygenerovano - 0 chyb)
netTransfer.mat          - Natrenovana sit
VYSLEDKY.txt             - Interpretace vysledku treninku
README.txt               - Tento soubor

DATASET

Vlastni fotky porizene mobilem
Tridy: bryle, kniha, pomeranc
Celkem: 90 obrazku (30 na tridu)
Rozdeleni: 72 trenovacich / 18 testovacich

VYSLEDKY

Presnost: 100.00 % (18/18)
Cas treninku: 82.27 s (1.37 min)
Hardware: CPU
Sit: SqueezeNet (transfer learning, feature extractor)
