% priprava_dat.m
% Nacteni datasetu, kontrola pocetnosti trid, rozdeleni train/test
% Nacist dataset z disku (slozky = labely)
imds = imageDatastore('dataset/', ...
'IncludeSubfolders', true, ...
'LabelSource', 'foldernames');
% Vypis pocetnosti trid
fprintf('=== Info o datasetu ===\n');
fprintf('Celkovy pocet obrazku: %d\n', numel(imds.Files));
tridyCount = countEachLabel(imds);
disp(tridyCount);
% Kontrola: kazda trida alespon 30 obrazku?
if any(tridyCount.Count < 30)
warning('Nektera trida ma mene nez 30 obrazku! Pridejte dalsi.');
end
% Rozdelit 80 % trenink, 20 % test (zachova zastoupeni trid)
[imdsTrain, imdsTest] = splitEachLabel(imds, 0.8, 'randomized');
fprintf('\nTrenovaci set: %d obrazku\n', numel(imdsTrain.Files));
fprintf('Testovaci set: %d obrazku\n', numel(imdsTest.Files));
% Nahled 16 nahodnych obrazku
figure('Position', [100, 100, 900, 700]);
perm = randperm(numel(imdsTrain.Files), 16);
for i = 1:16
subplot(4, 4, i);
img = readimage(imdsTrain, perm(i));
imshow(img);
title(string(imdsTrain.Labels(perm(i))), 'Interpreter', 'none');
end
sgtitle('Nahled trenovacich dat');
saveas(gcf, 'dataset_preview.png');
% Ulozit pro pozdejsi pouziti (transfer_learning.m, vyhodnoceni.m)
save('dataset_prepared.mat', 'imdsTrain', 'imdsTest');
fprintf('\nData ulozena do dataset_prepared.mat\n');