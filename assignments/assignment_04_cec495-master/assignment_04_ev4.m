% Bruce Nelson
% Assignment 04
% envelope2

close all; clc; clear all;

StartingFrame = 0;
EndingFrame = 3; %489

for k = StartingFrame : EndingFrame
    I = imread(['envelopes/envelope', ...
        sprintf('%d',k),'.jpg']);

    Imed = medfilt2(I,[100,100]);
    Ifinal = Imed - I;
    BW = Ifinal > 50;

    [H,theta,rho] = hough(BW);
    P = houghpeaks(H,1);
    lines = houghlines(BW, theta, rho, P);


    angle = lines.theta + 90; % Find Angle here
    Irot = imrotate(BW, angle, 'crop');
    imshow(Irot);

    [row, col, page] = size(Irot);  
    Isub = imcrop(Irot, [0 (row-row/3)  col/2 row/3]);
    imshow(Isub);

    se = strel('disk',5);
    Iopen = imopen(Isub, se);
    imshow(Iopen);

    [labels,number] = bwlabel(Iopen,8);
    Istats = regionprops(labels,'basic','BoundingBox');

    hold on;
    for idx = 3:numel(Istats) 
        rectangle('Position', [...
            Istats(idx).BoundingBox(1), ...
            Istats(idx).BoundingBox(2) + 50, ...
            Istats(idx).BoundingBox(3), ...
            Istats(idx).BoundingBox(4)*5],...
            'EdgeColor','r', 'LineWidth', 3)
    end
    
    % Save each image
    pause;
end
