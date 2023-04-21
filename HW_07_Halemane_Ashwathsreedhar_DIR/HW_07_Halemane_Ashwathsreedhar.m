function HW_07_Halemane_Ashwathsreedhar()
% 
% current_working_directory = pwd
% 
% disp(current_working_directory) 

secret_message_image = 'HW_07_Halemane_Ashwathsreedhar_DIR/ZIP_FILE_OF_IMAGES_for_SEMESTER_2225/Img431_SCAN275__Secret_Mess.jpg';
raspberry_image = 'HW_07_Halemane_Ashwathsreedhar_DIR/ZIP_FILE_OF_IMAGES_for_SEMESTER_2225/Raspberry_Image.jpg';
orange_image = 'HW_07_Halemane_Ashwathsreedhar_DIR/ZIP_FILE_OF_IMAGES_for_SEMESTER_2225/Orange_Image.jpg';

HW07_Email1_Cluster_Colors(secret_message_image)
HW07_Email1_FIND_RASPBERRIES(raspberry_image)
HW07_Email1_FIND_ORAGES(orange_image)

% HWNN_Email1_Cluster_Colors ( ‘ Img_Some__Secret_Mess.jpg ‘ ); (3 pts)
% This reads in any one of the secret messages, and using k-Means, segments them into different colors.
% Render each color separation that your program finds as white, on a black background.
% Use kmeans to find the cluster centers, and then minimum Mahalanobis distance to find which cluster each pixel belongs in.
% Describe in your write-up, how you achieved this separation. What did you do, what issues did you face?
% Update: the Mahalanobis distance is no longer an option for Matlab’s kmeans( ) routine.
% I have found that using the Squared Euclidean distance works fine. Minimizing the squared Euclidean distance is
% the same as minimizing the Euclidean distance, because squaring is a monotonic function – it does not change the
% relative order.
% You will find that using the Squared Euclidean distances works especially well in a color space that is nearly
% perceptually uniform. (*hint*) Do not be surprised if kmeans takes a long time to run on a large image. It will run
% faster on a sub-sampled smaller image. You might want to test your technique on a smaller image.
% For increased speed, it is possible to sub-sample the image significantly, then find the cluster centers for kmeans,
% and then use the cluster centers from the sub-sampled image as seed points for the original larger image. This
% makes the final run much faster since it is starting with centers that are nearly the final cluster centers.
% Remember: for kmeans, you need to tell it ahead of time how many clusters to create. You might want to create an extra
% “catch all” cluster for noise points.
% I have found that telling the code to generate 8 clusters for 6 colored pens seems to work well. Your results will be different.
% If you want to cheat, it is perfectly legal for you to pre-seed kMeans with the initial seeds that you think might be good
% starting points. For example, black ink would be [ 0, 0, 0 ] and white paper would be [1,1,1] in RGB color space. In CIELab
% (lab) color space, the colors are different. For example, the purple pen might be [ 45, 35, -45 ], or something, and green might
% be [50, -40, 10]. See the documentation for kmeans on how to pre-seed the clusters with initial “centers” even if the colors are
% not the centers of the clusters.
% Using End Members: You can seed clusters with “end members.” End members are idealized points that are far from other
% colors. For example, the color [ 40, 0, -45 ] in CIELab color space might not be the color of the blue ink that was used.
% However, this might be a great starting point for blue because it is far from the other colors used, and it will shift towards the
% true color of the blue ink.
% If you seed your clusters with a cluster center, describe how you seeded them, and how you decided on your seeds. AND, in
% your conclusion point out that you did this.

function HW07_Email1_Cluster_Colors(secret_message_image)
    figure
    imshow(secret_message_image)
end



function HW07_Email1_FIND_RASPBERRIES(raspberry_image)
    figure
    imshow(raspberry_image)
end

function HW07_Email1_FIND_ORAGES(orange_image)
    figure
    imshow(orange_image)
end



end

