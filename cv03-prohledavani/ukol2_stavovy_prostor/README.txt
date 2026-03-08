CV03 – Úkol 2
Stavový prostor: převozník, vlk, koza a zelí

Popis úlohy

Cílem úkolu je vytvořit orientovaný graf stavového prostoru pro klasický problém
převozníka, který převáží vlka, kozu a zelí přes řeku.

Podmínky úlohy:
- Člun uveze pouze převozníka a jednu věc nebo zvíře.
- Vlk nesmí zůstat s kozou bez převozníka.
 Koza nesmí zůstat se zelím bez převozníka.

Reprezentace stavů

Stav je reprezentován čtveřicí:

(P, V, K, Z)

kde:
P = převozník
V = vlk
K = koza
Z = zelí

Hodnoty:
0 = levý břeh
1 = pravý břeh

Startovní stav:
S0 = (0,0,0,0)

Cílový stav:
S15 = (1,1,1,1)

Soubory

stavy_tabulka.md
obsahuje všech 16 možných stavů a určení, zda jsou platné nebo neplatné.

graf_stavoveho_prostoru.md
obsahuje Mermaid zápis orientovaného grafu stavového prostoru.

reseni_cesty.md
obsahuje dvě optimální cesty ze stavu S0 do stavu S15
a vysvětlení, proč neexistuje kratší řešení.

