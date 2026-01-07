net = alexnet;
sz = net.Layers(1).InputSize;
analyzeNetwork(net)

%% cut layers
layersTransfer = net.Layers(1:end-3); % <--- TBD
layersTransfer = freezeWeights(layersTransfer); % <--- TBD

%% replace layers
numClasses = 10;
layers = [layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,...
    'BiasLearnRateFactor',20);
    softmaxLayer
    classificationLayer];
% analyzeNetwork(layers)

%% preparazione dati
path_db = '/Users/simone/UNIVERSITA’ BICOCCA Dropbox/simone bianco/Corsi/2024-2025/VIPM/E06-bow/image.orig/';
imds = imageDatastore(path_db);
labels = [];
for ii=1:size(imds.Files,1)
    name=imds.Files{ii,1};
    [p,n,ex]=fileparts(name);
    class=floor(str2double(n)/100);
    labels = [labels; class];
end
labels = categorical(labels);
imds = imageDatastore(path_db, 'labels',labels);

%% divisione train-test
[imdsTrain, imdsTest] = splitEachLabel(imds,0.7,'randomized');

%% data augmentation
pixelRange=[-2 2];
imageAugmenter= imageDataAugmenter(... % <--- TBD
    'RandYReflection',true,...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);

augimdsTrain = augmentedImageDatastore(sz(1:2), imdsTrain, 'DataAugmentation',imageAugmenter);
augimdsTest  = augmentedImageDatastore(sz(1:2), imdsTest);

%% configurazione fine-tuning
options = trainingOptions('sgdm',...
    'MiniBatchSize',10,... % <--- TBD
    'MaxEpochs',6,... % <--- TBD
    'InitialLearnRate',1e-4,... % <--- TBD
    'Shuffle','every-epoch',...
    'ValidationData',augimdsTest,... % <---- TBD!
    'ValidationFrequency',3,...
    'Verbose',false,...
    'Plots','training-progress');

%% training vero e proprio
netTransfer = trainNetwork(augimdsTrain, layers, options);

%% test
tic
[lab_pred_te, scores] = classify(netTransfer, augimdsTest);
toc

%% valutazione performance
acc = numel(find(lab_pred_te==imdsTest.Labels))/numel(lab_pred_te)