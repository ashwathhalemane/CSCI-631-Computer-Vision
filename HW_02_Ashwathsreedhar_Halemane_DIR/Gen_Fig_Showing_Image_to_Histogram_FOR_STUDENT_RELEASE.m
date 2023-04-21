%
%   ALWAYS USE A FUNCTION, NEVER USE A SCRIPT !!
%

function Gen_Fig_Showing_Image_to_Histogram_FOR_STUDENT_RELEASE()
% Show histogram figure that shows which pixels in the image map to which bars on a histogram.
%
%  T.Kinsman -- Sept 08, 2022
%
FS                              = 20;    
MIDDLE_GRAY                     = [1 1 1]*0.8;
places_to_split_the_colormap    = [ 64, 128 192, 255 ]; % Hand choosen 
places_to_split_the_colormap    = [ 28, 88 192, 255 ]; % Hand choosen 


    % Here are some favorite colors to use.
    % Colormaps use double numbers, in the range [0 to 1], inclusively.
    new_color_orders                = [  0,  0,    1 ;        % Blue
                                         1,  0,    0 ;        % Red.
                                         0,  0.8,  0 ;        % Dark Green -- give better contrast.
                                         1,  1,    0 ];       % What is this?
                        
                                     
    im          = imread('cameraman.tif');

    edges       = 1:256;
    [counts,~]  = histc( im(:), edges );        % Get the bargraph data.
    
    % Create a big fig:
    figure( 'Position', [10 10 1200 513] );     % Hand choosen
    
    
    subplot(1,2,1);
    imagesc( im );
    colormap( gray(256) );
    colorbar;
    axis image;

    % Fill the space more with the axis:
    set(gca,'Position', [0.075 0.075 0.4 0.9]);
    axis_on_left = gca();
    
    disp('break here');
    
    % What does this command do?
    subplot(1,2,2);
    bar( edges, counts(:), 'FaceColor', 'k' );
    %
    %  Set the background of this graphics to a middle gray color:
    %
    set(gca,'Color', MIDDLE_GRAY );
    
    ylabel( 'Frequency of this bin', 'Fontsize', FS );
    xlabel( 'Pixel Value', 'FontSize', FS );
    set(gca,'Position', [0.575 0.075 0.4 0.9]);
    
    axis_on_right = gca();

    my_new_colormap_to_show_objects = gray(256);
   
    axis( axis_on_left );
    colormap( my_new_colormap_to_show_objects );
    
    disp('break here');
   
    axis( axis_on_right );
    hold on;                        % What does this do?
    
    color_counter                   = 1;
    left_hand_side_of_range         = 1;
    for right_hand_side_of_range    = places_to_split_the_colormap

        % Which range of the image values are you changing?
        histogram_range_to_change   = left_hand_side_of_range : right_hand_side_of_range ;
        
        % How many levels are there here?
%         n_levels_here               = length( histogram_range_to_change );
        n_levels_here               = (right_hand_side_of_range+1) - (left_hand_side_of_range) + 1;
        % Get a temporary copy of the current color.
        selected_color              = new_color_orders( color_counter, : );
%         selected_color              = new_color_orders( color_counter, : );
        multiple_copies_of_color    = repmat( selected_color,  n_levels_here, 1 );
        colormap_range_to_change    = left_hand_side_of_range : (right_hand_side_of_range+1) ;

        my_new_colormap_to_show_objects( colormap_range_to_change, : )    = multiple_copies_of_color;
        
        % Install the colormap:
        colormap( my_new_colormap_to_show_objects );

        bar( edges(histogram_range_to_change), counts(histogram_range_to_change), ...
             'FaceColor', selected_color, ...
             'LineStyle', 'none' );
         
        % Force the axis to look good for this entire demonstration:
        % Otherwise, it only really looks good at the end.
        axis( [ 0, 256, 0, 1800 ] );

        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %  END OF LOOP CLEANUP and PREPARATION FOR NEXT ITERATION;
        %
        left_hand_side_of_range     = right_hand_side_of_range+1;
        color_counter               = color_counter + 1;
        
        % Force graphics to update:
        drawnow;
        pause(2);
    end
    
    %
    %  Set the background of this graphics to a middle gray color:
    %
    set(gca,'Color', MIDDLE_GRAY );
    save_curr_fig_to_file("cameraman_with_histogram.png");
end


