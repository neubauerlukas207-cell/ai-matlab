load('modely_export.mat');
load('test_vzorky.mat');

modely = {trainedModel1, trainedModel2, trainedModel3};

for i = 1:3
    model = modely{i};

    predikce = model.predictFcn(iris_test);

    spravne = sum(strcmp(predikce, iris_test.Druh));
    accuracy = spravne / height(iris_test) * 100;

    fprintf('Model %d accuracy: %.2f %%\n', i, accuracy);
end