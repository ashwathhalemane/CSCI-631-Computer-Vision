function HW_01_Ashwathsreedhar_Halemane(image_name);

% read image from function
my_profile_pic = imread(image_name);
% greyscaling the image using green channel
my_profile_green_channel = my_profile_pic(:,:, 2);
% rotate/tilt the image
right_titled_profile_pic_2 = imrotate(my_profile_green_channel, 10,'bilinear','crop');
% save the titled image
imwrite(right_titled_profile_pic_2,'right_tilted_profile.png');

% calculations for imcrop function
size_of_tilted = size(right_titled_profile_pic_2);
x_centroid = size_of_tilted(1)/2;
y_centroid = size_of_tilted(2)/2;
size_of_square = 100;
xmin = x_centroid-size_of_square/2;
ymin = y_centroid-size_of_square/2;

% crop square of 100 
HW_01_Dynamic_Ashwathsreedhar_Halemane = imcrop(right_titled_profile_pic_2, [xmin ymin size_of_square size_of_square]);
imwrite(HW_01_Dynamic_Ashwathsreedhar_Halemane, 'HW_01_Dynamic_Ashwathsreedhar_Halemane.jpg');

% plotting sine wave
x = 0:1080;
y = sind(x);
plot(x,y)
axis tight;
xlabel('Degrees', 'Fontsize', 18 );
ylabel('Sine of Theta', 'FontSize', 18 );
% to get the handle to current axis to save the plot as required
ax = gca;

exportgraphics(ax, 'sine_wave.png');

end
