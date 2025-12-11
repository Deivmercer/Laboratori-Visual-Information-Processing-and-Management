net = alexnet;
analyzeNetwork(net)
sz = net.Layers(1).InputSize;

% layer = "pool1";
% layer = "relu4";
layer = "drop7";

%% Estrazione features dal training set
indir = "../Laboratorio 5/image.orig/";
feat_tr = [];
labels_tr = [];
Nim4tr = 70;

tic
for class = 0:9
    for nImage = 0:Nim4tr - 1
        im = double(imread(indir + num2str(class * 100 + nImage) + ".jpg"));
        im = imresize(im, sz(1:2));
        feat_tmp = activations(net, im, layer, "OutputAs", "rows");
        feat_tr = [feat_tr; feat_tmp];
        labels_tr = [labels_tr; class];
    end
end
toc

%% Estrazione features dal test set
indir = "../Laboratorio 5/image.orig/";
feat_te = [];
labels_te = [];
Nim4tr = 70;

tic
for class = 0:9
    for nImage = Nim4tr:99
        im = double(imread(indir + num2str(class * 100 + nImage) + ".jpg"));
        im = imresize(im, sz(1:2));
        feat_tmp = activations(net, im, layer, "OutputAs", "rows");
        feat_te = [feat_te; feat_tmp];
        labels_te = [labels_te; class];
    end
end
toc

%% Normalizzazione features
% Controlliamo la norma prima della normalizzazione
% norm(feat_tr(1, :))
% norm(feat_te(1, :))

% feat_tr = feat_tr ./ sqrt(sum(feat_tr .^ 2, 2));
% feat_te = feat_te ./ sqrt(sum(feat_te .^ 2, 2));

% % Controlliamo la norma dopo la normalizzazione (dovrebbe essere 1)
% norm(feat_tr(1, :))
% norm(feat_te(1, :))

%% Classificazione 1-NN
D = pdist2(feat_te, feat_tr);
[~, idx_pred_te] = min(D, [], 2);
lab_pred_te = labels_tr(idx_pred_te);
acc = numel(find(lab_pred_te == labels_te)) / numel(labels_te)
