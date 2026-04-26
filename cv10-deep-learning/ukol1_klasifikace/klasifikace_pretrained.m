% klasifikace_pretrained.m
% Klasifikace 10 obrazku pomoci predtrenovane site

clear; clc;

% --- Nacteni site ---
net = squeezenet;

fprintf('=== Pouzita sit: %s ===\n', class(net));
fprintf('Pocet vrstev: %d\n', numel(net.Layers));
fprintf('Velikost vstupu: %d x %d x %d\n', net.Layers(1).InputSize);

% --- Slozka s obrazky ---
img_folder = 'obrazky_test/';
img_files = dir(fullfile(img_folder, '*.jpg'));

assert(numel(img_files) >= 10, 'Musi byt alespon 10 obrazku');

inputSize = net.Layers(1).InputSize(1:2);

% --- Vizualizace ---
figure('Position', [100, 100, 1400, 600]);
casy = zeros(numel(img_files), 1);

for i = 1:numel(img_files)
    img_path = fullfile(img_folder, img_files(i).name);

    try
        img = imread(img_path);

        % --- Oprava kanalu ---
        if ndims(img) == 2
            img = cat(3, img, img, img);
        end

        if size(img, 3) > 3
            img = img(:, :, 1:3);
        end

        % --- Resize ---
        img_resized = imresize(img, inputSize);

        % Kontrola po resize
        if ndims(img_resized) == 2
            img_resized = cat(3, img_resized, img_resized, img_resized);
        end

        if size(img_resized, 3) > 3
            img_resized = img_resized(:, :, 1:3);
        end

        % --- Klasifikace ---
        tic;
        [label, scores] = classify(net, img_resized);
        casy(i) = toc;

        % --- Top-5 ---
        [top5_scores, top5_idx] = maxk(scores, 5);
        top5_labels = net.Layers(end).Classes(top5_idx);

        % --- Vykresleni ---
        subplot(2, 5, i);
        imshow(img_resized);
        title(sprintf('%s\n%.1f%% (%.3f s)', ...
            char(label), max(scores)*100, casy(i)), ...
            'Interpreter', 'none', 'FontSize', 9);

        % --- Konzole ---
        fprintf('\n--- Obrazek %d: %s ---\n', i, img_files(i).name);
        fprintf('Top 1: %s (%.2f %%)\n', char(label), max(scores)*100);

        fprintf('Top 5:\n');
        for j = 1:5
            fprintf(' %d. %-30s %.2f %%\n', ...
                j, char(top5_labels(j)), top5_scores(j)*100);
        end

        fprintf('Cas klasifikace: %.4f s\n', casy(i));

    catch ME
        % --- Kdyz je chyba ---
        fprintf('\n--- Obrazek %d: %s ---\n', i, img_files(i).name);
        fprintf('CHYBA: %s\n', ME.message);

        subplot(2, 5, i);
        axis off;
        title(sprintf('%s\nCHYBA', img_files(i).name), ...
            'Interpreter', 'none', 'FontSize', 9);
    end
end

% --- Shrnutí ---
fprintf('\n=== Prumerny cas klasifikace: %.4f s ===\n', mean(casy));

sgtitle(sprintf('Klasifikace predtrenovanou siti (%s)', class(net)));
saveas(gcf, 'klasifikace_vysledky.png');

fprintf('Vizualizace ulozena do klasifikace_vysledky.png\n');
