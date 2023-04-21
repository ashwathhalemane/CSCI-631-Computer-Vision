function contrast_enhancement(inputArg1)
%CONTRAST_ENHANCEMENT Summary of this function goes here
%   Detailed explanation goes here
% outputArg1 = inputArg1;

im = imread(inputArg1);

% imshow(im)

im_gray = im2double( im( 2:2:end, 2:2:end, 2) );

histeq_image = histeq(im_gray);

imshow(histeq_image)

% imshow(im_gray)

end

