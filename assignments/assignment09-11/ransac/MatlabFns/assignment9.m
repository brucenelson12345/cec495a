% Akhan Almagambetov, almagama@erau.edu
% RANSAC-based Image Stabilization

close all; clear all; clc;
addpath(genpath('MatlabFns'));

mkdir('_output');

StartingFrame = 0;
EndingFrame = 2;

%StartingFrame = 3;
%EndingFrame = 4;

directory = 'img/';

for k = StartingFrame : EndingFrame
    
    % Reading in images.. if past the first frame, use the Jregistered
    % image from the previous step as pos1, and load a new image into pos2
    if k == 1
        pos1 = imread([directory, sprintf('%d',k),'.jpg']);
        pos2 = imread([directory, sprintf('%d',k+1),'.jpg']);
    else
        pos1 = Jregistered;
        pos2 = imread([directory, sprintf('%d',k+1),'.jpg']);
    end
    
    % Convert images to grayscale (necessary for Harris corner detection)
    Im1 = rgb2gray(pos1);
    Im2 = rgb2gray(pos2);  

    % Harris corner detection on both images.. a lower threshold results in
    % more corners being detected.  The CIM1 and CIM2 results are ignored.
    HarrisThresh = 10;
    
    [cim1, r1, c1] = harris(Im1, 1, HarrisThresh, 3);
    [cim2, r2, c2] = harris(Im2, 1, HarrisThresh, 3);

    % Roughly matching all of the corners by correlation
    [m1,m2] = matchbycorrelation(Im1, [r1';c1'], Im2, [r2';c2'], 21, 50);

    % RANSAC
    [H, inliers] = ransacfithomography(m1, m2, 0.001);
    
    % Moving = second frame, Fixed = first frame or Jregistered
    fixedPoints = [m1(2,inliers)' m1(1,inliers)'];
    movingPoints = [m2(2,inliers)' m2(1,inliers)'];
     
    % Determining the transform based on the relationship matrices between
    % the coordinates in the two images
    tform = fitgeotrans(movingPoints,fixedPoints,'NonreflectiveSimilarity');
    
    % Image registration (alignment)
    Jregistered = imwarp(pos2,tform,'OutputView',imref2d(size(pos1)));
    falsecolorOverlay = imfuse(pos1,Jregistered);

    % Putting everything together into a 2x2 image
    I1 = cat(2,pos2,Jregistered);
    im1rgb = cat(3,Im1,Im1,Im1);
    I2 = cat(2,im1rgb,falsecolorOverlay);
    I = cat(1,I1,I2);
    
    %%% SURF ON I1 and I2
    MySurf(I1,I2);
    %%% MYSURF

    % Accounting for the concatenation
    shiftY = size(Im1,1);
    shiftX = size(Im1,2);

    % Displaying the four images
    imshow(I,'Border','tight'); hold on;

    % Plotting the relationships between POS1 and POS2 images (RANSAC
    % results only at this point)
    plot(m1(2,inliers),m1(1,inliers)+shiftY,'r+');
    plot(m2(2,inliers),m2(1,inliers)+shiftY,'b+');    

    for n = inliers
        line([m1(2,n) m2(2,n)], [m1(1,n)+shiftY m2(1,n)+shiftY],'color',[1 1 0])
    end
   
    clf;
end