% function image_inversion(ImageAsParameter)

% read image and convert it to double
im_db = im2double(imread("cameraman.tif"));
imshow(im_db)
% display grayscale of image using imagesc to understand more about the
% image

figure
imshow(im_db);
colormap(gray(256)); % default is 256 
axis image;

% display negative of the image
imshow( 1 - im_db ) ;
axis image;


