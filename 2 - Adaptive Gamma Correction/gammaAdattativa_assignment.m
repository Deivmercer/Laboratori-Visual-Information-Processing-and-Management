im = imread("underexposed.jpg");

figure(1)
imshow(im), title("Immagine originale")

im = im2double(im);

% Converto in YCbCr
ycbcr = rgb2ycbcr(im);

% Estraggo il canale Y
Y_channel = ycbcr(:, :, 1);

% Calcolo le maschere
negative = 1 - Y_channel;
mask_gaussian = imgaussfilt(negative, 10);
mask_bilateral = imbilatfilt(negative, 0.5, 1);

figure(2)
subplot(1, 3, 1), imshow(negative), title("Immagine negativa")
subplot(1, 3, 2), imshow(mask_gaussian), title("Filtro gaussiano")
subplot(1, 3, 3), imshow(mask_bilateral), title("Filtro bilaterale")

Y_channel_gaussian = Y_channel .^ (2 .^ (0.5 - mask_gaussian));
Y_channel_bilateral = Y_channel .^ (2 .^ (0.5 - mask_bilateral));

% Sovrascrivo il canale Y
ycbcr_gaussian = ycbcr;
ycbcr_bilateral = ycbcr;
ycbcr_gaussian(:, :, 1) = Y_channel_gaussian;
ycbcr_bilateral(:, :, 1) = Y_channel_bilateral;

% Riconverto in RGB
result_guassian = ycbcr2rgb(ycbcr_gaussian);
result_bilateral = ycbcr2rgb(ycbcr_bilateral);
figure(3), imshow(result_guassian), title("Risultato con filtro gaussiano")
figure(4), imshow(result_bilateral), title("Risultato con filtro bilaterale")

imwrite(result_guassian, "result_gaussian.png")
imwrite(result_bilateral, "result_bilateral.png")
