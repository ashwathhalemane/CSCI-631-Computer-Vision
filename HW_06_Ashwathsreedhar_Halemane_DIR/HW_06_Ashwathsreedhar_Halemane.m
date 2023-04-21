function HW_06_Ashwathsreedhar_Halemane() 

    im_rgb  = im2double( imread( 'peppers.png' ) );
    im_in   = rgb2gray( im_rgb );
    
    fltr    = [ -2 0 2 ;
                -5 0 5 ;
                -2 0 2 ] /2 /9;
            
%     OR 
   
    fltr    = [ 1  2  1 ;
                2  4  2 ;
                1  2  1 ] / 16;
            
%    OR 
   
    fltr = fspecial('Gauss', 5, 1 );
   
    % Run my version of the filter:
    expect_ans = imfilter( im_in, fltr, 'same', 'repl' );
    
    % Display my results:
    figure('Position', [300 100 600 600]);
    imagesc( expect_ans );
    colormap(gray);         % Show in gray
    axis image;             % Make the axes have square pixels.
    title('My Results','FontSize', 24);
    colorbar;
    
    disp('Showing for 5 seconds:');
    pause(5);
    
    
    my_ans      = my_very_own_image_filter( im_in, fltr );
    
    figure;
    imshow(my_ans);
    title('My customer filtered Image', 'FontSize', 16);
    
    im_diff     = imabsdiff( expect_ans, my_ans );
    
    figure
    imshow( im_diff );
    title('Difference of 2 images', 'FontSize', 16)
    axis image;
    colorbar;
    
    
    
end

function im_out = my_very_own_image_filter(im_in, fltr)

    im_out = zeros(size(im_in)); % Make the output the same SIZE by default.
    
    image_dimensions = size(im_in);
    filter_dims = size(fltr);
    
    % Loop over each pixel in the output image
    for row = 1:image_dimensions(1)
        for col = 1:image_dimensions(2)
            
            % Apply the filter to the current pixel
            pixel_sum = 0;
            for filter_row = 1:filter_dims(1)
                for filter_col = 1:filter_dims(2)
                    
                    input_row = row + filter_row - 1;
                    input_col = col + filter_col - 1;
                    
                    % Check if the input row and column indices are within
                    % the bounds .
                    if input_row < 1 || input_row > image_dimensions(1) || ...
                       input_col < 1 || input_col > image_dimensions(2)
                        continue;
                    end
                    
                    % Compute the contribution of the current input pixel to the current output pixel.
                    pixel_sum = pixel_sum + im_in(input_row, input_col) * fltr(filter_row, filter_col);
                end
            end
            im_out(row, col) = pixel_sum;
        end
    end
end



