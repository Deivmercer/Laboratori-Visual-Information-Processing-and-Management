% lettura immagine
im = imread("RAWinput/IMG_1295ss.tiff");
figure(1), imshow(im)

% conversione in double nel range [0 1]
im = im2double(im);

% AutoExposure (finto)
im = im./max(im(:)); % equivalente a fare max(max(im))
figure(1), clf, imshow(im)

% demosaiking (demosaicing)
% configurazione del sensore (Bayer pattern)
% R G R G
% G B G B
% R G R G
% G B G B
% ----->>> TODO: implementare interpolazione
R = im(1:2:end, 1:2:end);
B = im(2:2:end, 2:2:end);
G = im(1:2:end, 2:2:end);
im = cat(3,R,G,B);
figure(2), imshow(im)

% AWB
% Gray World (GW)
% ----->>> TODO: implementare MaxRGB (WhitePoint WhitePatch)
S = size(im);
im = reshape(im,[],3);
media = mean(im)
coeff = [0.5 0.5 0.5]./media;
% im(:,1) = im(:,1)*coeff(1);
im = im*diag(coeff);
mean(im)
im = reshape(im,S);
figure(3), imshow(im)

% color correction
RGBr = []; % ->>>>TODO: matrice 24x3 da prendere da articolo color checker
% e dividerli per 255

RGBc = []; % matrice 24x3 dei valori RGB camera della color checker
% im_crop = imcrop(im);
% im_crop = imresize(im_crop,5);
% figure(4), imshow(im_crop)
% [x,y] = ginput(24);
% save coordinateCC x y
% imwrite(im2double(im_crop),'crop_del_cc.png');
load coordinateCC.mat
im_crop = im2double(imread('crop_del_cc.png'));

x = round(x);
y = round(y);
R = 2; % dimensione intorno su cui fare la media
for ii=1:24
    crop = im_crop(y(ii)-R:y(ii)+R, x(ii)-R:x(ii)+R, :);
    crop = reshape(crop, [], 3);
    RGBc = [RGBc; mean(crop)];
end

M = inv(RGBc'*RGBc) * (RGBc'*RGBr); % pseudo-inversa

im = reshape(im, [], 3);
im = im * M;
im = reshape(im, S);

% enhancement
Sfactor = 1; % -----> TODO: modificare fattore per aumento saturazione
im = rgb2hsv(im); % conversione in HSV
im(:,:,2) = im(:,:,2)*Sfactor; % modifica Saturazione
% opzionale: aumento contrasto
im = hsv2rgb(im); % conversione in RGB

% compressione e salvataggio
% im = imresize(im, 0.5);
imwrite(im2uint8(im),'immagine_raw_to_srgb.jpg');


