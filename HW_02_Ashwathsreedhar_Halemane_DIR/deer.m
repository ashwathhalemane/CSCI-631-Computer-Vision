function deer(inputArg1)
%DEER Summary of this function goes here
%   Detailed explanation goes here

im_db = im2double( imread( inputArg1 ) ); 

imagesc( ( im_db(:,:,1) + im_db(:,:,3) - 2 * im_db(:,:,2 ) )/ 2 );
% imagesc(rgb2gray(im_db))
% imagesc(im_db(:,:,3))
colormap(gray(256));
axis image;

end

