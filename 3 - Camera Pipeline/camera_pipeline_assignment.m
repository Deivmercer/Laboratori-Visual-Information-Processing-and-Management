im = imread("RAWinput/IMG_1295ss.tiff");
im = im2double(im);

%% Auto Exposure (finto)
im = im ./ max(im(:));
figure(1), clf, imshow(im)

%% Demosaiking
S = size(im);
demosaiced = zeros(S(1), S(2), 3);
demosaiced(1:2:end, 1:2:end, 1) = im(1:2:end, 1:2:end);
demosaiced(1:2:end, 2:2:end, 2) = im(1:2:end, 2:2:end);
demosaiced(2:2:end, 1:2:end, 2) = im(2:2:end, 1:2:end);
demosaiced(2:2:end, 2:2:end, 3) = im(2:2:end, 2:2:end);

for i = 2:S(1) - 1
    for j = 2:S(2) - 1
        if demosaiced(i, j, 1) ~= 0
            demosaiced(i, j, 2) = (im(i - 1, j) + im(i + 1, j) + im(i, j - 1) + im(i, j + 1)) / 4;
            demosaiced(i, j, 3) = (im(i - 1, j - 1) + im(i - 1, j + 1) + im(i + 1, j - 1) + im(i + 1, j + 1)) / 4;
        elseif demosaiced(i, j, 2) ~= 0
            if mod(i, 2) == 0
                demosaiced(i, j, 1) = (im(i - 1, j) + im(i + 1, j)) / 2;
                demosaiced(i, j, 3) = (im(i, j - 1) + im(i, j + 1)) / 2;
            else
                demosaiced(i, j, 1) = (im(i, j - 1) + im(i, j + 1)) / 2;
                demosaiced(i, j, 3) = (im(i - 1, j) + im(i + 1, j)) / 2;
            end
        else
            demosaiced(i, j, 1) = (im(i - 1, j - 1) + im(i - 1, j + 1) + im(i + 1, j - 1) + im(i + 1, j + 1)) / 4;
            demosaiced(i, j, 2) = (im(i - 1, j) + im(i + 1, j) + im(i, j - 1) + im(i, j + 1)) / 4;
        end
    end
end

im = demosaiced(2:end - 1, 2:end - 1, :);
figure(2), imshow(im)

%% Automatic White Balancing
S = size(im);
im = reshape(im, [], 3);
maxRGB = max(im);
scaleFactor = 1 ./ maxRGB;
im = im .* scaleFactor;
im = reshape(im, S);
figure(3), imshow(im)

%% color correction
RGBr = [
    116, 81, 67;
    199, 147, 129;
    91, 122, 156;
    90, 108, 64;
    130, 128, 176;
    92, 190, 172;
    224, 124, 47;
    68, 91, 170;
    198, 82, 97;
    94, 58, 106;
    159, 189, 63;
    230, 162, 39;
    35, 63, 147;
    67, 149, 74;
    180, 49, 57;
    238, 198, 20;
    193, 84, 151;
    0, 136, 170;
    245, 245, 243;
    200, 202, 202;
    161, 163, 163;
    121, 121, 122;
    82, 84, 86;
    49, 49, 51
];
RGBr = RGBr / 255;

% [im_crop, rect] = imcrop(im);
% im_crop = imresize(im_crop, 5);
% figure(4), imshow(im_crop)
% [x, y] = ginput(24); % graphical input di 24 click
% save coordinateCC x y rect

RGBc = [];
load coordinateCC.mat
im_crop = imcrop(im, rect);
im_crop = imresize(im_crop, 5);
figure(4)
imshow(im_crop), hold on
x = round(x);
y = round(y);
R = 2;
for ii = 1:24
    plot(x(ii), y(ii), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
    crop = im_crop(y(ii) - R:y(ii) + R, x(ii) - R:x(ii) + R, :);
    crop = reshape(crop, [], 3);
    RGBc = [RGBc; mean(crop)];
end
hold off

M = inv(RGBc' * RGBc) * (RGBc' * RGBr);

im = reshape(im, [], 3);
im = im * M;
im = reshape(im, S);
figure(5), imshow(im)

%% enhancement
Sfactor = 0.75;
im = rgb2hsv(im);
im(:, :, 2) = im(:, :, 2) * Sfactor;
im = hsv2rgb(im);
figure(6), imshow(im)

%% compressione e salvataggio
im = imresize(im, 0.5);
imwrite(im2uint8(im), "raw_to_srgb.jpg");
