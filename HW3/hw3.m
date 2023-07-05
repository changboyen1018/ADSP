clc;
clear all;

% Read input image and convert to double
input_img = double(imread('tiger.jpeg'));
[rows, cols, ~] = size(input_img);

% Convert RGB to YCbCr
T = [0.299, 0.587, 0.114; -0.169, -0.331, 0.5; 0.5, -0.419, -0.081];
ycbcr_img = reshape(input_img, [], 3) * T.';
ycbcr_img = reshape(ycbcr_img, rows, cols, 3);

% Downsample Cb and Cr channels
cb = ycbcr_img(1:2:end, :, 2);
cr = ycbcr_img(1:2:end, :, 3);
cb = cb(:, 1:2:end);
cr = cr(:, 1:2:end);

% Upsample Cb and Cr channels
cb_up = interp2(cb, 1, 'linear');
cr_up = interp2(cr, 1, 'linear');

% Ensure dimensions match during the assignment
cb_up_resized = zeros(rows, cols);
cr_up_resized = zeros(rows, cols);
cb_up_resized(1:size(cb_up, 1), 1:size(cb_up, 2)) = cb_up;
cr_up_resized(1:size(cr_up, 1), 1:size(cr_up, 2)) = cr_up;

% Convert YCbCr back to RGB
ycbcr_img(:, :, 2) = cb_up_resized;
ycbcr_img(:, :, 3) = cr_up_resized;
rgb_img = reshape(ycbcr_img, [], 3) * inv(T).';
rgb_img = reshape(rgb_img, rows, cols, 3);

% Display original and reconstructed images
subplot(1, 2, 1);
imshow(uint8(input_img));
xlabel('Before');

subplot(1, 2, 2);
imshow(uint8(rgb_img));
xlabel('After');
