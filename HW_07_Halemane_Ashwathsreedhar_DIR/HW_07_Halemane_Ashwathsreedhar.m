function HW_07_Halemane_Ashwathsreedhar()
% 
% current_working_directory = pwd
% 
% disp(current_working_directory) 

secret_message_image = 'HW_07_Halemane_Ashwathsreedhar_DIR/ZIP_FILE_OF_IMAGES_for_SEMESTER_2225/Img431_SCAN275__Secret_Mess.jpg';
raspberry_image = 'HW_07_Halemane_Ashwathsreedhar_DIR/ZIP_FILE_OF_IMAGES_for_SEMESTER_2225/Raspberry_Image.jpg';
orange_image = 'HW_07_Halemane_Ashwathsreedhar_DIR/ZIP_FILE_OF_IMAGES_for_SEMESTER_2225/Orange_Image.jpg';

% HW07_Email1_Cluster_Colors(secret_message_image)
HW07_Email1_FIND_RASPBERRIES(raspberry_image)
HW07_Email1_FIND_ORAGES(orange_image)

% 
% function HW07_Email1_Cluster_Colors(secret_message_image)
%     im = im2double( imread( secret_message_image ));
% 
%     im = im( 2:2:end, 2:2:end, : ); % reduce image into half in both x and y dimensions
%     
%     im_red  = im( :, :, 1 );
%     im_grn  = im( :, :, 2 );
%     im_blu  = im( :, :, 3 );
%     
%     data = [ im_red(:) , im_grn(:) , im_blu(:) ];
%     
%     % disp(data) % 943200 * 3
%     % Why would Dr. K use these colors to start with??
% %     Seed_Pts.Color_Starting_Point = [ ...
% %        0.0000 0.0000 0.0000 ;   % Black
% %        1.0000 0.0000 0.0000 ;   % Red
% %        0.0000 0.9000 0.0000 ;   % Green
% %        0.0000 0.0000 1.0000 ;   % Blue
% %        1.0000 0.0000 1.0000 ;   % Magenta
% %        0.2000 0.4000 0.4000 ;   % Cyan
% %        1.0000 1.0000 0.0000 ;   % Yellow
% %        1.0000 1.0000 1.0000 ;   % White
% %        0.7000 0.7000 0.0000 ;   % Brown -- Dark Yellow
% %        0.7000 0.4000 0.0000 ;   % Pinkish or maybe orangish
% %        0.4000 0.4000 0.4000 ;   % Dark gray
% %        0.8000 0.8000 0.8000 ;   % Light gray
% %     ];
% %     Seed_Pts.Color_name = { 
% %         'Black', ...
% %         'Red', ...
% %         'Green', ...
% %         'Blue', ...
% %         'Magenta', ...
% %         'Cyan', ...
% %         'Yellow', ...
% %         'White', ...
% %         'Brown', ...
% %         'Pinkish', ...
% %         'Dark Gray', ...
% %         'Light Gray' };
% 
% Seed_Pts.Color_Starting_Point = [ ...
%        
%        1.0000 0.0000 0.0000 ;   % Red
%        0.0000 0.9000 0.0000 ;   % Green
%        0.0000 0.0000 1.0000 ;   % Blue
%        0.0000 0.0000 0.0000 ;   % Black
% %        Purple: [0.5, 0, 0.5]
%         0.5000 0.0000 0.5000 ;   % Purple
% %        1.0000 0.0000 1.0000 ;   % Magenta
% %        0.2000 0.4000 0.4000 ;   % Cyan
% %        1.0000 1.0000 0.0000 ;   % Yellow
% %        1.0000 1.0000 1.0000 ;   % White
% %        0.7000 0.7000 0.0000 ;   % Brown -- Dark Yellow
% %        0.7000 0.4000 0.0000 ;   % Pinkish or maybe orangish
% %        0.4000 0.4000 0.4000 ;   % Dark gray
% %        0.8000 0.8000 0.8000 ;   % Light gray
%     ];
% % 
% %     red 
% % green
% % blue
% % purple
% % black
% 
%     Seed_Pts.Color_name = { 
%         
%         'Red', ...
%         'Green', ...
%         'Blue', ...
%         'Black', ...
%         'Purple'
% %         'Cyan', ...
% %         'Yellow', ...
% %         'White', ...
% %         'Brown', ...
% %         'Pinkish', ...
% %         'Dark Gray', ...
% %         'Light Gray'
%         };
%     
%     % Check for stupid mistakes:
%     %
%     % Assertions are checked once, and then ignored later.
%     % They are used for good code development, and checks when debugging.
%     %
%     % The released code ignores these.
%     %
%     assert( length( Seed_Pts.Color_Starting_Point ) == length( Seed_Pts.Color_name ) );
%     
%     n_seeds     = size( Seed_Pts.Color_Starting_Point, 1 );
% 
%     % Lengths returns the longest dimension of an array, so this would work too,
%     % as long as there are more then 3 seed points:
%     n_seeds     = length( Seed_Pts.Color_Starting_Point );
% 
%     disp(n_seeds)
%     % Time the process of running kmeans:
%     tic();
% %     kmeans(img, num_clusters, 'Distance', 'sqEuclidean', 'Start', cluster_centers);
%     [cluster_id, kmeans_center_found] = kmeans( data, n_seeds, 'Distance', 'sqEuclidean', 'Start', Seed_Pts.Color_Starting_Point );
%     kmeans_time = toc();
%     
%     disp(cluster_id)
%     fprintf('K Means Centers found:\n');
%     fprintf(' [ %5.3f, %5.3f, %5.3f ]\n', kmeans_center_found.' );
%     
%     fprintf('K Means took %4.2f seconds\n\n', kmeans_time );
%     
%     %
%     %  Convert the results of k-means into an image:
%     % 
%     image_by_id     = reshape( cluster_id, size(im,1), size(im,2) );
%     
%     
%     % Build my own custom colormap:
%     my_cmap = kmeans_center_found;
%     
%     % zoom_figure();
%     figure('Position', [10 10 1400 1200] );
%     imagesc( image_by_id );
%     axis image;
%     colormap( my_cmap );
%     colorbar;
%     
%     
%     pause(3);
%     
%     %
%     % Count the number of each color found:
%     %
%     for cluster_number = 1 : size( kmeans_center_found, 1 )
%         binary_mask = (image_by_id == cluster_number);
%         
%         % Count the number of pixels found of this color.
%         n_pix_per_cluster(cluster_number) = sum(binary_mask(:));
%     end
%     
%     % We really only care about the sort key here.
%     % We could say:
%     %
%     % [~,sort_key] = sort( n_pix_per_cluster, 'Ascend' );
%     %
%     [junk_variable,sort_key] = sort( n_pix_per_cluster, 'Ascend' );
%     
%     
%     fprintf('Here we analyze the results.\n');
%     fprintf('In another iteration, we might delete some of these cluster centers.\n\n');
%     fprintf('For example, white and yellow are similar.\n');
%     fprintf('And you do not really care about the white pixels here.\n');
%     fprintf('White is the background color.\n\n');
%     
%     for cluster_number = sort_key
%         
%         binary_mask = (image_by_id == cluster_number);
%         
%         imagesc( binary_mask );
%         axis image;
%         colormap( gray(2) );
%         
%         % Count the number of pixels found of this color.
%         n_pixels_found = sum(binary_mask(:));
%         
%         tmp_str = sprintf('Cluster %d, "%s"', cluster_number, Seed_Pts.Color_name{ cluster_number } );
%         title( tmp_str, 'FontSize', 32 );
%         
%         fprintf('Found %6d pixels of   color number %3d, [%4.2f,%4.2f,%4.2f], "%s", \n', ...
%             n_pixels_found, ...
%             cluster_number, ...
%             kmeans_center_found(cluster_number,:), ...
%             Seed_Pts.Color_name{ cluster_number } );
%         
%         pause(6);
%     end
% end
% 
% 

function HW07_Email1_FIND_RASPBERRIES(raspberry_image)
    GET_USER_INPUT = true;
    
    if nargin < 1
        fn_in = raspberry_image;
    end
    
    im = im2double( imread( raspberry_image ) ) ;
    
    im  = im( 1:4:end, 1:4:end, : );
    
%     zoom_figure( );
    
    imagesc( im );
    axis image;
    
    if ( GET_USER_INPUT )
        %  Get location of raspberries from the user.
        fprintf('Click on the raspberries\n');
        beep();
        [rxs,rys] = ginput(5);


        %  Get location of other pixels from the user.
        fprintf('Click on the NON-raspberries\n');
        beep();
        [bgxs,bgys] = ginput(5);

        save temp_matrix.mat rxs rys bgxs bgys;
%     else
%         load temp_matrix.mat;
    end
    
    %
    %  Get color values -- samples - of the raspberries.
    rxs = round( rxs );
    rys = round( rys );
    for berry_idx = 1 : length( rxs )
        fg_color( berry_idx, 1:3 ) = im( rys(berry_idx), rxs(berry_idx), : );
    end
    
    %  Get other background color values.
    bgxs = round( bgxs );
    bgys = round( bgys );
    for background_idx = 1 : length( bgxs )
        bg_color( background_idx, 1:3 ) = im( bgys(background_idx), bgxs(background_idx), : );
    end
    
    disp('break here');
    
    % 
    %  For each input pixel, figure out distance to the raspberry colors.
    [im_red, im_grn, im_blu] = imsplit( im );
    
    pixel_data = [ im_red(:), im_grn(:), im_blu(:) ];
    
    
    
    %  For each input pixel, find   distance to the background colors.
    %  If a pixel is closer to the raspberry color than to a the other,
    %       classify it as a raspberry
    %  else
    %       call it a background pixel.
    %
   
   
    fg_dist = mahal( pixel_data, fg_color );
    bg_dist = mahal( pixel_data, bg_color );
    
    b_is_fg = fg_dist < bg_dist;
    
    b_is_fg = reshape( b_is_fg, size(im,1), size(im,2) );
    
    imagesc( b_is_fg );
end

function HW07_Email1_FIND_ORAGES(orange_image)
    figure
    imshow(orange_image)
end



end

