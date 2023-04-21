function virginia_creeper(Name)

virginia = imread(Name)

im_gray = im2double( virginia( 2:2:end, 2:2:end, 2) );

% imshow(virginia)
% imshow(im_gray)


level = graythresh(im_gray);

% disp(level)
level = 0.7;

BW = imbinarize(im_gray, level);

% imshowpair(im_gray, BW, 'Binary seg...')
imshow(BW)

% imwrite(BW, "binary_segmented_virginia_creeper.jpg")

end
