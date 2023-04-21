function ivy_grape(inputArg1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% outputArg1 = inputArg1;
% outputArg2 = inputArg2;
im = imread(inputArg1)
im_gray = im2double( im( 2:2:end, 2:2:end, 2) );

threshold = 0.5;

% binary_image = im_gray > threshold;
binary_image = imbinarize(im_gray, threshold);

segmented_image = adapthisteq(im_gray);

imshow(segmented_image);
title('White Ivy and black leaves');

end

