function [SomeImage, SomeImageScaled] = imageScaled(Igray)

SomeImage = {};
SomeImageScaled = {};

Ithresh = Igray > 200;
imshow(Ithresh);

BW = imcomplement(Ithresh);
imshow(BW);

SE = strel('disk',2);
BW2 = imdilate(BW, SE);

imshow(BW2);

[labels,number] = bwlabel(BW2,8);

Istats = regionprops(labels,'basic','BoundingBox');
Istats( [Istats.Area] < 1000) = [];
num = length( Istats );

Ibox = floor( [Istats.BoundingBox] );
Ibox = reshape(Ibox,[4 num]);

hold on;
for k = 1:num
    rectangle('position',Ibox(:,k), ...
        'edgecolor', 'r', 'LineWidth', 3);
end

for k = 1:num
    col1 = Ibox(1,k);
    col2 = col1 + Ibox(3,k);
    row1 = Ibox(2,k);
    row2 = row1 + Ibox(4,k);
    subImage = BW2(row1:row2, col1:col2);
    SomeImage{k} = subImage;
    SomeImageScaled{k} = ...
        imresize(subImage, [24,12]);
end

% Displays the images, uncomment to display
%for k = 1:num
%    figure, imshow(SomeImage{k});
%    figure, imshow(SomeImageScaled{k});
%end

end