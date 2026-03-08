# Řešení úlohy převozníka – vlk, koza, zelí

Startovní stav:  
S0 = (0,0,0,0)

Legenda:
0 = levý břeh
1 = pravý břeh
(Převozník, Vlk, Koza, Zelí)

Krok 1  
S0 → S9  
Převozník veze kozu na pravý břeh.

Krok 2  
S9 → S1  
Převozník se vrací sám na levý břeh.

Krok 3  
S1 → S11  
Převozník veze vlka na pravý břeh.

Krok 4  
S11 → S2  
Převozník bere kozu zpět na levý břeh.

Krok 5  
S2 → S14  
Převozník veze zelí na pravý břeh.

Krok 6  
S14 → S4  
Převozník se vrací sám na levý břeh.

Krok 7  
S4 → S15  
Převozník veze kozu na pravý břeh.



Posloupnost stavů:

S0 → S9 → S1 → S11 → S2 → S14 → S4 → S15


Proč neexistuje kratší řešení:

Vlk nesmí zůstat s kozou bez převozníka.  
Koza nesmí zůstat se zelím bez převozníka.  
Člun uveze pouze převozníka a jednu věc.

Proto je nutné převézt kozu dvakrát a převozník se musí dvakrát vrátit sám.  
Minimální počet kroků je tedy 7.