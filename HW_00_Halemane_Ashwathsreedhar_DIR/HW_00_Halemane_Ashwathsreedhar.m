function HW_00_Halemane_Ashwathsreedhar(ImageName)

% 1. read input image using imread
RGB_profile_pic = imread(ImageName);
figure
imshow(RGB_profile_pic)
%fkshfdj% 
%
% 4. size of original color image
disp(size(RGB_profile_pic))
% 2. convert RGB color image to grey scale
greyscale_image = rgb2gray(RGB_profile_pic);
figure
imshow(greyscale_image)

% shrinking the image to desired dimensions here less than 640 and 480
shrunken_profile_pic_with_RGB = imresize(RGB_profile_pic,[600 400]); 

% disp(shrunken_profile_pic_with_RGB)
sizeofshrunken = size(shrunken_profile_pic_with_RGB);
disp(sizeofshrunken)
figure
imshow(shrunken_profile_pic_with_RGB)

% Extract the individual red, green, and blue color channels.
redChannel = shrunken_profile_pic_with_RGB(:, :, 1);
greenChannel = shrunken_profile_pic_with_RGB(:, :, 2);
blueChannel = shrunken_profile_pic_with_RGB(:, :, 3);

% Now swap around in any way you want.
newRedChannel = greenChannel;
newGreenChannel = redChannel; 
newBlueChannel = blueChannel;

% Recombine separate color channels into a single, true color RGB image.
swapped_channel_image = cat(3, newRedChannel, newGreenChannel, newBlueChannel);

% 4. Display the shrunked image with swapped color channels
figure
imshow(swapped_channel_image)

% 5. Inverting center half of the shrunken image using simple matrix value
% manipulation using size and round functions, here since the image is
% uint8, we perform 255-old to invert the center half of the image

shrunken_profile_pic_with_RGB(round(sizeofshrunken(1)/4):round(sizeofshrunken(1)/1.3333), round(sizeofshrunken(1)/6):round(sizeofshrunken(1)/2)) = 255 - shrunken_profile_pic_with_RGB(round(sizeofshrunken(1)/4):round(sizeofshrunken(1)/1.3333), round(sizeofshrunken(1)/6):round(sizeofshrunken(1)/2));
% shrunken_profile_pic_with_RGB(1: 600, 1:400) = 255 - shrunken_profile_pic_with_RGB(1: 600, 1:400)
figure
imshow(shrunken_profile_pic_with_RGB)

% Working with quality of the image
imwrite(shrunken_profile_pic_with_RGB,'HW_00_Halemane_Ashwathsreedhar_DIR/temp.jpg', 'Quality',90);

% 6. Invert one color channel or another, only.
redChannel = shrunken_profile_pic_with_RGB(:, :, 1);
greenChannel = shrunken_profile_pic_with_RGB(:, :, 2);
blueChannel = shrunken_profile_pic_with_RGB(:, :, 3);
% Now invert green channel of the image.
newGreenChannel = 255 - greenChannel;

% Recombine separate color channels into a single, true color RGB image.
% swapped_channel_image = cat(3, newRedChannel, newGreenChannel, newBlueChannel);
figure
imshow(cat(3, redChannel,newGreenChannel, blueChannel))

% read both images as double images
classmate_profile_pic = imread("classmate.jpeg");
double_classmate = im2double(classmate_profile_pic);

double_my_profile = im2double(RGB_profile_pic);

resized_classmate = imresize(double_classmate,[1000 800]);
resized_my_profiel = imresize(double_my_profile, [resized_classmate(1) resized_classmate(2)]);

subracted_image = resized_my_profiel - resized_classmate;
difference_image = [subracted_image, resized_classmate];
figure
imagesc(difference_image)

% Convert the image to hsv(), and play with it

im = imread('colorful.jpg');
im_hsv = rgb2hsv( im );
figure;
im_hue_only = im_hsv(:,:,1);
imagesc( im_hue_only );
colormap( hsv(256) );

% Split it into different channels and display them at the same time.

im = imread('ashwath.jpeg');
im_small = imrotate( im( 2:3:end, 2:3:end, : ),0 );
im_up_right = zeros( size(im_small) );
im_up_right(:,:,1) = im_small(:,:,1);
im_down_left = zeros( size(im_small) );
im_down_left(:,:,2) = im_small(:,:,2);
im_down_right = zeros( size(im_small));
im_down_right(:,:,3) = im_small(:,:,3);
im_composite = [ im_small , im_up_right ;
im_down_left , im_down_right ];
figure;
imagesc( im_composite );

end
