net = alexnet;
analyzeNetwork(net)

%%
sz = net.Layers(1).InputSize;
layer = 'conv1';

%%
im = imread('peppers.png');
imshow(im)

im = double(imresize(im,sz(1:2)));
feat = activations(net, im, layer);
feat = activations(net, im, layer, 'OutputAs','rows');


figure(1), clf
for ii=1:25
    subplot(5, 5, ii)
    imagesc(feat(:,:,ii)), colormap gray, drawnow
end

%% estrazione features sul training set

layer = 'relu7';

indir = '/Users/simone/UNIVERSITA’ BICOCCA Dropbox/simone bianco/Corsi/2024-2025/VIPM/E06-bow/image.orig/';

feat_tr = [];
labels_tr = [];
Nim4tr = 70;

tic
for class=0:9
    for nimage=0:Nim4tr-1
        disp([num2str(class) ' ' num2str(nimage)])
        im = double( imread([indir num2str(class*100+nimage) '.jpg']));
        im = imresize(im, sz(1:2));
        feat_tmp = activations(net, im, layer, 'OutputAs','rows');
        feat_tr = [feat_tr; feat_tmp];
        labels_tr = [labels_tr; class];
    end
end
toc

%% estrazione features sul test set

feat_te = [];
labels_te = [];

tic
for class=0:9
    for nimage=Nim4tr:99
        disp([num2str(class) ' ' num2str(nimage)])
        im = double( imread([indir num2str(class*100+nimage) '.jpg']));
        im = imresize(im, sz(1:2));
        feat_tmp = activations(net, im, layer, 'OutputAs','rows');
        feat_te = [feat_te; feat_tmp];
        labels_te = [labels_te; class];
    end
end
toc

%% normalizzazione features
% relu7 non normalizzato: 0.8967
% relu7 normalizzato    : 0.9433

norm(feat_tr(1,:))
norm(feat_te(1,:))

feat_tr = feat_tr./sqrt(sum(feat_tr.^2,2));
feat_te = feat_te./sqrt(sum(feat_te.^2,2));

norm(feat_tr(1,:))
norm(feat_te(1,:))

%% classificazione 1-NN
D = pdist2(feat_te, feat_tr);
[dummy, idx_pred_te]=min(D,[],2);
lab_pred_te = labels_tr(idx_pred_te);
acc = numel(find(lab_pred_te==labels_te))/numel(labels_te)













