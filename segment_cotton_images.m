
function segment_cotton_images()

        %       change your path here to point to tif images 
        file_list = dir('D:\RIT-Spring-2023\Computer Vision\PROJECT\cotton images and labels\testing images\*.tif');
%         file_list = dir('C:\Users\vvvar\OneDrive\Documents\MATLAB\CVProject\cottonImg\*.tif');
       
%         path = 'C:\Users\vvvar\OneDrive\Documents\MATLAB\CVProject\cottonImg\';
        path = 'D:\RIT-Spring-2023\Computer Vision\PROJECT\cotton images and labels\testing images\';

        for counter = 1:length(file_list)
            fn = file_list(counter).name;
            [filepath, name, ~] = fileparts(fn);
            name_without_extension = fullfile(filepath, name);
            updated_file_name = regexp(name_without_extension, '\d+$', 'match'); % extract the last characters which are numbers
            new_filename = string(strcat(updated_file_name, '.tif'));
           
%             new_folder_path = 'C:\Users\vvvar\OneDrive\Documents\MATLAB\CVProject\cottonImgUpdated'; 
            new_folder_path = 'D:\RIT-Spring-2023\Computer Vision\PROJECT\prepro';

            if ~exist(new_folder_path, 'dir')
                mkdir(new_folder_path);
            end

            image_to_read = imread(string(strcat(path, fn)));
            resizing_tiff = image_to_read(:,:,1:3);
            %   pre-processing steps comes here
            preprocessed_image = classify_irrigation(resizing_tiff);
            %   im is the updated image

            fullpath_with_imagename = fullfile(new_folder_path, new_filename);
            % Set the compression to LZW
            imwrite(preprocessed_image, fullpath_with_imagename, 'tif');
        end
end

function preprocessed_image_return=classify_irrigation(Input)
        disp(size(Input))
%         removed imread since we are passing tiff image as matrix itself
        tiff_image = im2double(Input);
        %Indexing the multi-channel Tiff image to create a new RGB image 
        tiff_image = tiff_image(:,:,1);
%         imshow(tiff_image);

        %Converting RGB to gray image 
        im_grey = im2gray(tiff_image);
%         figure, imshow(im_grey);

        %Binarizing the image 
        im_binary = imbinarize(im_grey);
%         figure, imshow(im_binary);

        %Performing Object Segmentation
        %Binary using threshold value 
        level = graythresh(tiff_image);
        disp(level);
        BW = imbinarize(tiff_image, level);
%         figure, imshow(BW);

        %Perform Erosion 
        se = strel('disk', 5);

        %Perform Erosion 
        er_im = imerode(BW, se);
%         figure, imshow(er_im);
         

        %Applying Edge detection
        bw_edge_im = edge(er_im, 'canny');
%         figure, imshow(bw_edge_im);

        alpha = 0.7; % blending parameter between 0 and 1
        I_blend = alpha*tiff_image + (1-alpha)*bw_edge_im;
%         figure,imshow(I_blend);
        
        preprocessed_image_return = I_blend;
        return

end

