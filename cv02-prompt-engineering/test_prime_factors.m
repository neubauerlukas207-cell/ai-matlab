disp('=== TEST PRIME_FACTORS (assert) ===')

% Priklady ze zadani
assert(isequal(prime_factors(12),  [2 2 3]))
assert(isequal(prime_factors(100), [2 2 5 5]))
assert(isequal(prime_factors(17),  [17]))
assert(isequal(prime_factors(1),   []))

% Dalsi testy
assert(isequal(prime_factors(2),   [2]))
assert(isequal(prime_factors(3),   [3]))
assert(isequal(prime_factors(64),  [2 2 2 2 2 2]))
assert(isequal(prime_factors(45),  [3 3 5]))
assert(isequal(prime_factors(91),  [7 13]))
assert(isequal(prime_factors(999), [3 3 3 37]))

% Edge / divne vstupy
assert(isequal(prime_factors(0),   []))
assert(isequal(prime_factors(-10), []))
assert(isequal(prime_factors(10.5), []))
assert(isequal(prime_factors(NaN), []))
assert(isequal(prime_factors(Inf), []))
assert(isequal(prime_factors([10 12]), []))

disp('VSE OK ✅')