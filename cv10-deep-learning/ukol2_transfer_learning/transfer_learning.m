% transfer_learning.m
% Transfer Learning: prizpusobeni SqueezeNet na vlastni dataset

% --- Nacteni pripravenych dat ---
load('dataset_prepared.mat');

% --- Nacteni predtrenovane site ---
net = squeezenet;

% --- Uprava posledni vrstvy ---
% SqueezeNet posledni vrstvy:
% 'conv10' (Convolution 1x1, 1000 filtru)
% 'relu_conv10' (ReLU)
% 'pool10' (Global Average Pooling)
% 'prob' (Softmax)
% 'ClassificationLayer_predictions' (Classification output)

numClasses = numel(categories(imdsTrain.Labels));
fprintf('Pocet trid v nasem datasetu: %d\n', numClasses);

lgraph = layerGraph(net);

newConvLayer = convolution2dLayer([1 1], numClasses, ...
    'Name', 'conv_new', ...
    'WeightLearnRateFactor', 10, ...
    'BiasLearnRateFactor', 10);
lgraph = replaceLayer(lgraph, 'conv10', newConvLayer);

newClassLayer = classificationLayer('Name', 'classoutput_new');
lgraph = replaceLayer(lgraph, 'ClassificationLayer_predictions', newClassLayer);

% --- Data augmentation + resize ---
inputSize = net.Layers(1).InputSize(1:2);
imageAugmenter = imageDataAugmenter( ...
    'RandRotation', [-15, 15], ...
    'RandXReflection', true, ...
    'RandXTranslation', [-10, 10], ...
    'RandYTranslation', [-10, 10]);

augimdsTrain = augmentedImageDatastore(inputSize, imdsTrain, ...
    'DataAugmentation', imageAugmenter);
augimdsTest = augmentedImageDatastore(inputSize, imdsTest);

% --- Nastaveni treninku ---
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 16, ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', augimdsTest, ...
    'ValidationFrequency', 10, ...
    'Verbose', false, ...
    'Plots', 'training-progress', ...
    'ExecutionEnvironment', 'auto');

% --- Trenink ---
fprintf('\n=== Zacatek treninku (muze trvat nekolik minut) ===\n');
tic;
netTransfer = trainNetwork(augimdsTrain, lgraph, options);
cas_trenink = toc;
fprintf('Trenink dokoncen za %.2f s (%.2f min)\n', cas_trenink, cas_trenink/60);

% --- Ulozeni site ---
save('netTransfer.mat', 'netTransfer');
fprintf('Sit ulozena do netTransfer.mat\n');