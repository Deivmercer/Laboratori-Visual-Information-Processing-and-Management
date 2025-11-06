im = imread("MaroonBells.jpg");
im = im2double(im);

figure(1)
imshow(im), title("Immagine originale")

figure(2)
im_gaussian = imgaussfilt(im, 15);
imshow(im_gaussian), title("Filtraggio gaussiano")

figure(3)
contatore = 1;
for ii = [0.01 0.05 0.1 0.2 0.5]
    for jj = 1:1:5 % [1 2 3 4 5]
        tic
        im_b = imbilatfilt(im, ii, jj);
        toc
        subplot(5, 5, contatore), imshow(im_b), drawnow
        contatore = contatore + 1;
    end
end

figure(4)
im_b = imbilatfilt(im, 0.1, 15);
imshow(im_b), title("Filtro bilaterale")
