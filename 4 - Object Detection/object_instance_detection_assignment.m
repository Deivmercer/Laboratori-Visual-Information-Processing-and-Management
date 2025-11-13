% Lettura immagini
elephantImage = imread("immaginiObjectDetection/elephant.jpg");
sceneImage = imread("immaginiObjectDetection/clutteredDesk.jpg");

%% Keypoint detection
elephantPoints = detectSURFFeatures(elephantImage, "MetricThreshold", 500, "NumScaleLevels", 6);
scenePoints = detectSURFFeatures(sceneImage, "MetricThreshold", 500, "NumScaleLevels", 6);

figure(1), clf
imshow(elephantImage), hold on
plot(selectStrongest(elephantPoints, 100)), hold off

figure(2), clf
imshow(sceneImage), hold on
plot(selectStrongest(scenePoints, 100)), hold off

%% Keypoints description
[elephantFeatures, elephantPoints] = extractFeatures(elephantImage, elephantPoints, "FeatureSize", 128);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints, "FeatureSize", 128);

%% Features matching
matches = matchFeatures(elephantFeatures, sceneFeatures, "MatchThreshold", 5, "MaxRatio", 0.9);
matchedElephantPoints = elephantPoints(matches(:, 1));
matchedScenePoints = scenePoints(matches(:, 2), :);
figure(3), clf
showMatchedFeatures(elephantImage, sceneImage, matchedElephantPoints, matchedScenePoints, "montage");

%% Geometric consistency check
[tform, inlierElephantPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedElephantPoints, matchedScenePoints, "affine", "MaxDistance", 47);
figure(4), clf
showMatchedFeatures(elephantImage, sceneImage, inlierElephantPoints, inlierScenePoints, "montage")

size(inlierElephantPoints)

%% Bounding box drawing
boundigBox = [1 1;
           size(elephantImage, 2) 1;
           size(elephantImage, 2) size(elephantImage, 1);
           1 size(elephantImage, 1);
           1 1];
newBoundingBox = transformPointsForward(tform, boundigBox);
figure(5), clf
imshow(sceneImage), hold on
line(newBoundingBox(:, 1), newBoundingBox(:, 2), "Color", "y")
hold off

%% Precise bounding box
% figure(6), clf
% imshow(elephantImage)
% [x, y] = ginput(50);
% x = [x; x(1)];
% y = [y; y(1)];
% save elephantPoints x y

load elephantPoints.mat

newBoundingBox = transformPointsForward(tform, [x y]);
figure(7), clf
imshow(sceneImage), hold on
line(newBoundingBox(:, 1), newBoundingBox(:, 2), "Color", "y")
hold off
