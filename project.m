function LeafEdges()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DATA LOADING AND PARTITIONING %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Obtain the location from the user
prompt = "Kindly give the location of your image folders";
location = input(prompt,'s');
%location = '/Users/aartinayak/Documents/MATLAB/CV_Project_Ivy_Leaves/LeafImages'; 


%Create the data source and assign labels to the both as Poison Ivy or not
%Poison Ivy based on the two distinct folders which contain images of one
%respective category each
dataFile = imageDatastore(location,'IncludeSubfolders',true,'LabelSource','foldernames');

%Check the total number of categories and samples available per each
labelCount = countEachLabel (dataFile);
disp("The number of images associated per each label are described in the table below." )
disp(labelCount);

%Create a partition to allot 80 percent of the available data to training
%purposes
numTrainFiles = 0.8;

%Split the data from each folder into train and test data in a randomized
%fashion
[trainingSet, testSet] = splitEachLabel(dataFile, numTrainFiles, 'randomized');

%Check for the total number of training samples
disp("The number of samples per each category available for the training purposes are described in the table below.")
disp(countEachLabel(trainingSet))

%Check for the total number testing samples
disp("The number of samples per each category available for the testing purposes are described in the table below.")
countEachLabel(testSet)

%Could uncomment to check the data loading output
%imshow(testSet.Files{5})

% subplot(2,3,1);
% imshow(trainingSet.Files{1});
% 
% subplot(2,3,2);
% imshow(trainingSet.Files{5});
% 
% subplot(2,3,3);
% imshow(trainingSet.Files{10});
% 
% subplot(2,3,4);
% imshow(testSet.Files{2});
% 
% subplot(2,3,5);
% imshow(testSet.Files{5});
% 
% subplot(2,3,6);
% imshow(testSet.Files{4});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PREPROCESSING: FOREGROUND - BACKGROUND SEGMENTATION(GRAB CUT AND MAHAL DIST) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RGB = readimage(testSet,5); %Read an image from the test data set

%resize the image to a standard size to deal with images 
%of all sizes
RGB = imresize(RGB, [700, 700]); 

%Divide the image into superpixels to help get more information 
%about each pixel
L = superpixels(RGB,4000);

% Could be set to false, if you wish to hardcode the values
GET_USER_INPUT = true;

imagesc( RGB );
axis image;

if ( GET_USER_INPUT )
        %  Get location of the central leaf from the user.
        fprintf('Outline the leaf you wish to check for \n');
        beep();
        [rxs,rys] = ginput();

        %Save the center leaf locations given by the user into a matrix
        save temp_matrix.mat rxs rys;
else
    load temp_matrix.mat;
end

rxs = round( rxs );
rys = round( rys );

%Create an n*2 matrix comprising of the n number of points
%clicked on by the user
positionMat = [rxs(1:length(rxs)), rys(1:length(rys))];

%Draw the region of interest for illustration purposes
h1 = drawpolygon('Position',positionMat);
pause(5);

%Figure contains an axes object. The axes object contains 2 objects of type image, images.roi.polygon.
roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));

%Perform the grab cut operation, specifying the original image, the label matrix and the ROI.
BW = grabcut(RGB,L,roi);
imshow(BW);

%Create an over lapping mask to incorporate the segmentation given by the
%grabcut function
maskedImage = RGB; %Initially set the mask to incorporate the entire image
maskedImage(repmat(~BW,[1 1 3])) = 0; %The portion of the image that is not extracted by the grabcut segmentation
imshow(maskedImage);

im = im2double(maskedImage); %Convert the image to double
imagesc( im );
axis image;

if ( GET_USER_INPUT )
        %  Get location of leaves from the user.
        fprintf('Click on the leaves\n');
        beep();
        [rxs,rys] = ginput();

        %  Get location of background pixels from the user.
        fprintf('Click on the background\n');
        beep();
        [bgxs,bgys] = ginput();

        save temp_matrix.mat rxs rys bgxs bgys;
else
    load temp_matrix.mat;
end
    
%  Gets color value samples of the leaves.
rxs = round( rxs );
rys = round( rys );
for leaf_idx = 1 : length( rxs )
    fg_color( leaf_idx, 1:3 ) = im( rys(leaf_idx), rxs(leaf_idx), : );
end

%  Get other background color value samples.
bgxs = round( bgxs );
bgys = round( bgys );
for background_idx = 1 : length( bgxs )
    bg_color( background_idx, 1:3 ) = im( bgys(background_idx), bgxs(background_idx), : );
end

disp('break here');
    
% 
%  For each input pixel, figure out distance to the leaf colors.
[im_red, im_grn, im_blu] = imsplit( im );

pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];



%  For each input pixel, find   distance to the background colors.
%  If a pixel is closer to the leaf color than to the other background cluster color,
%  classify it as a leaf
%  else
%  call it a background pixel.
%

fg_dist = mahal( pixel_data, fg_color ); %Get the distance of the leaf pixels from the foreground cluster
bg_dist = mahal( pixel_data, bg_color ); %Get the distance of the leaf pixels from the background cluster

b_is_fg = fg_dist < (0.5 * bg_dist); %Differentiates between the leaf and background pixels based on their mahal distance

b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );

%Obtain another mask after the second round of segmentation
maskedImage = RGB;
maskedImage(repmat(~b_is_fg,[1 1 3])) = 0;
imshow(maskedImage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COUNTING LEAVES USING BINARIZATION AND CONNECTED COMPONENTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
leafCountGray = maskedImage(:,:,2); %Extract the green channel

binaryImage = imbinarize(leafCountGray, 0.2); %Binarize the image with a custom segmenatation value

leafSeg = bwareaopen(binaryImage, 200); %Reject components with pixles fewer than 200

leafSeg = imfill(leafSeg, 'holes'); %Fill up the holes that might cause the noise

%Obtain another mask after the second round of segmentation
maskedImage = RGB;
maskedImage(repmat(~leafSeg,[1 1 3])) = 0;

imshow(maskedImage);

ConnectedComponets = bwconncomp(leafSeg); %Obtain all the connected components
b_boxes = regionprops(leafSeg, 'BoundingBox'); %Apply a bounding box around the components found
figure
imshow(maskedImage);
hold on
for k = 1 : length(b_boxes)
    curr = b_boxes(k).BoundingBox;
    rectangle('Position',[curr(1), curr(2), curr(3), curr(4)], 'EdgeColor','yellow','LineWidth',2)
end
hold off

if (ConnectedComponets.NumObjects == 3)
    disp("Potential poision Ivy since the number of leaves are three");
else
    disp("Safe to touch!")
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EDGE MARKING; FEATURE EXTRACTION AND SHAPE CONTEXT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reading and getting double image
im      = im2double( maskedImage );

% Green channel extraction 
im_g    = im( :, :, 2 );

% Gaussian filter for possible noise removal
im_g    = imfilter( im_g, fspecial('Gauss', 9, 0.9), 'same', 'repl' );

%Selected sobel filter to be applied accross the y axis
f_sobel_dIdy    = [ -1 -2 -1 ; 0  0  0 ; +1 +2 +1 ] /8;
f_sobel_dIdx    = f_sobel_dIdy.';

% Sobel filter to get the magnitudes
dIdy            = imfilter( im_g, f_sobel_dIdy, 'same', 'repl' );
dIdx            = imfilter( im_g, f_sobel_dIdx, 'same', 'repl' );
dImag           = sqrt( dIdy.^2  + dIdx.^2 );

% histogram of edges
histogram_bin_edges = [0:0.001:0.100];

[freq, bins] = histcounts( dImag(:), histogram_bin_edges );

figure('Position', [10 10 1800 1400] );

% Here we need to slice the obtained bins
bar((bins(:, 1 : end-1)), freq);

title( 'Edge Strength Bar Graph', 'FontSize', 24 ); 

pause(2);

%edge magnitude cut off value
cut_off_value = 0.1;
dImag(dImag < cut_off_value) = 1;
figure, imshow(dImag);

%Detect the surfpoints in the plant edges
points = detectSURFFeatures(dImag);
figure;
imshow(dImag); hold on;
plot(points.selectStrongest(150));
figure;
%Illustrate the shape context
h2 = drawpolygon('Position',points.Location);
% disp(h2);
% [features,valid_points] = extractFeatures(dImag,points);
% disp(valid_points);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRAIN THE CLASSIFIER USING THE SVM ALGORITHM %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%HAVE COMMENTED OUT THIS PART SINCE THE TRAINING TAKES A SIGNIFICANT
%%AMOUNT OF TIME AND CAUSES THE SYSTEM TO CRASH
% % for i = 1:numImages
%RGB = readimage(TrainSet,i); %Read an image from the test data set

%resize the image to a standard size to deal with images 
%of all sizes
%RGB = imresize(RGB, [700, 700]); 

%Divide the image into superpixels to help get more information 
%about each pixel
%L = superpixels(RGB,4000);

% Could be set to false, if you wish to hardcode the values
%GET_USER_INPUT = true;

% imagesc( RGB );
% axis image;
% 
% if ( GET_USER_INPUT )
%         %  Get location of the central leaf from the user.
%         fprintf('Outline the leaf you wish to check for \n');
%         beep();
%         [rxs,rys] = ginput();
% 
%         %Save the center leaf locations given by the user into a matrix
%         save temp_matrix.mat rxs rys;
% else
%     load temp_matrix.mat;
% end
% 
% rxs = round( rxs );
% rys = round( rys );
% 
% %Create an n*2 matrix comprising of the n number of points
% %clicked on by the user
% positionMat = [rxs(1:length(rxs)), rys(1:length(rys))];
% 
% %Draw the region of interest for illustration purposes
% h1 = drawpolygon('Position',positionMat);
% pause(5);
% 
% %Figure contains an axes object. The axes object contains 2 objects of type image, images.roi.polygon.
% roiPoints = h1.Position;
% roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));
% 
% %Perform the grab cut operation, specifying the original image, the label matrix and the ROI.
% BW = grabcut(RGB,L,roi);
% imshow(BW);
% 
% %Create an over lapping mask to incorporate the segmentation given by the
% %grabcut function
% maskedImage = RGB; %Initially set the mask to incorporate the entire image
% maskedImage(repmat(~BW,[1 1 3])) = 0; %The portion of the image that is not extracted by the grabcut segmentation
% imshow(maskedImage);
% 
% im = im2double(maskedImage); %Convert the image to double
% imagesc( im );
% axis image;
% 
% if ( GET_USER_INPUT )
%         %  Get location of leaves from the user.
%         fprintf('Click on the leaves\n');
%         beep();
%         [rxs,rys] = ginput();
% 
%         %  Get location of background pixels from the user.
%         fprintf('Click on the background\n');
%         beep();
%         [bgxs,bgys] = ginput();
% 
%         save temp_matrix.mat rxs rys bgxs bgys;
% else
%     load temp_matrix.mat;
% end
%     
% %  Gets color value samples of the leaves.
% rxs = round( rxs );
% rys = round( rys );
% for leaf_idx = 1 : length( rxs )
%     fg_color( leaf_idx, 1:3 ) = im( rys(leaf_idx), rxs(leaf_idx), : );
% end
% 
% %  Get other background color value samples.
% bgxs = round( bgxs );
% bgys = round( bgys );
% for background_idx = 1 : length( bgxs )
%     bg_color( background_idx, 1:3 ) = im( bgys(background_idx), bgxs(background_idx), : );
% end
% 
% disp('break here');
%     
% % 
% %  For each input pixel, figure out distance to the leaf colors.
% [im_red, im_grn, im_blu] = imsplit( im );
% 
% pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];
% 
% 
% 
% %  For each input pixel, find   distance to the background colors.
% %  If a pixel is closer to the leaf color than to the other background cluster color,
% %  classify it as a leaf
% %  else
% %  call it a background pixel.
% %
% 
% fg_dist = mahal( pixel_data, fg_color ); %Get the distance of the leaf pixels from the foreground cluster
% bg_dist = mahal( pixel_data, bg_color ); %Get the distance of the leaf pixels from the background cluster
% 
% b_is_fg = fg_dist < (0.5 * bg_dist); %Differentiates between the leaf and background pixels based on their mahal distance
% 
% b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );
% 
% %Obtain another mask after the second round of segmentation
% maskedImage = RGB;
% maskedImage(repmat(~b_is_fg,[1 1 3])) = 0;
% imshow(maskedImage);

% leafCountGray = maskedImage(:,:,2); %Extract the green channel
% 
% binaryImage = imbinarize(leafCountGray, 0.2); %Binarize the image with a custom segmenatation value
% 
% leafSeg = bwareaopen(binaryImage, 200); %Reject components with pixles fewer than 200
% 
% leafSeg = imfill(leafSeg, 'holes'); %Fill up the holes that might cause the noise
% 
% %Obtain another mask after the second round of segmentation
% maskedImage = RGB;
% maskedImage(repmat(~leafSeg,[1 1 3])) = 0;
% 
% imshow(maskedImage);

% ConnectedComponets = bwconncomp(leafSeg); %Obtain all the connected components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EDGE MARKING; FEATURE EXTRACTION AND SHAPE CONTEXT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % reading and getting double image
% im      = im2double( maskedImage );
% 
% % Green channel extraction 
% im_g    = im( :, :, 2 );
% 
% % Gaussian filter for possible noise removal
% im_g    = imfilter( im_g, fspecial('Gauss', 9, 0.9), 'same', 'repl' );
% 
% %Selected sobel filter to be applied accross the y axis
% f_sobel_dIdy    = [ -1 -2 -1 ; 0  0  0 ; +1 +2 +1 ] /8;
% f_sobel_dIdx    = f_sobel_dIdy.';
% 
% % Sobel filter to get the magnitudes
% dIdy            = imfilter( im_g, f_sobel_dIdy, 'same', 'repl' );
% dIdx            = imfilter( im_g, f_sobel_dIdx, 'same', 'repl' );
% dImag           = sqrt( dIdy.^2  + dIdx.^2 );

%edge magnitude cut off value
% cut_off_value = 0.1;
% dImag(dImag < cut_off_value) = 1;
% figure, imshow(dImag);
% 
% Detect the surfpoints in the plant edges
% points = detectSURFFeatures(dImag);
% figure;
% imshow(dImag); hold on;
% plot(points.selectStrongest(150));
% figure;
% Illustrate the shape context
% h2 = drawpolygon('Position',points.Location);
% % disp(h2);
% [features,valid_points] = extractFeatures(dImag,points);
% disp(valid_points);
% 
% %processedImage = imbinarize(maskedImage(:,:,2));
% % %     
% trainingFeatures(i, :) = features;  
% % end
% % 
% % % Get labels for each image.
% % trainingLabels = trainingSet.Labels;
% % 
% % classifier = fitcecoc(trainingFeatures, trainingLabels);





end
