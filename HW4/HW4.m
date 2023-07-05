clc
clear all
close all

% Read the first image
firstImageName = input('Input the original file name: ', 's');
firstImage = imread(firstImageName);
firstImage = double(firstImage);
[firstImageRows, firstImageColumns, ~] = size(firstImage);

% Read the second image and resize it to match the first image
secondImageName = input('Input the compared file name: ', 's');
secondImage = imread(secondImageName);
secondImage = imresize(secondImage, [firstImageRows, firstImageColumns]); % resize to match the first image
secondImage = double(secondImage);
[secondImageRows, secondImageColumns, ~] = size(secondImage);

% Ensure both images are of the same size
if firstImageRows ~= secondImageRows || firstImageColumns ~= secondImageColumns
    error('The two images are of different sizes. Please input images of the same size.')
end

% Convert images from RGB to grayscale
for i =1:firstImageRows
    for j = 1:firstImageColumns
        grayscaleFirstImage(i,j) = 0.212671*firstImage(i,j,1) + 0.715160*firstImage(i,j,2) + 0.072169*firstImage(i,j,3);
        grayscaleSecondImage(i,j) = 0.212671*secondImage(i,j,1) + 0.715160*secondImage(i,j,2) + 0.072169*secondImage(i,j,3);
    end
end

% Obtain user input for constants c1 and c2
L = 255;
c1 = input('Input the first constant value c1: ');
c2 = input('Input the second constant value c2: ');

% Compute mean of the grayscale images
meanFirstImage = mean(grayscaleFirstImage(:));
meanSecondImage = mean(grayscaleSecondImage(:));

% Compute variance of the grayscale images
varianceFirstImage = var(grayscaleFirstImage(:));
varianceSecondImage = var(grayscaleSecondImage(:));

% Compute co-variance of the grayscale images
covarianceMatrix = cov(grayscaleFirstImage(:), grayscaleSecondImage(:));
covariance = covarianceMatrix(2);

% Compute SSIM
numerator = (2 * meanFirstImage * meanSecondImage + c1 * L) * (2 * covariance + c2 * L);
denominator = (meanFirstImage^2 + meanSecondImage^2 + c1 * L) * (varianceFirstImage + varianceSecondImage + c2 * L);
SSIM = numerator / denominator

% Display original and grayscale images
figure;
% Original first image
subplot(2,2,1);
imshow(firstImage / 255);
% Grayscale first image
subplot(2,2,3);
imshow(grayscaleFirstImage, []);
xlabel('First image');

% Original second image
subplot(2,2,2);
imshow(secondImage / 255);
% Grayscale second image
subplot(2,2,4);
imshow(grayscaleSecondImage, []);
xlabel('Second image');
