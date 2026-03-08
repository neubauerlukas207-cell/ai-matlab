 Stavový prostor – převozník, vlk, koza a zelí

Legenda:
- 0 = levý břeh
- 1 = pravý břeh
- stav zapisujeme jako (P, V, K, Z)
  - P = převozník
  - V = vlk
  - K = koza
  - Z = zelí

Stav je neplatný, pokud:
- vlk zůstane s kozou bez převozníka
- nebo koza zůstane se zelím bez převozníka

| Stav | (P,V,K,Z) | Platný? | Důvod |
|------|-----------|---------|-------|
| S0   | (0,0,0,0) | ANO | start |
| S1   | (0,0,0,1) | ANO | vlevo jsou P, V, K; vpravo je Z |
| S2   | (0,0,1,0) | ANO | vlevo jsou P, V, Z; vpravo je K |
| S3   | (0,0,1,1) | NE  | koza a zelí jsou spolu bez převozníka |
| S4   | (0,1,0,0) | ANO | vlevo jsou P, K, Z; vpravo je V |
| S5   | (0,1,0,1) | ANO | vlevo jsou P, K; vpravo jsou V, Z |
| S6   | (0,1,1,0) | NE  | vlk a koza jsou spolu bez převozníka |
| S7   | (0,1,1,1) | NE  | vlk a koza jsou spolu bez převozníka |
| S8   | (1,0,0,0) | NE  | vlk a koza jsou spolu bez převozníka |
| S9   | (1,0,0,1) | NE  | vlk a koza jsou spolu bez převozníka |
| S10  | (1,0,1,0) | ANO | vpravo jsou P, K; vlevo jsou V, Z |
| S11  | (1,0,1,1) | ANO | vpravo jsou P, K, Z; vlevo je V |
| S12  | (1,1,0,0) | NE  | koza a zelí jsou spolu bez převozníka |
| S13  | (1,1,0,1) | ANO | vpravo jsou P, V, Z; vlevo je K |
| S14  | (1,1,1,0) | ANO | vpravo jsou P, V, K; vlevo je Z |
| S15  | (1,1,1,1) | ANO | cílový stav |