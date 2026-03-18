CV05 - Ukol 1 (gradient descent)

Soubory:
- data_a_ztrata.m
- gradient_descent.m
- cv05_uloha1.m
- vysledky/konvergence_lr.png
- vysledky/regrese_primka.png
- README.txt

Jak spustit:
Spusti se soubor cv05_uloha1.m

Testovane hodnoty alpha:
0.001, 0.01, 0.05, 0.5

Vysledky:
Alpha		 a		 b		 Finalni MSE	 Iteraci do konvergence
0.001		 1.974071	 0.189628	 0.019558	 78
0.010		 1.998821	 0.017323	 0.012900	 32
0.050		 NaN	 NaN	 NaN	 1000
0.500		 NaN	 NaN	 NaN	 1000

Analyticke reseni:
a_exact = 1.999394
b_exact = 0.013333

Odpovedi:
1) Mala alpha vede k pomale, ale stabilni konvergenci. Vhodna alpha vede k rychlejsi konvergenci. Velka alpha zpusobi nestabilitu nebo divergenci.
2) Divergence se objevuje u vetsich hodnot alpha, typicky od 0.05 vyse, protoze krok je moc velky a algoritmus prestreluje minimum.
3) alpha = 0.001 potrebuje vice iteraci nez alpha = 0.01.
4) Priblizne maximalni stabilni alpha je kolem 0.02 az 0.03.

Poznamka:
V grafu regrese je vykresleno vice primek z ruznych iteraci, aby bylo videt, jak se primka postupne priblizuje k vyslednemu reseni.
