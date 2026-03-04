function [cesta, pocet_kroku, navstivene] = dfs(bludiste, start, cil)

[n,m] = size(bludiste);
navstivene = false(n,m);
pocet_kroku = 0;
cesta = [];

if bludiste(start(1),start(2)) == 1 || bludiste(cil(1),cil(2)) == 1
    return;
end

parent = zeros(n,m,2);

stack = zeros(n*m,2);
top = 1;
stack(top,:) = start;

navstivene(start(1),start(2)) = true;

% POŘADÍ SMĚRŮ (bias k cíli): dolů, doprava, doleva, nahoru
dirs = [ 1 0; 0 1; 0 -1; -1 0 ];

found = false;

while top > 0
    cur = stack(top,:); top = top - 1;
    r = cur(1); c = cur(2);
    pocet_kroku = pocet_kroku + 1;

    if r == cil(1) && c == cil(2)
        found = true;
        break;
    end

    % push v opačném pořadí kvůli LIFO
    for i = 4:-1:1
        rr = r + dirs(i,1);
        cc = c + dirs(i,2);

        if rr < 1 || rr > n || cc < 1 || cc > m
            continue;
        end
        if bludiste(rr,cc) == 1
            continue;
        end
        if navstivene(rr,cc)
            continue;
        end

        navstivene(rr,cc) = true;
        parent(rr,cc,1) = r;
        parent(rr,cc,2) = c;

        top = top + 1;
        stack(top,:) = [rr cc];
    end
end

if ~found
    return;
end

% rekonstrukce cesty
r = cil(1); c = cil(2);
path = [r c];

while ~(r == start(1) && c == start(2))
    pr = parent(r,c,1);
    pc = parent(r,c,2);

    if pr == 0 && pc == 0
        cesta = [];
        return;
    end

    r = pr; c = pc;
    path = [r c; path]; %#ok<AGROW>
end

cesta = path;
end