dispLevels = 16;
referenceImage = 'left'; %or 'right'
rightToLeftScan = false;

% Read the (grayscale) disparity image
disparityIn = imread('disparity.png');

% Convert disparity image to disparity map
scaleFactor = 256/dispLevels;
disparityMap = double(disparityIn)/scaleFactor;

% Get the image size
[rows,cols] = size(disparityIn);

% Left to right scan
if rightToLeftScan == false
    for y = 1:rows
        pixel0 = disparityMap(y,1);
        for x = 2:cols
            pixel1 = disparityMap(y,x);
            if strcmp(referenceImage,'left')
                if pixel0 >= pixel1
                    pixel0 = pixel1;
                else
                    disparityMap(y,x) = 0;
                    pixel0 = pixel0+1;
                end
            else
                if pixel0 <= pixel1
                    pixel0 = pixel1;
                else
                    disparityMap(y,x) = 0;
                    pixel0 = pixel0-1;
                end
            end
        end
    end
end

% Right to left scan
if rightToLeftScan == true
    for y = 1:rows
        pixel0 = disparityMap(y,cols);
        for x = cols-1:-1:1
            pixel1 = disparityMap(y,x);
            if strcmp(referenceImage,'left')
                if pixel0 <= pixel1
                    pixel0 = pixel1;
                else
                    disparityMap(y,x) = 0;
                    pixel0 = pixel0-1;
                end
            else
                if pixel0 >= pixel1
                    pixel0 = pixel1;
                else
                    disparityMap(y,x) = 0;
                    pixel0 = pixel0+1;
                end
            end
        end
    end
end

% Update disparity image
disparityOut = uint8(disparityMap*scaleFactor);

% Show disparity image
imshow(disparityOut)
    
% Save disparity image
imwrite(disparityOut,'disparity_out.png')