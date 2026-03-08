function [cesta, pocet_kroku, navstivene] = bfs(bludiste, start, cil)
%BFS Prohledavani do sirky (Breadth-First Search) na mrizce.
%   Pouziva frontu (FIFO), vraci NEJKRATSI cestu.
%
%   Vstup:
%     bludiste - n x n (0=volno, 1=prekazka)
%     start    - [r,c]
%     cil      - [r,c]
%   Vystup:
%     cesta       - Kx2 souradnice (vcetne start a cil), [] pokud nenalezena
%     pocet_kroku - pocet expandovanych uzlu
%     navstivene  - logicka matice n x n

    n = size(bludiste, 1);
    navstivene = false(n, n);
    pocet_kroku = 0;

    if bludiste(start(1), start(2)) == 1 || bludiste(cil(1), cil(2)) == 1
        cesta = [];
        return;
    end

    % Fronta (FIFO) pres pole + head/tail
    q = zeros(n*n, 2);
    head = 1; tail = 1;

    % Predchudci pro rekonstrukci cesty
    prev_r = zeros(n, n);
    prev_c = zeros(n, n);

    q(tail,:) = start;
    navstivene(start(1), start(2)) = true;
    prev_r(start(1), start(2)) = -1;
    prev_c(start(1), start(2)) = -1;

    moves = [-1 0; 1 0; 0 -1; 0 1]; % 4-sousedstvi
    found = false;

    while head <= tail
        u = q(head, :);
        head = head + 1;

        pocet_kroku = pocet_kroku + 1;

        if u(1) == cil(1) && u(2) == cil(2)
            found = true;
            break;
        end

        for k = 1:4
            v = u + moves(k,:);
            r = v(1); c = v(2);

            if r >= 1 && r <= n && c >= 1 && c <= n
                if ~navstivene(r,c) && bludiste(r,c) == 0
                    tail = tail + 1;
                    q(tail,:) = [r,c];
                    navstivene(r,c) = true;

                    prev_r(r,c) = u(1);
                    prev_c(r,c) = u(2);
                end
            end
        end
    end

    if ~found
        cesta = [];
        return;
    end

    % Rekonstrukce cesty od cile ke startu
    cesta_rev = zeros(n*n, 2);
    idx = 1;
    cur = cil;
    while true
        cesta_rev(idx,:) = cur;
        idx = idx + 1;

        pr = prev_r(cur(1), cur(2));
        pc = prev_c(cur(1), cur(2));

        if pr == -1 && pc == -1
            break;
        end
        cur = [pr, pc];
    end

    cesta_rev = cesta_rev(1:idx-1, :);
    cesta = flipud(cesta_rev);
end