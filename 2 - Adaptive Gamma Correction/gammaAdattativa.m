im = imread("underexposed.jpg");

figure(1)
imshow(im), title("Immagine originale")

% Gamma correction globale
im = im2double(im);

% Fare la gamma così non è correttissimo, perché effettuiamo una operazione non lineare sui canali colore; la cosa
% corretta da fare sarebbe convertire in YCbCr e lavorare solo sulla luminanza
gamma = 0.4;
im1 = im .^ gamma;

gamma = 4;
im2 = im .^ gamma;

figure(2)
subplot(1, 2, 1), imshow(im1)
subplot(1, 2, 2), imshow(im2)

gamma = 4 * rand(size(im, 1), size(im, 2));
im3 = im .^ gamma;
figure(3), imshow(im3)

%% Gamma correction adattativa
% converto in YCbCr
ycbcr = rgb2ycbcr(im);

% Estraggo il canale Y
canaleY = ycbcr(:, :, 1);

% TBD: faccio le operazioni che devo fare sul canale Y
canaleY = canaleY .^ 0.4; % Esempio solo per poter eseguire il codice; da sostituire

% Calcolo la maschera
mask = 1 - canaleY;
figure, imshow(mask)
mask = imgaussfilt(mask, 10); % Cambiare il parametro di sigma?
figure, imshow(mask)

% nuovoCanaleY = ...

% Sovrascrivo il canale Y
ycbcr(:, :, 1) = nuovoCanaleY;

% Riconverto in RGB
imc = ycbcr2rgb(ycbcr);
figure, imshow(imc)

% assignment: completare
