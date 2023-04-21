function HW_05_Ashwathsreedhar_Halemane( )

show_all_files_in_dir()
    function show_all_files_in_dir( )

        file_list = dir('../TEST_IMAGES/*.jpg');

        for counter = 1:length(file_list)
            fn = file_list(counter).name;
                 fprintf("INPUT Filename:    %s", fn)
                 diceAndItsDotsCount(fn);
        end
    end



    function diceAndItsDotsCount(ImageName)
            % read the image and resize since the original image is of
            % higher dimensions taking long time to process
            name = strcat('../TEST_IMAGES/', ImageName);
            originalImage = imresize(imread(name), [1200 1000]);
            redRemoved = originalImage;
            
            % pre-processing tasks to avoid red lettering, I am converting
            % red channel into white ones since the dice is white, making
            % it less difficult to count dots inside the dice
            allBlack = ones(size(redRemoved, 1), size(redRemoved, 2), 'uint8');
            blueChannel = redRemoved(:,:,2);
            greenChannel = redRemoved(:,:,3);
            redChannelRemoved = cat(3, allBlack, greenChannel, blueChannel);
            % converting image to grayscale since the upcoming tasking
            % needs to be in 2D and for other logical images
            redChannelRemoved = rgb2gray(redChannelRemoved);
            
            % remove noise using median filter to remove small white noise
            % and other noise as well
            medianFilteredImage = medfilt2(redChannelRemoved);
           
            % using threshold to binarize well  
            threshold = graythresh(medianFilteredImage);
            % image segmentation to black and white pixel making it easier
            % to process 
            processedImage = imbinarize(medianFilteredImage, threshold);
            
            % removing small object from processed image
            processedImage=bwareaopen(processedImage,60);
            
            % finding connected components of the image
            cc = bwconncomp(processedImage);
            diceLabels = labelmatrix(cc);
            totalNumberOfDice = cc.NumObjects;
            numberOfOnes=0;
            numberOfTwos=0;
            numberOfThrees=0;
            numberOfFours=0;
            numberOfFives=0;
            numberOfSixes=0;
            numberOfUnknown=0;
            
            for i = 1:cc.NumObjects
                thisDice = diceLabels==i;
                % detect amd remove small noise by filling holes and
                % performing logical AND with complement of the same image
                thisDots = bwareaopen(imfill(thisDice,'holes') & ~thisDice, 50);
                % finding componenets in each dice to count dots 
                dotsCC = bwconncomp(thisDots);
                n = dotsCC.NumObjects;
                
                switch n
                    case 1
                        numberOfOnes=numberOfOnes+1;
                    case 2
                        numberOfTwos=numberOfTwos+1;
                    case 3
                        numberOfThrees=numberOfThrees+1;
                    case 4
                        numberOfFours=numberOfFours+1;
                    case 5
                        numberOfFives=numberOfFives+1;
                    case 6
                        numberOfSixes=numberOfSixes+1;
                    otherwise
                        numberOfUnknown=numberOfUnknown+1;
                end
            
            end
            
            % printing the required output
            sprintf("Number of dice:    %d", totalNumberOfDice)
            sprintf("Number of 1's:     %d",numberOfOnes)
            sprintf("Number of 2's:     %d",numberOfTwos)
            sprintf("Number of 3's:     %d",numberOfThrees)
            sprintf("Number of 4's:     %d",numberOfFours)
            sprintf("Number of 5's:     %d",numberOfFives)
            sprintf("Number of 6's:     %d",numberOfSixes)
            sprintf("Number of Unknowns:     %d",numberOfUnknown)
            
            totalDots = numberOfOnes*1 + numberOfTwos*2 + numberOfThrees*3 + numberOfFours*4 + numberOfFives*5 + numberOfSixes * 6;
            sprintf("Total number of dots:      %d", totalDots)
            
            % labeling various components of the image 
            [labeledImage, numberOfDiceFromBwlabel] = bwlabel(processedImage, 8);     

            figure
            imshow(labeledImage, []);
            
            props = regionprops(labeledImage, redChannelRemoved, 'all');
            disp(props);
            numberOfDiceFromRegionProps = numel(props);
            
            % drawing cyan border around dice
            % to avoid drawing boundaries inside the dice on dots we use imfill and
            % pass holes as param
            BW2 = imfill(processedImage, 'holes');
            boundaries = bwboundaries(BW2); % Note: this is a cell array with several boundaries -- one boundary per cell.
            
            numberOfBoundaries = size(boundaries, 1); % Count the boundaries so we can use it in our for loop
            
            hold on; % Don't let boundaries blow away the displayed image.
            for k = 1 : numberOfBoundaries
	            thisBoundary = boundaries{k}; % Get boundary for this specific blob.
	            x = thisBoundary(:,2); % Column 2 is the columns, which is x.
	            y = thisBoundary(:,1); % Column 1 is the rows, which is x.
	            plot(x, y, 'c-', 'LineWidth', 2); % Plot boundary in red.
            end
            hold off;

        end
end

