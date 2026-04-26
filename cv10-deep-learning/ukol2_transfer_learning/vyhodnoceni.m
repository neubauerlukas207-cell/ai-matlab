% vyhodnoceni.m
% Vyhodnoceni natrenovane site na testovacim setu

% --- Nacteni site a dat ---
load('netTransfer.mat');
load('dataset_prepared.mat');
inputSize = netTransfer.Layers(1).InputSize(1:2);
augimdsTest = augmentedImageDatastore(inputSize, imdsTest);

% --- Predikce ---
fprintf('=== Vyhodnoceni na testovacim setu ===\n');
tic;
YPred = classify(netTransfer, augimdsTest);
cas_predikce = toc;
YTest = imdsTest.Labels;

% --- Celkova presnost ---
accuracy = mean(YPred == YTest);
fprintf('Presnost: %.2f %% (%d / %d)\n', accuracy*100, sum(YPred == YTest), numel(YTest));
fprintf('Prumerny cas klasifikace: %.4f s/obrazek\n', cas_predikce / numel(YTest));

% --- Confusion matrix ---
figure('Position', [100, 100, 700, 600]);
cm = confusionchart(YTest, YPred);
cm.Title = 'Matice zamen - Testovaci set';
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';
saveas(gcf, 'confusion_matrix.png');

% --- Per-class accuracy ---
tridy = categories(YTest);
fprintf('\n--- Presnost pro jednotlive tridy ---\n');
for i = 1:numel(tridy)
    idx = YTest == tridy{i};
    acc_i = mean(YPred(idx) == YTest(idx));
    fprintf('  %-20s %.2f %% (%d/%d)\n', tridy{i}, acc_i*100, sum(YPred(idx) == YTest(idx)), sum(idx));
end

% --- Vizualizace chybnych klasifikaci ---
spatne_idx = find(YPred ~= YTest);
fprintf('\nPocet spatne klasifikovanych obrazku: %d\n', numel(spatne_idx));
if ~isempty(spatne_idx)
    figure('Position', [100, 100, 1000, 700]);
    pocet_zobraz = min(9, numel(spatne_idx));
    for i = 1:pocet_zobraz
        idx = spatne_idx(i);
        img = readimage(imdsTest, idx);
        subplot(3, 3, i);
        imshow(img);
        title(sprintf('Skutecna: %s\nPredikce: %s', char(YTest(idx)), char(YPred(idx))), 'Interpreter', 'none');
    end
    sgtitle('Chybne klasifikovane obrazky');
    saveas(gcf, 'chybne_klasifikace.png');
end