
function Divide_Raspberries( fn_in )

%  Get location of raspberries from the user.
%  Get location of other pixels from the user.
%
%  Get color values -- samples - of the raspberries.
%  Get other color values.
% 
%  For each input pixel, figure out distance to the raspberry colors.
%  For each input pixel, find   distance to the background colors.
%  If a pixel is closer to the raspberry color than to a the other,
%       classify it as a raspberry
%  else
%       call it a background pixel.
%
GET_USER_INPUT = false;
    
    if nargin < 1
        fn_in = 'Img_Example__Raspberry_Image.jpg';
    end
    
    im = im2double( imread( fn_in ) ) ;
    
    im  = im( 1:4:end, 1:4:end, : );
    
    zoom_figure( );
    
    imagesc( im );
    axis image;
    
    if ( GET_USER_INPUT )
        %  Get location of raspberries from the user.
        fprintf('Click on the raspberries\n');
        beep();
        [rxs,rys] = ginput();


        %  Get location of other pixels from the user.
        fprintf('Click on the NON-raspberries\n');
        beep();
        [bgxs,bgys] = ginput();

        save temp_matrix.mat rxs rys bgxs bgys;
    else
        load temp_matrix.mat;
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