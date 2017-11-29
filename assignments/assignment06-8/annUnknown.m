function UPattern = annUnknown(Igray)
    BW = ~im2bw(Igray);

    SE = strel('disk',2);
    BW2 = imdilate(BW, SE); 

    labels = bwlabel(BW2);
    Iprops = regionprops(labels);

    Iprops( [Iprops.Area] < 1000 ) = [];
    num = length( Iprops );

    Ibox = floor( [Iprops.BoundingBox] );
    Ibox = reshape(Ibox,[4 num]);


    for k = 1:num
        col1 = Ibox(1,k);
        col2 = Ibox(1,k) + Ibox(3,k);
        row1 = Ibox(2,k);
        row2 = Ibox(2,k) + Ibox(4,k);

        subImage = BW2(row1:row2, col1:col2);
        subImageScaled = imresize(subImage, [24 12]);
        UPattern(k,:) = subImageScaled(:)';
    end

    UPattern = UPattern';
end