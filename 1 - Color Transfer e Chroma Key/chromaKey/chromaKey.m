im1 = im2double(imread("godzilla_chromakey/godzilla_1.jpg"));
im2 = im2double(imread("godzilla_chromakey/godzilla_2.jpg"));
S1 = size(im1);

imshow(im1)

%crop = imcrop(im1);
crop = im1(1:10, 1:10, :);
figure(2), imshow(crop)
model = reshape(crop, [], 3); % TBD: definizione modello
model = unique(model, "rows");

im1 = reshape(im1, [], 3);
M = zeros(size(im1));
T = 0.1; % TBD: definizione soglia

% tecnica 1: ciclo for
tic
for ii = 1:size(im1, 1)
    % if any(d < T)
    %     M(ii) = 1;
    % end
    d = repmat(im1(ii, :), size(model, 1), 1) - model; % repmat non è sempre necessario, dipende dalla versione di MATLAB
    d = sqrt(sum(d .^ 2, 2));                          % (in questa non è necessario)
    if min(d) > T
        M(ii, :) = 1;
    end
end
tempoFor = toc;

% tecnica 2: operazioni vettoriali
M = zeros(size(im1));

tic
d = pdist2(im1, model);       % calcola la distanza da tutti gli elementi dell'immagine a tutti gli elementi del modello
M(min(d, [], 2) > T, :) = 1;  % calcoliamo il minimo su ciascuna riga, e se è maggiore della soglia allora metto 1
tempoVec = toc;

[tempoFor tempoVec]

M = reshape(M, S1);
im1 = reshape(im1, S1);

figure(1), clf
subplot(1, 3, 1), imshow(im1)
subplot(1, 3, 2), imshow(M)
subplot(1, 3, 3), imshow(im2)

im3 = im1 .* M + im2 .* (1 - M);
figure(2), imshow(im3)

% TODO: aggiungere altri crop in modo da rendere il modello più grande ed incorporare altri verdi (e.g.: sfondo tappeto)
% Accodare due matrici (le dimensioni devono essere compatibili):
% modello = [crop1; crop2];  % una sopra l'altra
% modello = [crop crop2]     % una di fianco all'altra

% assignment: modificare il modello (eventualmente aggiungendo altri crop) e trovare un buon valore per la soglia in
% modo da ottenere il risultato migliore possibile (senza cercare la perfezione, se avanzano 3 pixel pace)
% consegnare codice ed immagine risultato

% (esperimento facoltativo: color grading. vogliamo portare i colori della prima immagine nella seconda)
