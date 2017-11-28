clear all; close all; clc;

pos1 = imread('ant/img008.jpg');
pos2 = imread('ant/img009.jpg');

diff = abs(pos1-pos2);
hsv = rgb2hsv(diff);
I = hsv(:,:,3);
Ithresh = I > 0.1;
imshow(Ithresh);

[labels,number] = bwlabel(Ithresh,8);
Istats = regionprops(labels,'basic','Centroid');
[values, index] = sort([Istats.Area], 'descend');
[maxVal, maxIndex] = max([Istats.Area]);

Istats(maxIndex).Centroid;
Istats(maxIndex).Centroid(1);
Istats(maxIndex).Centroid(2);
Istats(maxIndex).BoundingBox;

hold on;

rectangle('Position', ...
    [Istats(maxIndex).BoundingBox], ...
    'LineWidth',2,'EdgeColor','g');

hold on;

plot(Istats(maxIndex).Centroid(1), ...
    Istats(maxIndex).Centroid(2), 'r*');

text(Istats(maxIndex).Centroid(1)+10, ...
    Istats(maxIndex).Centroid(2)+10, 'Object', ...
    'fontsize',20, 'color','r','fontweight','bold');



