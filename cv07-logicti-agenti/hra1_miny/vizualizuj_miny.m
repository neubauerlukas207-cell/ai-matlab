function vizualizuj_miny(miny, odhal_vse)
if nargin < 2
    odhal_vse = false;
end

A = 0.45 * ones(miny.N, miny.M);

for i = 1:miny.N
    for j = 1:miny.M
        if miny.odkryto(i,j)
            A(i,j) = 1.0;
        end

        if miny.vlajky(i,j)
            A(i,j) = 0.15;
        end

        if odhal_vse && miny.pole(i,j) == -1
            A(i,j) = 0.15;
        end
    end
end

imagesc(A);
axis equal tight;
set(gca,'XTick',1:miny.M,'YTick',1:miny.N);
grid on;
hold on;

for i = 1:miny.N
    for j = 1:miny.M
        if miny.vlajky(i,j)
            text(j,i,'F', ...
                'Color','r', ...
                'HorizontalAlignment','center', ...
                'FontWeight','bold', ...
                'FontSize',14);

        elseif miny.odkryto(i,j)
            if miny.pole(i,j) > 0
                text(j,i,num2str(miny.pole(i,j)), ...
                    'Color','b', ...
                    'HorizontalAlignment','center', ...
                    'FontWeight','bold', ...
                    'FontSize',13);
            elseif miny.pole(i,j) == -1
                text(j,i,'*', ...
                    'Color','w', ...
                    'HorizontalAlignment','center', ...
                    'FontWeight','bold', ...
                    'FontSize',14);
            end

        elseif odhal_vse && miny.pole(i,j) == -1
            text(j,i,'*', ...
                'Color','w', ...
                'HorizontalAlignment','center', ...
                'FontWeight','bold', ...
                'FontSize',14);
        end
    end
end

hold off;
drawnow;
end