% Assignment 6
% Bruce Nelson

Igray = imread('ann/training.jpg');

Ithresh = Igray > 200;
imshow(Ithresh);

BW = imcomplement(Ithresh);
imshow(BW);

SE = strel('disk',2);
BW2 = imdilate(BW, SE);
% possible use erode to improve accuracy

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
    subImageScaled = imresize(subImage, [24 12]);
    TPattern(k,:) = subImageScaled(:)';
        
end


TTarget = zeros(100,10);

for row = 1:10
    for col = 1:10
        TTarget( 10*(row-1) + col, row) = 1;
    end
end

TPattern = TPattern';
TTarget = TTarget';

net = newff( ...
    [zeros(299,1) ones(288,1)], ...
    [24 10], ...
    {'logsig' 'logsig'}, ...
    'traingdx' );

net.trainParam.epochs = 500;
net = train(net, TPattern, TTarget);
Y = sim(net, UPattern);
disp(Y);


