% Bruce Nelson
% Assignment 03 (6)

close all; clear all; clc;

StartingImage = 2;
EndingImage = 9;

for k = StartingImage : EndingImage-1

    Irgb = imread(['impellers/rotor', ...
          sprintf('%2.2d',k),'.jpg']);
     
     %Irgb = imread('impellers/rotor07.jpg');
       
    Ihsv = rgb2hsv(Irgb);
    I = Ihsv(:,:,3); % take 3 value channel out (for grayscale)

    BW = edge(I,'canny', [0.10,0.70], .8); % hysteresis, gamma (blur)

    se1 = strel('line',3,45);
    se2 = strel('line',3,61);
    BW = imdilate(BW, [se1,se2]);

    BWfill = imfill(BW, 'holes');
    BWnobord = imclearborder(BWfill, 4);

    [labels,number] = bwlabel(BWnobord,8);
    box = regionprops(labels,'basic','Centroid');

    imshow(BWnobord);
    rectangle('Position', box.BoundingBox, 'EdgeColor', 'r');

    x_dist = box.BoundingBox(3) - box.BoundingBox(1);
    y_dist = box.BoundingBox(4) - box.BoundingBox(2);

    x_rad = x_dist/2;
    y_rad = y_dist/2;

    if x_rad >= y_rad
        rad = x_rad;
    else
        rad = y_rad; 
    end

    viscircles([box.Centroid(1), box.Centroid(2)], rad);

    pause;

end




