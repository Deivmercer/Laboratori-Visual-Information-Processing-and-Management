% im1 = imread("colorTransfer/image1.jpg");
% im1 = imread("colorTransfer/image2.jpg");

im1 = imread("assignment/mare_torbido.jpg");
im2 = imread("assignment/mare_limpido.jpg");

figure(1), imshow(im1)
figure(2), imshow(im2)

% conversione a double
im1 = im2double(im1);
im2 = im2double(im2);

% dimensioni delle immagini
S1 = size(im1);
S2 = size(im2);

% conversione in YCbCr
im1_ycbcr = rgb2ycbcr(im1);
im2_ycbcr = rgb2ycbcr(im2);

% estrazione statistiche
im1_ycbcr = reshape(im1_ycbcr, [], 3);
im2_ycbcr = reshape(im2_ycbcr, [], 3);
stat_im1 = mean(im1_ycbcr);
stat_im2 = mean(im2_ycbcr);

% porto la media a 0
im1_ycbcr(:, 2) = im1_ycbcr(:, 2) - stat_im1(2);
im1_ycbcr(:, 3) = im1_ycbcr(:, 3) - stat_im1(3);
mean(im1_ycbcr);

% porto la media al valore che sto cercando
im1_ycbcr(:, 2) = im1_ycbcr(:, 2) + stat_im2(2);
im1_ycbcr(:, 3) = im1_ycbcr(:, 3) + stat_im2(3);
mean(im1_ycbcr);

% ricompongo le immagini
im1_ycbcr = reshape(im1_ycbcr, S1);
im2_ycbcr = reshape(im2_ycbcr, S2);

% le trasformo in RGB
im1_rgb = ycbcr2rgb(im1_ycbcr);
im2_rgb = ycbcr2rgb(im2_ycbcr);

% le trasformo in uint8
im1_rgb = im2uint8(im1_rgb);
im2_rgb = im2uint8(im2_rgb);

figure(3), imshow(im1_rgb)
figure(4), imshow(im2_rgb)

% salvo su disco il risultato
imwrite(im1_rgb, "im1_trasformata.png")
% imwrite(im2_rgb, "im2_trasformata.png")

% funziona bene quando le immagini hanno più o meno lo stesso contenuto
% assignment: trovare un altra coppia di immagini su cui questo color transfer funziona bene
