dispLevels = 16;
referenceImage = 'left'; %or 'right'
occludedArea = 'inside'; %or 'outside'

% Read the (grayscale) disparity image
disparityIn = imread('disparity.png');

% Convert disparity image to disparity map
scaleFactor = 256/dispLevels;
disparityMap = double(disparityIn)/scaleFactor;

% Get the image size
[rows,cols] = size(disparityIn);

if (strcmp(referenceImage,'left') && strcmp(occludedArea,'inside')) || (strcmp(referenceImage,'right') && strcmp(occludedArea,'outside'))
    % Left to right scan
    for y = 1:rows
        pixel0 = disparityMap(y,1);
        for x = 2:cols
            pixel1 = disparityMap(y,x);
            if strcmp(referenceImage,'left') %left/inside
                if pixel0 >= pixel1
                    pixel0 = pixel1;
                else
                    disparityMap(y,x) = 0;
                    pixel0 = pixel0+1;
                end
            else %right/outside
                if pixel0 <= pixel1
                    pixel0 = pixel1;
                else
                    disparityMap(y,x) = 0;
                    pixel0 = pixel0-1;
                end
            end
        end
    end
else
    % Right to left scan
    for y = 1:rows
        pixel0 = disparityMap(y,cols);
        for x = cols-1:-1:1
            pixel1 = disparityMap(y,x);
            if strcmp(referenceImage,'left') %left/outside
                if pixel0 <= pixel1
                    pixel0 = pixel1;
                else
                    disparityMap(y,x) = 0;
                    pixel0 = pixel0-1;
                end
            else %right/inside
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