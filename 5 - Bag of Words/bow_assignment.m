disp("Creazione griglia")
pointPositions = [];
featStep = 15;
imsize = 750;

tic
for ii = featStep:featStep:imsize - featStep
    for jj = featStep:featStep:imsize - featStep
        pointPositions = [pointPositions; ii jj];
    end
end
toc

%% Estrazione features per il training
disp("Estrazione features")

Nim4training = 60;
Nim4validation = 10;

features = [];
labels = [];

tic
for class = 0:9
    for nimage = 0:Nim4training - 1
        im = im2double(imread(['./image.orig/' num2str(100 * class + nimage) '.jpg']));
        im = imresize(im, [imsize, imsize]);
        im = rgb2gray(im);
        [imfeatures, ~] = extractFeatures(im, pointPositions, "Method", "SURF");
        features = [features; imfeatures];
        labels = [labels; repmat(class, size(imfeatures, 1), 1) repmat(nimage, size(imfeatures, 1), 1)];
    end
end
toc

%% Creazione del vocabolario
disp("kmeans")
K = 150;
tic
[IDX, C] = kmeans(features, K);
toc

%% Istogrammi di training
disp("Rappresentazione BOW training")
BOW_tr = [];
labels_tr = [];

tic
for class=0:9
    for nimage=0:Nim4training - 1
        u = find(labels(:, 1) == class & labels(:, 2) == nimage);
        imfeaturesIDX = IDX(u);
        H = hist(imfeaturesIDX, 1:K);
        H = H ./ sum(H);
        BOW_tr = [BOW_tr; H];
        labels_tr = [labels_tr; class];
    end
end
toc

%% Istogrammi di validazione
disp("Rappresentazione BOW validazione")
BOW_va = [];
labels_va = [];

tic
for class = 0:9
    for nimage = Nim4training:Nim4training + Nim4validation - 1
        im = im2double(imread(['./image.orig/' num2str(100 * class + nimage) '.jpg']));
        im = imresize(im, [imsize, imsize]);
        im = rgb2gray(im);
        [imfeatures, ~] = extractFeatures(im, pointPositions, "Method", "SURF");

        D = pdist2(imfeatures, C);
        [~, words] = min(D, [], 2);

        H = hist(words, 1:K);
        H = H ./ sum(H);

        BOW_va = [BOW_va; H];
        labels_va = [labels_va; class];
    end
end
toc

%% Classificatore
disp("Training modello")
maxK = 10;
validationAccuracy = zeros(length(kValues), 1);

for i = 1:maxK
    tmpModel = fitcknn(BOW_tr, labels_tr, NumNeighbors=i);
    predictedLabels = predict(tmpModel, BOW_va);
    validationAccuracy(i) = sum(predictedLabels == labels_va) / numel(labels_va);
end
[~, bestKIndex] = max(validationAccuracy);
bestK = kValues(bestKIndex);
model = fitcknn(BOW_tr, labels_tr, NumNeighbors=bestK);

%% Istrogrammi di test
disp("Rappresentazione BOW test")
BOW_te = [];
labels_te = [];

tic
for class = 0:9
    for nimage = Nim4training + Nim4validation:99
        im = im2double(imread(['./image.orig/' num2str(100 * class + nimage) '.jpg']));
        im = imresize(im, [imsize, imsize]);
        im = rgb2gray(im);
        [imfeatures, ~] = extractFeatures(im, pointPositions, "Method", "SURF");

        D = pdist2(imfeatures, C);
        [~, words] = min(D, [], 2);

        H = hist(words, 1:K);
        H = H ./ sum(H);

        BOW_te = [BOW_te; H];
        labels_te = [labels_te; class];
    end
end
toc

%% Classificazione del test
disp("Classificazione test set")
predicted_class = predict(model, BOW_te);

%% Misurazione delle performance
CM = confusionmat(labels_te, predicted_class);
CM = CM ./ repmat(sum(CM, 2), 1, size(CM, 2));
CM
accuracy = mean(diag(CM));

figure(1), clf
imagesc(CM), colorbar
title(["Accuracy: " num2str(accuracy)])
