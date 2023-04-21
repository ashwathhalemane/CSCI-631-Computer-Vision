function [outputArg1,outputArg2] = HW_04_Ashwathsreedhar_Halemane_DIR(inputArg1)

% part B
rgbImage = imread(inputArg1);

im          = imresize( rgbImage, [400 300] );     
dims        = size( im );
im          = rgb2ycbcr( im );
fltr        = fspecial( 'gauss', [15 15], 2 );
im          = imfilter( im, fltr, 'same', 'repl' );
% [rows, columns, numberOfColorChannels] = size(rgbImage);
redChannel = im(:, :, 1);
greenChannel = im(:, :, 2);
blueChannel = im(:, :, 3);
% [xs ys]     = meshgrid( 1:dims(2), 1:dims(1) );
data = double([redChannel(:)+greenChannel(:), greenChannel(:)+blueChannel(:), blueChannel(:)+redChannel(:)]);

numberOfClusters = 4;

[indexes, C] = kmeans(data, numberOfClusters,'Dist', 'Cityblock', 'Replicate', 3, 'MaxIter', 500);
im_new      = reshape( indexes, dims(1), dims(2) );
figure;
imagesc(im_new);

% part C
% edge detection using Canny filter
canny_edges = edge(im_new, 'Canny', 0.5, 1.1);
figure
imshow(canny_edges);

% part D


BW = imresize(boundarymask(canny_edges), size(im_new));

% figure
% imshow(BW)

B =imoverlay(im_new, BW, 'yellow');
figure
imshow(B)

end

