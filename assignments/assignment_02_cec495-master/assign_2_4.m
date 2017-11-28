% assignment 2
% Bruce Nelson

% Tracking blue ball and green soccer ball
% First mask is the blue ball
% Second mask is the yellow on the green soccer ball

close all; clear all; clc;

StartingFrame = 1;
EndingFrame = 489; %489

Xcentroid1 = [];
Ycentroid1 = [];
Xcentroid2 = [];
Ycentroid2 = [];

for k = StartingFrame : EndingFrame-1
    
    rgb = imread(['balls/img', ...
        sprintf('%2.3d',k),'.jpg']);
        
    img1 = createMask1(rgb);

    [labels,number] = bwlabel(img1,8);
    
    if number ~= 0
        Istats = regionprops(labels,'basic','Centroid');
        [values, index] = sort([Istats.Area], 'descend');
        [maxVal, maxIndex] = max([Istats.Area]);
        
        Xcentroid1 = [Xcentroid1 Istats(maxIndex).Centroid(1)];
        Ycentroid1 = [Ycentroid1 Istats(maxIndex).Centroid(2)];
    end
    
    img2 = createMask2(rgb);

    [labels,number] = bwlabel(img2,8);
    
    if number ~= 0
        Istats = regionprops(labels,'basic','Centroid');
        [values, index] = sort([Istats.Area], 'descend');
        [maxVal, maxIndex] = max([Istats.Area]);
        
        Xcentroid2 = [Xcentroid2 Istats(maxIndex).Centroid(1)];
        Ycentroid2 = [Ycentroid2 Istats(maxIndex).Centroid(2)];
    end
    
end

imshow(rgb);
hold on;
scatter(Xcentroid1, Ycentroid1, 'g');
hold on;
scatter(Xcentroid2, Ycentroid2, 'y');