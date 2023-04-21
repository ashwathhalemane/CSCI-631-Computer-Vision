function HW_03_Ashwathsreedhar_Halemane_Q2(inputArg1)
% HW_03_ASHWATHSREEDHAR_HALEMANE_Q2 Summary of this function goes here
%   Detailed explanation goes here
im = imread(inputArg1);

gray_img = rgb2gray(im);

red_channel = im(:,:,1);
green_channel = im(:,:,2);
blue_channel = im(:,:,3);

figure
subplot(2,2,1)
red_channel_hist = histeq(red_channel);
imshow(red_channel_hist)
title('Red Channel');

subplot(2,2,2)
green_channel_hist = histeq(green_channel);
imshow(green_channel_hist)
title('Green Channel');

subplot(2,2,3)
blue_channel_hist = histeq(blue_channel);
imshow(blue_channel_hist)
title('Blue Channel');

subplot(2,2,4)
gray_hist = histeq(gray_img)
imshow(gray_hist)
title('Gray');

imAd = imadjust(red_channel,stretchlim(red_channel),[1 0]);
figure
imshow(imAd)
title('Red Channel');

end

