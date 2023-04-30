function segment_cotton_images()
  
save_files_with_new_name()
    function save_files_with_new_name( )
%       change your path here    
        file_list = dir('D:\RIT-Spring-2023\Computer Vision\PROJECT\cotton images and labels\cotton images\*.tif');
        
        for counter = 1:length(file_list)
            fn = file_list(counter).name;
            
            fprintf(fn + "\n");
            
            [filepath, name, ~] = fileparts(fn);
            name_without_extension = fullfile(filepath, name);
            fprintf(name_without_extension + "\n")
            updated_file_name = regexp(name_without_extension, '\d+$', 'match'); % extract the last characters which are numbers
            disp(updated_file_name)
            new_filename = string(strcat(updated_file_name, '.tif'));
            disp(new_filename);
            

            new_folder_path = 'D:\RIT-Spring-2023\Computer Vision\PROJECT\Preprocessed images\'; 
%             
%             a = 'C:\Users\me\folder';
%             b = 'A1B1';
%             c = 'A';
%             img = '0001.bmp';
%             sp = strrep(img, '.', '_1.');
%             full = fullfile(a,b,c,sp);
%             imwrite(I,full);

            image_to_read = imread(fn);
            disp(size(image_to_read))
%             pre-processing steps comes here
%             im is the updated image
            full = fullfile(new_folder_path, new_filename);
            disp(full);
            % Set the compression to LZW
%             options = 'Compression','lzw';
            imwrite(image_to_read, new_filename,"Compression", "LZW");
        end

    
    end

end