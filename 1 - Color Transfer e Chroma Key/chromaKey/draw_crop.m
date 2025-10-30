im = im2double(imread("godzilla_chromakey/godzilla_1.jpg"));

crops = [[140 40]; [560 410]; [470 490]];
for ii = 1:size(crops, 1)
    for jj = crops(ii, 1) - 1:crops(ii, 1) + 11
        im(jj, crops(ii, 2) - 2, :) = [255 0 0];
        im(jj, crops(ii, 2) - 1, :) = [255 0 0];
        im(jj, crops(ii, 2) + 11, :) = [255 0 0];
        im(jj, crops(ii, 2) + 12, :) = [255 0 0];
    end
    for jj = crops(ii, 2) - 1:crops(ii, 2) + 11
        im(crops(ii, 1) - 2, jj, :) = [255 0 0];
        im(crops(ii, 1) - 1, jj, :) = [255 0 0];
        im(crops(ii, 1) + 11, jj, :) = [255 0 0];
        im(crops(ii, 1) + 12, jj, :) = [255 0 0];
    end
end

imshow(im)
imwrite(im, "crops_area.png");
