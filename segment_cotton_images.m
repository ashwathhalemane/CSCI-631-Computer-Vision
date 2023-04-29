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
            num_str = regexp(name_without_extension, '\d+$', 'match'); % extract the last characters which are numbers
            
            disp(num_str)
        end

    
    end

end