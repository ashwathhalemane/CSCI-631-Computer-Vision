
function Junk_Kmeans_Example( fn_in )

    if ( nargin < 1 )
        fn_in = 'Img431_Scan291__Secret_Mess_Exam_Hints__300dpi.jpg';
    end
    
    im = im2double( imread( fn_in ));

    im = im( 2:2:end, 2:2:end, : );
    
    im_red  = im( :, :, 1 );
    im_grn  = im( :, :, 2 );
    im_blu  = im( :, :, 3 );
    
    data = [ im_red(:) , im_grn(:) , im_blu(:) ];
    
    % Why would Dr. K use these colors to start with??
    Seed_Pts.Color_Starting_Point = [ ...
       0.0000 0.0000 0.0000 ;   % Black
       1.0000 0.0000 0.0000 ;   % Red
       0.0000 0.9000 0.0000 ;   % Green
       0.0000 0.0000 1.0000 ;   % Blue
       1.0000 0.0000 1.0000 ;   % Magenta
       0.2000 0.4000 0.4000 ;   % Cyan
       1.0000 1.0000 0.0000 ;   % Yellow
       1.0000 1.0000 1.0000 ;   % White
       0.7000 0.7000 0.0000 ;   % Brown -- Dark Yellow
       0.7000 0.4000 0.0000 ;   % Pinkish or maybe orangish
       0.4000 0.4000 0.4000 ;   % Dark gray
       0.8000 0.8000 0.8000 ;   % Light gray
    ];
    Seed_Pts.Color_name = { 
        'Black', ...
        'Red', ...
        'Green', ...
        'Blue', ...
        'Magenta', ...
        'Cyan', ...
        'Yellow', ...
        'White', ...
        'Brown', ...
        'Pinkish', ...
        'Dark Gray', ...
        'Light Gray' };
    
    % Check for stupid mistakes:
    %
    % Assertions are checked once, and then ignored later.
    % They are used for good code development, and checks when debugging.
    %
    % The released code ignores these.
    %
    assert( length( Seed_Pts.Color_Starting_Point ) == length( Seed_Pts.Color_name ) );
    
    n_seeds     = size( Seed_Pts.Color_Starting_Point, 1 );

    % Lengths returns the longest dimension of an array, so this would work too,
    % as long as there are more then 3 seed points:
    n_seeds     = length( Seed_Pts.Color_Starting_Point );

    
    % Time the process of running kmeans:
    tic();
    [cluster_id, kmeans_center_found] = kmeans( data, n_seeds, 'start', Seed_Pts.Color_Starting_Point );
    kmeans_time = toc();
    
    fprintf('K Means Centers found:\n');
    fprintf(' [ %5.3f, %5.3f, %5.3f ]\n', kmeans_center_found.' );
    
    fprintf('K Means took %4.2f seconds\n\n', kmeans_time );
    
    %
    %  Convert the results of k-means into an image:
    % 
    image_by_id     = reshape( cluster_id, size(im,1), size(im,2) );
    
    
    % Build my own custom colormap:
    my_cmap = kmeans_center_found;
    
    % zoom_figure();
    figure('Position', [10 10 1400 1200] );
    imagesc( image_by_id );
    axis image;
    colormap( my_cmap );
    colorbar;
    
    
    pause(3);
    
    %
    % Count the number of each color found:
    %
    for cluster_number = 1 : size( kmeans_center_found, 1 )
        binary_mask = (image_by_id == cluster_number);
        
        % Count the number of pixels found of this color.
        n_pix_per_cluster(cluster_number) = sum(binary_mask(:));
    end
    
    % We really only care about the sort key here.
    % We could say:
    %
    % [~,sort_key] = sort( n_pix_per_cluster, 'Ascend' );
    %
    [junk_variable,sort_key] = sort( n_pix_per_cluster, 'Ascend' );
    
    
    fprintf('Here we analyze the results.\n');
    fprintf('In another iteration, we might delete some of these cluster centers.\n\n');
    fprintf('For example, white and yellow are similar.\n');
    fprintf('And you do not really care about the white pixels here.\n');
    fprintf('White is the background color.\n\n');
    
    for cluster_number = sort_key
        
        binary_mask = (image_by_id == cluster_number);
        
        imagesc( binary_mask );
        axis image;
        colormap( gray(2) );
        
        % Count the number of pixels found of this color.
        n_pixels_found = sum(binary_mask(:));
        
        tmp_str = sprintf('Cluster %d, "%s"', cluster_number, Seed_Pts.Color_name{ cluster_number } );
        title( tmp_str, 'FontSize', 32 );
        
        fprintf('Found %6d pixels of   color number %3d, [%4.2f,%4.2f,%4.2f], "%s", \n', ...
            n_pixels_found, ...
            cluster_number, ...
            kmeans_center_found(cluster_number,:), ...
            Seed_Pts.Color_name{ cluster_number } );
        
        pause(6);
    end
    
end

