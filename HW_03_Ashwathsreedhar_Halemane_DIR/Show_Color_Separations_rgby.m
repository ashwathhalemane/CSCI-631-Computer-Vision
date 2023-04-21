function Show_Color_Separations_rgby(inputArg1)

img = imread(inputArg1);

red_channel = img(:,:,1);
green_channel = img(:,:,2);
blue_channel = img(:,:,3);

% Create a yellow mask (by combining red and green channels)
yellow_mask = (red_channel > 200) & (green_channel > 200);

yellow_channel = blue_channel;
yellow_channel(yellow_mask) = 255;

figure;
subplot(2,2,1);
imshow(red_channel);
title('Red Channel');

subplot(2,2,2);
imshow(green_channel);
title('Green Channel');

subplot(2,2,3);
imshow(blue_channel);
title('Blue Channel');

subplot(2,2,4);
imshow(yellow_channel);
title('Yellow Channel');

figure;
imshow(img);
title('Original Image');

end
