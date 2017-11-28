close all; clear all; clc;

StartingFrame = 1;
EndingFrame = 448;

Xcentroid = [];
Ycentroid = [];

for k = StartingFrame : EndingFrame-1
    
    rgb1 = imread(['ant/img', ...
        sprintf('%2.3d',k),'.jpg']);
    rgb2 = imread(['ant/img', ...
        sprintf('%2.3d',k+1),'.jpg']);
    
    diff = abs(rgb1 - rgb2);
    hsv = rgb2hsv(diff);
    I = hsv(:,:,3);
    Ithresh = I > 0.07;

    [labels,number] = bwlabel(Ithresh,8);
    
    if number ~= 0
        Istats = regionprops(labels,'basic','Centroid');
        [values, index] = sort([Istats.Area], 'descend');
        [maxVal, maxIndex] = max([Istats.Area]);
        
        Xcentroid = [Xcentroid Istats(maxIndex).Centroid(1)];
        Ycentroid = [Ycentroid Istats(maxIndex).Centroid(2)];
    end

    
end

imshow(rgb2);

hold on;

plot(Xcentroid, Ycentroid, 'g');
