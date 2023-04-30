function segment_cotton_images()
  
save_files_with_new_name()
    function save_files_with_new_name( )
        %       change your path here to point to tif images 

        file_list = dir('D:\RIT-Spring-2023\Computer Vision\PROJECT\cotton images and labels\cotton images\*.tif');
        % path where you save preprocessed images
        path = 'D:\RIT-Spring-2023\Computer Vision\PROJECT\cotton images and labels\cotton images\';

        for counter = 1:length(file_list)
            fn = file_list(counter).name;
            [filepath, name, ~] = fileparts(fn);
            name_without_extension = fullfile(filepath, name);
            updated_file_name = regexp(name_without_extension, '\d+$', 'match'); % extract the last characters which are numbers
            new_filename = string(strcat(updated_file_name, '.tif'));
           
            new_folder_path = 'D:\RIT-Spring-2023\Computer Vision\PROJECT\prepro'; 
            
            if ~exist(new_folder_path, 'dir')
                mkdir(new_folder_path);
            end

            image_to_read = imread(string(strcat(path, fn)));
            resizing_tiff = image_to_read(:,:,1:3);
            %   pre-processing steps comes here

            %   im is the updated image

            fullpath_with_imagename = fullfile(new_folder_path, new_filename);
            % Set the compression to LZW
            imwrite(resizing_tiff, fullpath_with_imagename, 'tif');
        end

    
    end

end