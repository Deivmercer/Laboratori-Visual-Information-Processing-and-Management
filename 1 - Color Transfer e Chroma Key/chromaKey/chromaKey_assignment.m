im1 = im2double(imread("godzilla_chromakey/godzilla_1.jpg"));
im2 = im2double(imread("godzilla_chromakey/godzilla_2.jpg"));
S1 = size(im1);

model = [];
crops = [[140 40]; [560 410]; [470 490]];
for ii = 1:size(crops, 1)
    crop = im1(crops(ii, 1):crops(ii, 1) + 10, crops(ii, 2):crops(ii, 2) + 10, :);
    crop = reshape(crop, [], 3);
    crop = unique(crop, "rows");
    model{ii} = crop;
end

T = 0.13; % definizione soglia

im1 = reshape(im1, [], 3);

% calcolo della maschera
M = ones(size(im1));

tic
for ii = 1:size(model, 2)
    tmp = zeros(size(im1));
    d = pdist2(im1, model{ii});
    tmp(min(d, [], 2) > T, :) = 1;
    M = M & tmp;
end

M = double(M);

toc;

M = reshape(M, S1);
im1 = reshape(im1, S1);

figure(1), clf
subplot(1, 3, 1), imshow(im1)
subplot(1, 3, 2), imshow(M)
subplot(1, 3, 3), imshow(im2)

im3 = im1 .* M + im2 .* (1 - M);
figure(2), imshow(im3)
imwrite(im3, "chroma_key.png");
