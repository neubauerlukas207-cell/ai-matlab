function vizualizuj_miny(miny, odhal_vse)
% vizualizuj_miny - zobrazi aktualni stav minoveho pole

if nargin < 2
    odhal_vse = false;
end

A = 0.3 * ones(miny.N, miny.M);

for i = 1:miny.N
    for j = 1:miny.M
        if miny.odkryto(i, j)
            A(i, j) = 1.0;
        end
        if miny.vlajky(i, j)
            A(i, j) = 0.1;
        end
        if odhal_vse && miny.pole(i, j) == -1 && ~miny.vlajky(i, j)
            A(i, j) = 0.0;
        end
    end
end

imagesc(A);
colormap(gray);
axis equal tight;
set(gca, 'XTick', 1:miny.M, 'YTick', 1:miny.N);
grid on;
hold on;

for i = 1:miny.N
    for j = 1:miny.M
        if miny.vlajky(i, j)
            text(j, i, 'F', ...
                'Color', 'r', ...
                'HorizontalAlignment', 'center', ...
                'FontWeight', 'bold', ...
                'FontSize', 14);

        elseif miny.odkryto(i, j)
            if miny.pole(i, j) > 0
                barvy = {'b','g','r','m','k','c','k','k'};
                b = barvy{min(miny.pole(i, j), 8)};
                text(j, i, num2str(miny.pole(i, j)), ...
                    'Color', b, ...
                    'HorizontalAlignment', 'center', ...
                    'FontWeight', 'bold', ...
                    'FontSize', 13);

            elseif miny.pole(i, j) == -1
                text(j, i, '*', ...
                    'Color', 'w', ...
                    'HorizontalAlignment', 'center', ...
                    'FontWeight', 'bold', ...
                    'FontSize', 14);
            end

        elseif odhal_vse && miny.pole(i, j) == -1
            text(j, i, '*', ...
                'Color', 'w', ...
                'HorizontalAlignment', 'center', ...
                'FontWeight', 'bold', ...
                'FontSize', 14);
        end
    end
end

hold off;
drawnow;
end